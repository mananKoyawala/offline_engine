import 'package:offline_engine/core/import/app_imports.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskItem>> getTasks();

  Future<bool> insertTask(CreateTaskParams task);

  Future<bool> updateTask(UpdateTaskParams task);

  Future<bool> deleteTask(UpdateTaskParams task);
}
