import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';

abstract class ISyncOperationRepository {
  Future<Either<ApiFailure, List<SyncOperationItem>>> getSyncOperations();
  Stream<Either<ApiFailure, List<SyncOperationItem>>> getSyncOperationsStream();
}
