import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/tasks/domain/entiites/task_entity.dart';
import 'package:offline_engine/feature/tasks/domain/repository/task_repository.dart';

@lazySingleton
class GetTasksLocalUsecase {
  GetTasksLocalUsecase(this._repository);
  final ITaskRepository _repository;

  Future<Either<ApiFailure, List<TaskEntity>>> call() {
    return _repository.getTasksLocal();
  }
}

@lazySingleton
class CreateTasksLocalUsecase {
  CreateTasksLocalUsecase(this._repository);
  final ITaskRepository _repository;

  Future<Either<ApiFailure, bool>> call(CreateTaskParams params) {
    return _repository.insertTaskLocal(params);
  }
}

@lazySingleton
class UpdateTasksLocalUsecase {
  UpdateTasksLocalUsecase(this._repository);
  final ITaskRepository _repository;

  Future<Either<ApiFailure, bool>> call(UpdateTaskParams params) {
    return _repository.updateTaskLocal(params);
  }
}

@lazySingleton
class DeleteTasksLocalUsecase {
  DeleteTasksLocalUsecase(this._repository);
  final ITaskRepository _repository;

  Future<Either<ApiFailure, bool>> call(UpdateTaskParams params) {
    return _repository.deleteTaskLocal(params);
  }
}

@lazySingleton
class FetchAndUpsertTasksUsecase {
  FetchAndUpsertTasksUsecase(this._repository);
  final ITaskRepository _repository;

  Future<Either<ApiFailure, bool>> call() {
    return _repository.fetchAndUpsertTasksRemote();
  }
}
