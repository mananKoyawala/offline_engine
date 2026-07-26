import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/core/api_clients.dart';
import 'package:offline_engine/core/endpoints.dart';
import 'package:offline_engine/service/sync_processor/model/sync_processor_response.dart';
import 'package:offline_engine/service/sync_processor/params/sync_processor_params.dart';
import 'package:offline_engine/service/sync_processor/repository/sync_processor_repository.dart';

@LazySingleton(as: ISyncProcessorRepository)
class SyncProcessorRepositoryImpl implements ISyncProcessorRepository {
  final APIClients _client;

  SyncProcessorRepositoryImpl(this._client);

  @override
  Future<Either<ApiFailure, SyncProcessorResponse>> syncOperations(
    List<SyncProcessorParams> operations,
  ) async {
    return await _client.offlineEngine.post(
      SyncOperationEndponts.syncOperation,
      data: {'operations': operations.map((e) => e.toJson()).toList()},
      parser: SyncProcessorResponse.fromJson,
    );
  }
}
