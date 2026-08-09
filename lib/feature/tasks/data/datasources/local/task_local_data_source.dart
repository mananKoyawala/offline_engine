import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/tasks/data/models/task_item.dart';

abstract class TaskLocalDataSource {
  Future<Either<ApiFailure, List<TaskItem>>> getTasks();

  Future<Either<ApiFailure, bool>> insertTask(CreateTaskParams task);

  Future<Either<ApiFailure, bool>> updateTask(UpdateTaskParams task);

  Future<Either<ApiFailure, bool>> deleteTask(UpdateTaskParams task);

  /// Upserts a list of tasks received from the server into the local DB.
  /// Tasks that have a pending sync operation are skipped (local wins).
  Future<Either<ApiFailure, bool>> upsertTasksFromRemote(
    List<TaskItem> remoteTasks,
  );
}
