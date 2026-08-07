import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/feature/tasks/data/datasources/local/sync_operations_local_data_source.dart';
import 'package:offline_engine/feature/tasks/data/models/sync_operation_item.dart';
import 'package:offline_engine/feature/tasks/domain/params/update_task_params.dart';
import 'package:offline_engine/feature/tasks/domain/repository/sync_operation_repository.dart';
import 'package:offline_engine/service/conflict_resolver/conflict_resolver_params.dart';

@LazySingleton(as: ISyncOperationRepository)
class SyncOperationRepositoryImpl implements ISyncOperationRepository {
  final SyncOperationsLocalDataSource local;

  SyncOperationRepositoryImpl(this.local);

  @override
  Future<Either<ApiFailure, List<SyncOperationItem>>> getSyncOperations() {
    return local.getSyncOperations();
  }

  @override
  Stream<Either<ApiFailure, List<SyncOperationItem>>>
  getSyncOperationsStream() {
    return local.getSyncOperationsStream();
  }

  @override
  Stream<int> getPendingCount() {
    return local.getPendingCount();
  }

  @override
  Stream<int> getMergedCount() {
    return local.getMergedCount();
  }

  @override
  Stream<int> getAutoResolvedCount() {
    return local.getMergedCount();
  }

  @override
  Stream<int> getFailedCount() {
    return local.getFailedCount();
  }

  @override
  Stream<int> getSuccessCount() {
    return local.getSuccessCount();
  }

  @override
  Stream<int> getCreateCount() {
    return local.getCreateCount();
  }

  @override
  Stream<int> getUpdateCount() {
    return local.getUpdateCount();
  }

  @override
  Stream<int> getDeleteCount() {
    return local.getDeleteCount();
  }

  @override
  Future<Either<ApiFailure, List<SyncOperationItem>>>
  getAllPendingOperations() {
    return local.getAllPendingOperations();
  }

  @override
  Future<bool> markOperationFailed(int id, String lastError) {
    return local.markOperationFailed(id, lastError);
  }

  @override
  Future<bool> markOperationSuccess(int id, int updatedVersion) {
    return local.markOperationSuccess(id, updatedVersion);
  }

  @override
  Future<bool> markOperationAutoResolved(String taskId) {
    return local.markOperationAutoResolved(taskId);
  }

  @override
  Future<bool> markOperationMerged(int id) {
    return local.markOperationMerged(id);
  }

  @override
  Future<bool> solveVersionMismatchConflict(
    int id,
    ConflictResolverParams params,
    int updatedVersion,
  ) {
    return local.solveVersionMismatchConflict(id, params, updatedVersion);
  }

  @override
  Future<bool> solveAlreadyDeletedConflict(
    int id,
    ConflictResolverParams params,
    int updatedVersion,
  ) {
    return local.solveAlreadyDeletedConflict(id, params, updatedVersion);
  }

  @override
  Future<bool> solveDeletedConflict(
    int id,
    ConflictResolverParams params,
    int updatedVersion,
  ) {
    return local.solveDeletedConflict(id, params, updatedVersion);
  }

  @override
  Future<bool> solveDuplicateCreatedConflict(
    int id,
    ConflictResolverParams params,
    int updatedVersion,
  ) {
    return local.solveDuplicateCreatedConflict(id, params, updatedVersion);
  }
}
