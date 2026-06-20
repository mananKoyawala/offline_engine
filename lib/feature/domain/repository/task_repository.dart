import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/domain/enitites/task_entity.dart';

abstract class ITaskRepository {
  Future<Either<ApiFailure, List<TaskEntity>>> getTasksLocal();

  Future<Either<ApiFailure, bool>> insertTaskLocal(CreateTaskParams params);

  Future<Either<ApiFailure, bool>> updateTaskLocal(UpdateTaskParams params);

  Future<Either<ApiFailure, bool>> deleteTaskLocal(UpdateTaskParams params);

  Future<Either<ApiFailure, List<TaskEntity>>> getTasksRemote();

  Future<Either<ApiFailure, bool>> createTaskRemote(UpdateTaskParams params);

  Future<Either<ApiFailure, bool>> updateTaskRemote(UpdateTaskParams params);

  Future<Either<ApiFailure, bool>> deleteTaskRemote(String taskId);
}
