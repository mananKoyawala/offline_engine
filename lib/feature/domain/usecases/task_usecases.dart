import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/domain/enitites/task_entity.dart';
import 'package:offline_engine/feature/domain/repository/task_repository.dart';

class GetTasksLocalUsecase {
  GetTasksLocalUsecase(this._repository);
  final ITaskRepository _repository;

  Future<List<TaskEntity>> call() {
    return _repository.getTasksLocal();
  }
}

class CreateTasksLocalUsecase {
  CreateTasksLocalUsecase(this._repository);
  final ITaskRepository _repository;

  Future<bool> call(CreateTaskParams params) {
    return _repository.insertTaskLocal(params);
  }
}

class UpdateTasksLocalUsecase {
  UpdateTasksLocalUsecase(this._repository);
  final ITaskRepository _repository;

  Future<bool> call(UpdateTaskParams params) {
    return _repository.updateTaskLocal(params);
  }
}

class DeleteTasksLocalUsecase {
  DeleteTasksLocalUsecase(this._repository);
  final ITaskRepository _repository;

  Future<bool> call(String taskId) {
    return _repository.deleteTaskLocal(taskId);
  }
}
