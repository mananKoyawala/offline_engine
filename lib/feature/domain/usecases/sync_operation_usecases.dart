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

@lazySingleton
class GetPendingCountLocalUsecase {
  GetPendingCountLocalUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Stream<int> call() {
    return _repository.getPendingCount();
  }
}

@lazySingleton
class GetProcessingCountLocalUsecase {
  GetProcessingCountLocalUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Stream<int> call() {
    return _repository.getProcessingCount();
  }
}

@lazySingleton
class GetSuccessCountLocalUsecase {
  GetSuccessCountLocalUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Stream<int> call() {
    return _repository.getSuccessCount();
  }
}

@lazySingleton
class GetFailedCountLocalUsecase {
  GetFailedCountLocalUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Stream<int> call() {
    return _repository.getFailedCount();
  }
}

@lazySingleton
class GetCreateCountLocalUsecase {
  GetCreateCountLocalUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Stream<int> call() {
    return _repository.getCreateCount();
  }
}

@lazySingleton
class GetUpdateCountLocalUsecase {
  GetUpdateCountLocalUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Stream<int> call() {
    return _repository.getUpdateCount();
  }
}

@lazySingleton
class GetDeleteCountLocalUsecase {
  GetDeleteCountLocalUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Stream<int> call() {
    return _repository.getDeleteCount();
  }
}

@lazySingleton
class MarkOperationSuccessUsecase {
  MarkOperationSuccessUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Future<bool> call(int id, int updatedVersion) {
    return _repository.markOperationSuccess(id, updatedVersion);
  }
}

@lazySingleton
class MarkOperationFailedUsecase {
  MarkOperationFailedUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Future<bool> call(int id, String lastError) {
    return _repository.markOperationFailed(id, lastError);
  }
}

@lazySingleton
class GetAllPendingOperationsUsecase {
  GetAllPendingOperationsUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Future<Either<ApiFailure, List<SyncOperationItem>>> call() {
    return _repository.getAllPendingOperations();
  }
}
