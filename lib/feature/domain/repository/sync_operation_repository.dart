import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';

abstract class ISyncOperationRepository {
  Future<Either<ApiFailure, List<SyncOperationItem>>> getSyncOperations();
  Stream<Either<ApiFailure, List<SyncOperationItem>>> getSyncOperationsStream();
  Stream<int> getPendingCount();
  Stream<int> getProcessingCount();
  Stream<int> getFailedCount();
  Stream<int> getSuccessCount();
  Stream<int> getCreateCount();
  Stream<int> getUpdateCount();
  Stream<int> getDeleteCount();
}
