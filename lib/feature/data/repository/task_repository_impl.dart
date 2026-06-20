import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/feature/data/datasources/local/task_local_data_source.dart';
import 'package:offline_engine/feature/data/datasources/remote/task_remote_data_source.dart';
import 'package:offline_engine/feature/data/models/task_item.dart';
import 'package:offline_engine/feature/domain/enitites/task_entity.dart';
import 'package:offline_engine/feature/domain/params/create_task_params.dart';
import 'package:offline_engine/feature/domain/params/update_task_params.dart';
import 'package:offline_engine/feature/domain/repository/task_repository.dart';

@LazySingleton(as: ITaskRepository)
class TaskRepositoryImpl implements ITaskRepository {
  final TaskLocalDataSource local;
  final TaskRemoteDataSource remote;

  TaskRepositoryImpl(this.local, this.remote);

  @override
  Future<Either<ApiFailure, bool>> deleteTaskLocal(UpdateTaskParams params) {
    return local.deleteTask(params);
  }

  @override
  Future<Either<ApiFailure, List<TaskEntity>>> getTasksLocal() async {
    final result = await local.getTasks();

    return result.fold(left, (tasks) {
      return right(tasks.map((t) => t.toEntity()).toList());
    });
  }

  @override
  Future<Either<ApiFailure, bool>> insertTaskLocal(CreateTaskParams params) {
    return local.insertTask(params);
  }

  @override
  Future<Either<ApiFailure, bool>> updateTaskLocal(UpdateTaskParams params) {
    return local.updateTask(params);
  }

  @override
  Future<Either<ApiFailure, bool>> createTaskRemote(UpdateTaskParams params) {
    return remote.createTask(params);
  }

  @override
  Future<Either<ApiFailure, bool>> deleteTaskRemote(String taskId) {
    return remote.deleteTask(taskId);
  }

  @override
  Future<Either<ApiFailure, bool>> updateTaskRemote(UpdateTaskParams params) {
    return remote.updateTask(params);
  }

  @override
  Future<Either<ApiFailure, List<TaskEntity>>> getTasksRemote() {
    return remote.getTasks();
  }
}
