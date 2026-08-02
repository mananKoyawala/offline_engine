import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';

abstract class SyncOperationsLocalDataSource {
  Future<Either<ApiFailure, List<SyncOperationItem>>> getSyncOperations();
  Future<Either<ApiFailure, List<SyncOperationItem>>> getAllPendingOperations();
  Stream<Either<ApiFailure, List<SyncOperationItem>>> getSyncOperationsStream();
  Stream<int> getPendingCount();
  Stream<int> getMergedCount();
  Stream<int> getAutoResolvedCount();
  Stream<int> getFailedCount();
  Stream<int> getSuccessCount();
  Stream<int> getCreateCount();
  Stream<int> getUpdateCount();
  Stream<int> getDeleteCount();
  Future<bool> markOperationSuccess(int id, int updatedVersion);
  Future<bool> markOperationFailed(int id, String lastError);
  Future<bool> markOperationAutoResolved(String id);
  Future<bool> markOperationMerged(int id);
}
