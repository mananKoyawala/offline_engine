import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/core/network/api_clients.dart';
import 'package:offline_engine/core/network/api_response.dart';
import 'package:offline_engine/core/network/endpoints.dart';
import 'package:offline_engine/feature/data/datasources/remote/task_remote_data_source.dart';
import 'package:offline_engine/feature/data/models/task_api_response.dart';
import 'package:offline_engine/feature/domain/enitites/task_entity.dart';

@LazySingleton(as: TaskRemoteDataSource)
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final APIClients _client;

  TaskRemoteDataSourceImpl(this._client);

  @override
  Future<Either<ApiFailure, bool>> createTask(UpdateTaskParams params) async {
    final result = await _client.defaultClient.post(
      TaskEndpoints.task,
      data: params.toJson(),
      parser: APIResponse.fromJson,
    );

    return result.fold(left, (response) => right(response.status));
  }

  @override
  Future<Either<ApiFailure, bool>> deleteTask(String taskId) async {
    final result = await _client.defaultClient.delete(
      "${TaskEndpoints.task}/$taskId",
      parser: APIResponse.fromJson,
    );

    return result.fold(left, (response) => right(response.status));
  }

  @override
  Future<Either<ApiFailure, List<TaskEntity>>> getTasks() async {
    final result = await _client.defaultClient.get(
      TaskEndpoints.task,
      parser: TaskAPIResponse.fromJson,
    );

    return result.fold(left, (response) {
      return right(response.tasks.map((e) => e.toEntity()).toList());
    });
  }

  @override
  Future<Either<ApiFailure, bool>> updateTask(UpdateTaskParams params) async {
    final result = await _client.defaultClient.patch(
      TaskEndpoints.task,
      data: params.toJson(),
      parser: APIResponse.fromJson,
    );

    return result.fold(left, (response) => right(response.status));
  }
}
