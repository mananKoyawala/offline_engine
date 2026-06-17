import 'package:injectable/injectable.dart';
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
  Future<bool> deleteTaskLocal(UpdateTaskParams task) {
    return local.deleteTask(task);
  }

  @override
  Future<List<TaskEntity>> getTasksLocal() async {
    final tasks = await local.getTasks();
    return tasks.map((t) => t.toEntity()).toList();
  }

  @override
  Future<bool> insertTaskLocal(CreateTaskParams task) {
    return local.insertTask(task);
  }

  @override
  Future<bool> updateTaskLocal(UpdateTaskParams task) {
    return local.updateTask(task);
  }
}
