import 'package:j_client/j_client.dart';
import 'package:offline_engine/feature/tasks/data/models/task_item.dart';

abstract class TaskRemoteDataSource {
  Future<Either<ApiFailure, List<TaskItem>>> fetchTasks();
}
