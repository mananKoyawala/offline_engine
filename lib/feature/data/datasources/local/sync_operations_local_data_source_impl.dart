import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/database/app_database.dart';
import 'package:offline_engine/feature/data/datasources/local/sync_operations_local_data_source.dart';
import 'package:offline_engine/feature/data/models/sync_operation_item.dart';
import 'package:offline_engine/feature/presentation/enums/sync_operations.dart';

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
  Stream<int> getProcessingCount() {
    try {
      return database
          .select(database.syncOperations)
          .watch()
          .map(
            (rows) => rows
                .where((row) => row.status == SyncStatus.processing.status)
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
                ..where((t) => t.status.isValue(SyncStatus.pending.status))
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
  Future<bool> markOperationSuccess(int id) async {
    try {
      final updatedRows =
          await (database.update(
            database.syncOperations,
          )..where((t) => t.id.equals(id))).write(
            SyncOperationsCompanion(status: Value(SyncStatus.failed.status)),
          );

      return updatedRows > 0;
    } catch (e) {
      return false;
    }
  }
}
