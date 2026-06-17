import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/domain/enitites/task_entity.dart';

abstract class ITaskRepository {
  Future<List<TaskEntity>> getTasksLocal();

  Future<bool> insertTaskLocal(CreateTaskParams task);

  Future<bool> updateTaskLocal(UpdateTaskParams task);

  Future<bool> deleteTaskLocal(UpdateTaskParams task);
}
