import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/feature/data/datasources/local/sync_operations_local_data_source.dart';
import 'package:offline_engine/feature/data/models/sync_operation_item.dart';
import 'package:offline_engine/feature/domain/repository/sync_operation_repository.dart';

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
  Stream<int> getProcessingCount() {
    return local.getProcessingCount();
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
  Future<bool> markOperationSuccess(int id) {
    return local.markOperationSuccess(id);
  }
}
