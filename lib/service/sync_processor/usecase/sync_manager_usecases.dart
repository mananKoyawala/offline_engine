import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
import 'package:offline_engine/service/sync_processor/model/sync_processor_response.dart';
import 'package:offline_engine/service/sync_processor/params/sync_processor_params.dart';
import 'package:offline_engine/service/sync_processor/repository/sync_processor_repository.dart';

@lazySingleton
class SyncOperationUsecase {
  SyncOperationUsecase(this._repository);
  final ISyncProcessorRepository _repository;

  Future<Either<ApiFailure, SyncProcessorResponse>> call(
    List<SyncProcessorParams> operations,
  ) {
    return _repository.syncOperations(operations);
  }
}
