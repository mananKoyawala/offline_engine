import 'package:j_client/j_client.dart';
import 'package:offline_engine/service/sync_processor/model/sync_processor_response.dart';
import 'package:offline_engine/service/sync_processor/params/sync_processor_params.dart';

abstract class ISyncProcessorRepository {
  Future<Either<ApiFailure, SyncProcessorResponse>> syncOperations(
    List<SyncProcessorParams> operations,
  );
}
