import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/domain/repository/sync_operation_repository.dart';

@lazySingleton
class GetSyncOperationLocalUsecase {
  GetSyncOperationLocalUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Future<Either<ApiFailure, List<SyncOperationItem>>> call() {
    return _repository.getSyncOperations();
  }
}

@lazySingleton
class GetSyncOperationStreamLocalUsecase {
  GetSyncOperationStreamLocalUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Stream<Either<ApiFailure, List<SyncOperationItem>>> call() {
    return _repository.getSyncOperationsStream();
  }
}
