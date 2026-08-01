import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';

abstract class TaskLocalDataSource {
  Future<Either<ApiFailure, List<TaskItem>>> getTasks();

  Future<Either<ApiFailure, bool>> insertTask(CreateTaskParams task);

  Future<Either<ApiFailure, bool>> updateTask(UpdateTaskParams task);

  Future<Either<ApiFailure, bool>> deleteTask(UpdateTaskParams task);
}
