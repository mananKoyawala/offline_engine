import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/tasks/data/datasources/local/task_local_data_source.dart';
import 'package:offline_engine/feature/tasks/presentation/enums/sync_operations.dart';
import 'package:offline_engine/service/sync_event_bus/sync_event_bus.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: TaskLocalDataSource)
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final AppDatabase database;
  final SyncEventBus _syncEventBus;

  TaskLocalDataSourceImpl(this.database, this._syncEventBus);

  @override
  Future<Either<ApiFailure, List<TaskItem>>> getTasks() async {
    try {
      final result = await (database.select(
        database.tasks,
      )..where((t) => t.deletedAt.isNull())).get();

      return right(result.map(TaskItem.fromDrift).toList());
    } catch (e) {
      return left(ApiFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<ApiFailure, bool>> insertTask(CreateTaskParams task) async {
    final taskId = const Uuid().v4();
    try {
      await database.transaction(() async {
        await database
            .into(database.tasks)
            .insert(
              TasksCompanion(
                id: Value(taskId),
                title: Value(task.title),
                description: Value(task.description),
                priority: Value(task.priority.value),
                version: const Value(0),
              ),
            );

        await database
            .into(database.syncOperations)
            .insert(
              SyncOperationsCompanion(
                taskId: Value(taskId),
                status: Value(SyncStatus.pending.status),
                payload: Value(jsonEncode({...task.toJson(), 'version': 0})),
                type: Value(SyncOperations.create.type),
              ),
            );
      });

      _syncEventBus.notifyTaskWritten();
      return right(true);
    } catch (e) {
      log(e.toString());
      return left(ApiFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<ApiFailure, bool>> updateTask(UpdateTaskParams task) async {
    try {
      await database.transaction(() async {
        final updatedTask =
            await (database.update(
              database.tasks,
            )..where((t) => t.id.equals(task.id))).writeReturning(
              TasksCompanion(
                title: Value(task.title),
                description: Value(task.description),
                priority: Value(task.priority.value),
                isCompleted: Value(task.isCompleted),
              ),
            );

        final updated = updatedTask.single;

        await database
            .into(database.syncOperations)
            .insert(
              SyncOperationsCompanion(
                taskId: Value(task.id),
                status: Value(SyncStatus.pending.status),
                payload: Value(
                  jsonEncode({...task.toJson(), 'version': updated.version}),
                ),
                type: Value(SyncOperations.update.type),
              ),
            );
      });

      _syncEventBus.notifyTaskWritten();
      return right(true);
    } catch (e) {
      return left(ApiFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<ApiFailure, bool>> deleteTask(UpdateTaskParams task) async {
    try {
      await database.transaction(() async {
        final deletedTask =
            await (database.update(
              database.tasks,
            )..where((t) => t.id.equals(task.id))).writeReturning(
              TasksCompanion(deletedAt: Value(DateTime.now())),
            );

        final deleted = deletedTask.single;

        await database
            .into(database.syncOperations)
            .insert(
              SyncOperationsCompanion(
                taskId: Value(task.id),
                payload: Value(
                  jsonEncode({...task.toJson(), 'version': deleted.version}),
                ),
                status: Value(SyncStatus.pending.status),
                type: Value(SyncOperations.delete.type),
              ),
            );
      });

      _syncEventBus.notifyTaskWritten();
      return right(true);
    } catch (e) {
      log(e.toString());
      return left(ApiFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<ApiFailure, bool>> upsertTasksFromRemote(
    List<TaskItem> remoteTasks,
  ) async {
    try {
      // Collect task IDs that have at least one pending sync operation.
      // These are local changes not yet confirmed by the server → skip them
      // so we don't overwrite the user's in-flight edits.
      final pendingRows = await (database.selectOnly(database.syncOperations)
            ..addColumns([database.syncOperations.taskId])
            ..where(
              database.syncOperations.status.equals(SyncStatus.pending.status),
            ))
          .get();

      final pendingTaskIds = pendingRows
          .map((r) => r.read(database.syncOperations.taskId))
          .whereType<String>()
          .toSet();

      await database.transaction(() async {
        for (final remote in remoteTasks) {
          final id = remote.id;
          if (id == null) continue;

          // Skip tasks the user has locally modified but not yet synced.
          if (pendingTaskIds.contains(id)) continue;

          final existing =
              await (database.select(
                database.tasks,
              )..where((t) => t.id.equals(id))).getSingleOrNull();

          if (existing == null) {
            // New task from server — insert it.
            await database.into(database.tasks).insert(
              TasksCompanion(
                id: Value(id),
                title: Value(remote.title ?? ''),
                description: Value(remote.description),
                priority: Value(remote.priority ?? 0),
                isCompleted: Value(remote.isCompleted),
                version: Value(remote.version),
              ),
            );
          } else if (remote.version >= existing.version) {
            // Server version is same or newer — overwrite local.
            // (For non-pending tasks, server is the source of truth.)
            await (database.update(database.tasks)
                  ..where((t) => t.id.equals(id)))
                .write(
                  TasksCompanion(
                    title: Value(remote.title ?? ''),
                    description: Value(remote.description),
                    priority: Value(remote.priority ?? 0),
                    isCompleted: Value(remote.isCompleted),
                    version: Value(remote.version),
                    updatedAt: Value(DateTime.now()),
                  ),
                );
          }
          // If remote.version <= existing.version, local is already up-to-date.
        }
      });

      return right(true);
    } catch (e) {
      log(e.toString());
      return left(ApiFailure.unknown(e.toString()));
    }
  }
}
