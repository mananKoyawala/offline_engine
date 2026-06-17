import 'package:injectable/injectable.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/domain/repository/sync_operation_repository.dart';

@lazySingleton
class GetSyncOperationLocalUsecase {
  GetSyncOperationLocalUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Future<List<SyncOperationItem>> call() {
    return _repository.getSyncOperations();
  }
}
