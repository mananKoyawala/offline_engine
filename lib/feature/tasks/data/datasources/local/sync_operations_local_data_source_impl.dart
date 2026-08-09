import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/database/app_database.dart';
import 'package:offline_engine/feature/tasks/data/datasources/local/sync_operations_local_data_source.dart';
import 'package:offline_engine/feature/tasks/data/models/sync_operation_item.dart';
import 'package:offline_engine/feature/tasks/presentation/enums/sync_operations.dart';
import 'package:offline_engine/service/conflict_resolver/conflict_resolver_params.dart';

@LazySingleton(as: SyncOperationsLocalDataSource)
class SyncOperationsLocalDataSourceImpl
    implements SyncOperationsLocalDataSource {
  final AppDatabase database;

  SyncOperationsLocalDataSourceImpl(this.database);

  @override
  Future<Either<ApiFailure, List<SyncOperationItem>>>
  getSyncOperations() async {
    try {
      final result = await database.select(database.syncOperations).get();

      return right(result.map(SyncOperationItem.fromDrift).toList());
    } catch (e) {
      return left(ApiFailure.unknown(e.toString()));
    }
  }

  @override
  Stream<Either<ApiFailure, List<SyncOperationItem>>>
  getSyncOperationsStream() {
    try {
      return database
          .select(database.syncOperations)
          .watch()
          .map(
            (rows) => right<ApiFailure, List<SyncOperationItem>>(
              rows.map(SyncOperationItem.fromDrift).toList(),
            ),
          )
          .handleError(
            (e) => left<ApiFailure, List<SyncOperationItem>>(
              ApiFailure.unknown(e.toString()),
            ),
          );
    } catch (e) {
      return Stream.value(left(ApiFailure.unknown(e.toString())));
    }
  }

  @override
  Stream<int> getPendingCount() {
    try {
      return database
          .select(database.syncOperations)
          .watch()
          .map(
            (rows) => rows
                .where((row) => row.status == SyncStatus.pending.status)
                .length,
          );
    } catch (e) {
      return Stream.value(0);
    }
  }

  @override
  Stream<int> getMergedCount() {
    try {
      return database
          .select(database.syncOperations)
          .watch()
          .map(
            (rows) => rows
                .where((row) => row.status == SyncStatus.merged.status)
                .length,
          );
    } catch (e) {
      return Stream.value(0);
    }
  }

  @override
  Stream<int> getAutoResolvedCount() {
    try {
      return database
          .select(database.syncOperations)
          .watch()
          .map(
            (rows) => rows
                .where((row) => row.status == SyncStatus.autoResolved.status)
                .length,
          );
    } catch (e) {
      return Stream.value(0);
    }
  }

  @override
  Stream<int> getSuccessCount() {
    try {
      return database
          .select(database.syncOperations)
          .watch()
          .map(
            (rows) => rows
                .where((row) => row.status == SyncStatus.success.status)
                .length,
          );
    } catch (e) {
      return Stream.value(0);
    }
  }

  @override
  Stream<int> getFailedCount() {
    try {
      return database
          .select(database.syncOperations)
          .watch()
          .map(
            (rows) => rows
                .where((row) => row.status == SyncStatus.failed.status)
                .length,
          );
    } catch (e) {
      return Stream.value(0);
    }
  }

  @override
  Stream<int> getCreateCount() {
    try {
      return database
          .select(database.syncOperations)
          .watch()
          .map(
            (rows) => rows
                .where((row) => row.type == SyncOperations.create.type)
                .length,
          );
    } catch (e) {
      return Stream.value(0);
    }
  }

  @override
  Stream<int> getUpdateCount() {
    try {
      return database
          .select(database.syncOperations)
          .watch()
          .map(
            (rows) => rows
                .where((row) => row.type == SyncOperations.update.type)
                .length,
          );
    } catch (e) {
      return Stream.value(0);
    }
  }

  @override
  Stream<int> getDeleteCount() {
    try {
      return database
          .select(database.syncOperations)
          .watch()
          .map(
            (rows) => rows
                .where((row) => row.type == SyncOperations.delete.type)
                .length,
          );
    } catch (e) {
      return Stream.value(0);
    }
  }

  @override
  Future<Either<ApiFailure, List<SyncOperationItem>>>
  getAllPendingOperations() async {
    try {
      final result =
          await (database.select(database.syncOperations)
                ..where(
                  (t) =>
                      t.status.isValue(SyncStatus.pending.status) |
                      t.status.isValue(SyncStatus.failed.status),
                )
                ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
              .get();

      return right(result.map(SyncOperationItem.fromDrift).toList());
    } catch (e) {
      return left(ApiFailure.unknown(e.toString()));
    }
  }

  @override
  Future<bool> markOperationFailed(int id, String lastError) async {
    try {
      final operation = await (database.select(
        database.syncOperations,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (operation == null) return false;

      final updatedRows =
          await (database.update(
            database.syncOperations,
          )..where((t) => t.id.equals(id))).write(
            SyncOperationsCompanion(
              status: Value(SyncStatus.failed.status),
              lastError: Value(lastError),
              retryCount: Value(operation.retryCount + 1),
            ),
          );

      return updatedRows > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> markOperationMerged(int id) async {
    try {
      final operation = await (database.select(
        database.syncOperations,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (operation == null) return false;

      final updatedRows =
          await (database.update(
            database.syncOperations,
          )..where((t) => t.id.equals(id))).write(
            SyncOperationsCompanion(status: Value(SyncStatus.merged.status)),
          );

      return updatedRows > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> markOperationAutoResolved(String taskId) async {
    try {
      final updatedRows =
          await (database.update(
            database.syncOperations,
          )..where((t) => t.taskId.equals(taskId))).write(
            SyncOperationsCompanion(
              status: Value(SyncStatus.autoResolved.status),
            ),
          );

      return updatedRows > 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> markOperationSuccess(int id, int updatedVersion) async {
    try {
      final operation = await (database.select(
        database.syncOperations,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (operation == null) return false;

      final payload = Map<String, dynamic>.from(
        jsonDecode(operation.payload) as Map<String, dynamic>,
      )..['version'] = updatedVersion;

      await database.transaction(() async {
        // Mark operation successful
        await (database.update(
          database.syncOperations,
        )..where((t) => t.id.equals(id))).write(
          SyncOperationsCompanion(
            status: Value(SyncStatus.success.status),
            payload: Value(jsonEncode(payload)),
          ),
        );

        // Mark operation merged
        await (database.update(database.syncOperations)..where(
              (t) =>
                  t.id.isNotValue(id) &
                  t.taskId.equals(operation.taskId) &
                  t.status.equals(SyncStatus.pending.status),
            ))
            .write(
              SyncOperationsCompanion(
                status: Value(SyncStatus.merged.status),
                payload: Value(jsonEncode(payload)),
              ),
            );

        log('Updated payload ${jsonEncode(payload)}');

        // Update version for all the items related taskId
        await (database.update(database.tasks)
              ..where((t) => t.id.equals(operation.taskId)))
            .write(TasksCompanion(version: Value(updatedVersion)));
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> solveVersionMismatchConflict(
    int id,
    ConflictResolverParams params,
    int updatedVersion,
  ) async {
    try {
      final operation = await (database.select(
        database.syncOperations,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (operation == null) return false;

      final payload = {...params.toJson(), 'version': updatedVersion};

      await database.transaction(() async {
        // Mark operation successful
        await (database.update(
          database.syncOperations,
        )..where((t) => t.id.equals(id))).write(
          SyncOperationsCompanion(
            status: Value(SyncStatus.versionResolved.status),
            payload: Value(jsonEncode(payload)),
          ),
        );

        // Mark operation merged
        await (database.update(database.syncOperations)..where(
              (t) =>
                  t.id.isNotValue(id) &
                  t.taskId.equals(operation.taskId) &
                  t.status.equals(SyncStatus.pending.status),
            ))
            .write(
              SyncOperationsCompanion(
                status: Value(SyncStatus.merged.status),
                payload: Value(jsonEncode(payload)),
              ),
            );

        // Update version for all the items related taskId
        await (database.update(
          database.tasks,
        )..where((t) => t.id.equals(operation.taskId))).write(
          TasksCompanion(
            title: Value(params.title),
            priority: Value(params.priority.value),
            isCompleted: Value(params.isCompleted),
            description: Value(params.description),
            version: Value(updatedVersion),
            updatedAt: Value(
              params.updatedAt.isEmpty
                  ? null
                  : DateTime.parse(params.updatedAt),
            ),
            deletedAt: Value(
              params.deletedAt.isEmpty
                  ? null
                  : DateTime.parse(params.deletedAt),
            ),
          ),
        );
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> solveAlreadyDeletedConflict(
    int id,
    ConflictResolverParams params,
    int updatedVersion,
  ) async {
    try {
      final operation = await (database.select(
        database.syncOperations,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (operation == null) return false;

      final payload = {...params.toJson(), 'version': updatedVersion};

      await database.transaction(() async {
        // Mark operation successful
        await (database.update(
          database.syncOperations,
        )..where((t) => t.id.equals(id))).write(
          SyncOperationsCompanion(
            status: Value(SyncStatus.alreadyDeleted.status),
            payload: Value(jsonEncode(payload)),
          ),
        );

        // Mark operation merged
        await (database.update(database.syncOperations)..where(
              (t) =>
                  t.id.isNotValue(id) &
                  t.taskId.equals(operation.taskId) &
                  t.status.equals(SyncStatus.pending.status),
            ))
            .write(
              SyncOperationsCompanion(
                status: Value(SyncStatus.merged.status),
                payload: Value(jsonEncode(payload)),
              ),
            );

        // Update version for all the items related taskId
        await (database.update(
          database.tasks,
        )..where((t) => t.id.equals(operation.taskId))).write(
          TasksCompanion(
            title: Value(params.title),
            priority: Value(params.priority.value),
            isCompleted: Value(params.isCompleted),
            description: Value(params.description),
            updatedAt: Value(
              params.updatedAt.isEmpty
                  ? null
                  : DateTime.parse(params.updatedAt),
            ),
            deletedAt: Value(
              params.deletedAt.isEmpty
                  ? null
                  : DateTime.parse(params.deletedAt),
            ),
            version: Value(updatedVersion),
          ),
        );
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> solveDeletedConflict(
    int id,
    ConflictResolverParams params,
    int updatedVersion,
  ) async {
    try {
      final operation = await (database.select(
        database.syncOperations,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (operation == null) return false;

      final payload = {...params.toJson(), 'version': updatedVersion};

      await database.transaction(() async {
        // Mark operation successful
        await (database.update(
          database.syncOperations,
        )..where((t) => t.id.equals(id))).write(
          SyncOperationsCompanion(
            status: Value(SyncStatus.deleteResolved.status),
            payload: Value(jsonEncode(payload)),
          ),
        );

        // Mark operation merged
        await (database.update(database.syncOperations)..where(
              (t) =>
                  t.id.isNotValue(id) &
                  t.taskId.equals(operation.taskId) &
                  t.status.equals(SyncStatus.pending.status),
            ))
            .write(
              SyncOperationsCompanion(
                status: Value(SyncStatus.merged.status),
                payload: Value(jsonEncode(payload)),
              ),
            );

        // Update version for all the items related taskId
        await (database.update(
          database.tasks,
        )..where((t) => t.id.equals(operation.taskId))).write(
          TasksCompanion(
            title: Value(params.title),
            priority: Value(params.priority.value),
            isCompleted: Value(params.isCompleted),
            description: Value(params.description),
            updatedAt: Value(
              params.updatedAt.isEmpty
                  ? null
                  : DateTime.parse(params.updatedAt),
            ),
            deletedAt: Value(
              params.deletedAt.isEmpty
                  ? null
                  : DateTime.parse(params.deletedAt),
            ),
            version: Value(updatedVersion),
          ),
        );
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> solveDuplicateCreatedConflict(
    int id,
    ConflictResolverParams params,
    int updatedVersion,
  ) async {
    try {
      final operation = await (database.select(
        database.syncOperations,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (operation == null) return false;

      final payload = {...params.toJson(), 'version': updatedVersion};

      await database.transaction(() async {
        // Mark operation successful
        await (database.update(
          database.syncOperations,
        )..where((t) => t.id.equals(id))).write(
          SyncOperationsCompanion(
            status: Value(SyncStatus.duplicateCreate.status),
            payload: Value(jsonEncode(payload)),
          ),
        );

        // Mark operation merged
        await (database.update(database.syncOperations)..where(
              (t) =>
                  t.id.isNotValue(id) &
                  t.taskId.equals(operation.taskId) &
                  t.status.equals(SyncStatus.pending.status),
            ))
            .write(
              SyncOperationsCompanion(
                status: Value(SyncStatus.merged.status),
                payload: Value(jsonEncode(payload)),
              ),
            );

        // Update version for all the items related taskId
        await (database.update(
          database.tasks,
        )..where((t) => t.id.equals(operation.taskId))).write(
          TasksCompanion(
            title: Value(params.title),
            priority: Value(params.priority.value),
            isCompleted: Value(params.isCompleted),
            description: Value(params.description),
            updatedAt: Value(
              params.updatedAt.isEmpty
                  ? null
                  : DateTime.parse(params.updatedAt),
            ),
            deletedAt: Value(
              params.deletedAt.isEmpty
                  ? null
                  : DateTime.parse(params.deletedAt),
            ),
            version: Value(updatedVersion),
          ),
        );
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
