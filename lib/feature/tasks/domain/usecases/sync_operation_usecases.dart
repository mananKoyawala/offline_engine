import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/tasks/domain/repository/sync_operation_repository.dart';
import 'package:offline_engine/service/conflict_resolver/conflict_resolver_params.dart';

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
class GetMergedCountLocalUsecase {
  GetMergedCountLocalUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Stream<int> call() {
    return _repository.getMergedCount();
  }
}

@lazySingleton
class GetAutoResolvedCountLocalUsecase {
  GetAutoResolvedCountLocalUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Stream<int> call() {
    return _repository.getAutoResolvedCount();
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

@lazySingleton
class MarkOperationMergedUsecase {
  MarkOperationMergedUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Future<bool> call(int id) {
    return _repository.markOperationMerged(id);
  }
}

@lazySingleton
class MarkOperationAutoResolvedUsecase {
  MarkOperationAutoResolvedUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Future<bool> call(String taskId) {
    return _repository.markOperationAutoResolved(taskId);
  }
}

@lazySingleton
class SolveVersionMismatchConflictUsecase {
  SolveVersionMismatchConflictUsecase(this._repository);
  final ISyncOperationRepository _repository;

  Future<bool> call(int id, ConflictResolverParams params, int updatedVersion) {
    return _repository.solveVersionMismatchConflict(id, params, updatedVersion);
  }
}

@lazySingleton
class SolveAlreadyDeletedConflictUseCase {
  SolveAlreadyDeletedConflictUseCase(this._repository);
  final ISyncOperationRepository _repository;

  Future<bool> call(int id, ConflictResolverParams params, int updatedVersion) {
    return _repository.solveAlreadyDeletedConflict(id, params, updatedVersion);
  }
}

@lazySingleton
class SolveDeletedConflictUseCase {
  SolveDeletedConflictUseCase(this._repository);
  final ISyncOperationRepository _repository;

  Future<bool> call(int id, ConflictResolverParams params, int updatedVersion) {
    return _repository.solveDeletedConflict(id, params, updatedVersion);
  }
}
