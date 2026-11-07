import 'package:j_client/j_client.dart';
import 'package:todus/core/import/app_imports.dart';
import 'package:todus/feature/tasks/domain/entiites/task_entity.dart';

abstract class ITaskRepository {
  Future<Either<ApiFailure, List<TaskEntity>>> getTasksLocal();

  Future<Either<ApiFailure, bool>> insertTaskLocal(CreateTaskParams task);

  Future<Either<ApiFailure, bool>> updateTaskLocal(UpdateTaskParams task);

  Future<Either<ApiFailure, bool>> deleteTaskLocal(UpdateTaskParams task);

  /// Fetches tasks from the server and upserts them into the local DB.
  Future<Either<ApiFailure, bool>> fetchAndUpsertTasksRemote();
}
