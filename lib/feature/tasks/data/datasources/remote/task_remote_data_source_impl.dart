import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/api_clients.dart';
import 'package:offline_engine/core/endpoints.dart';
import 'package:offline_engine/feature/tasks/data/datasources/remote/task_remote_data_source.dart';
import 'package:offline_engine/feature/tasks/data/models/task_item.dart';

@LazySingleton(as: TaskRemoteDataSource)
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final APIClients _clients;

  TaskRemoteDataSourceImpl(this._clients);

  @override
  Future<Either<ApiFailure, List<TaskItem>>> fetchTasks() {
    return _clients.offlineEngine.get(
      TaskEndpoints.getTasks,
      parser: (json) =>
          (json['data'] as List).map((e) => TaskItem.fromJson(e)).toList(),
    );
  }
}
