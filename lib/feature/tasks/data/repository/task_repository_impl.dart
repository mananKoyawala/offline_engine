import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/feature/tasks/data/datasources/local/task_local_data_source.dart';
import 'package:offline_engine/feature/tasks/data/datasources/remote/task_remote_data_source.dart';
import 'package:offline_engine/feature/tasks/data/models/task_item.dart';
import 'package:offline_engine/feature/tasks/domain/enitites/task_entity.dart';
import 'package:offline_engine/feature/tasks/domain/params/create_task_params.dart';
import 'package:offline_engine/feature/tasks/domain/params/update_task_params.dart';
import 'package:offline_engine/feature/tasks/domain/repository/task_repository.dart';

@LazySingleton(as: ITaskRepository)
class TaskRepositoryImpl implements ITaskRepository {
  final TaskLocalDataSource local;
  final TaskRemoteDataSource remote;

  TaskRepositoryImpl(this.local, this.remote);

  @override
  Future<Either<ApiFailure, bool>> deleteTaskLocal(UpdateTaskParams task) {
    return local.deleteTask(task);
  }

  @override
  Future<Either<ApiFailure, List<TaskEntity>>> getTasksLocal() async {
    final result = await local.getTasks();

    return result.fold(left, (tasks) {
      return right(tasks.map((t) => t.toEntity()).toList());
    });
  }

  @override
  Future<Either<ApiFailure, bool>> insertTaskLocal(CreateTaskParams task) {
    return local.insertTask(task);
  }

  @override
  Future<Either<ApiFailure, bool>> updateTaskLocal(UpdateTaskParams task) {
    return local.updateTask(task);
  }

  @override
  Future<Either<ApiFailure, bool>> fetchAndUpsertTasksRemote() async {
    final result = await remote.fetchTasks();
    return result.fold(
      left,
      (remoteTasks) => local.upsertTasksFromRemote(remoteTasks),
    );
  }
}
