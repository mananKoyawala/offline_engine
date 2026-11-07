import 'package:j_client/j_client.dart';
import 'package:todus/feature/tasks/data/models/task_item.dart';

abstract class TaskRemoteDataSource {
  Future<Either<ApiFailure, List<TaskItem>>> fetchTasks();
}
