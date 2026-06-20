import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/domain/enitites/task_entity.dart';

abstract class TaskRemoteDataSource {
  Future<Either<ApiFailure, List<TaskEntity>>> getTasks();
  Future<Either<ApiFailure, bool>> createTask(UpdateTaskParams params);
  Future<Either<ApiFailure, bool>> updateTask(UpdateTaskParams params);
  Future<Either<ApiFailure, bool>> deleteTask(String taskId);
}
