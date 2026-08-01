import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/data/datasources/local/task_local_data_source.dart';
import 'package:offline_engine/feature/presentation/enums/sync_operations.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: TaskLocalDataSource)
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final AppDatabase database;

  TaskLocalDataSourceImpl(this.database);

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

      return right(true);
    } catch (e) {
      log(e.toString());
      return left(ApiFailure.unknown(e.toString()));
    }
  }
}
