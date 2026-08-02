import 'package:j_client/j_client.dart';
import 'package:offline_engine/feature/tasks/data/models/sync_operation_item.dart';
import 'package:offline_engine/feature/tasks/presentation/getters/sync_operation_getters.dart';
import 'package:offline_engine/service/sync_processor/model/sync_processor_response.dart';

class SyncOperationResponseResolver {
  static Future<void> resolveResponse(
    int id,
    SyncProcessorResponse response,
  ) async {
    if (response.success == false && response.status == 498) {
      // TODO : REFRESH THE TOKEN AND AGAIN CALL THAT BATCH
    }
    if (response.success) {
      for (final item in response.data) {
        await markOperationSuccessUsecase(
          int.parse(item.operationId),
          item.serverVersion ?? 0,
        );
      }
    }

    // TODO : APPLY CONFLICT RESOLVER
  }

  static Future<void> resolveFailure(int id, ApiFailure failure) async {
    await markOperationFailedUsecase(id, failure.message);
  }

  static Future<void> resolveResponseAll(SyncProcessorResponse response) async {
    if (response.success == false && response.status == 498) {
      // TODO : REFRESH THE TOKEN AND AGAIN CALL THAT BATCH
    }
    if (response.success) {
      for (final item in response.data) {
        await markOperationSuccessUsecase(
          int.parse(item.operationId),
          item.serverVersion ?? 0,
        );
      }
    }

    // TODO : APPLY CONFLICT RESOLVER
  }

  static Future<void> resolveFailureAll(
    List<SyncOperationItem> failedItems,
    ApiFailure failure,
  ) async {
    for (var item in failedItems) {
      await markOperationFailedUsecase(item.id, failure.message);
    }
  }

  static Future<void> resolveAutoResolvedTaskIds(List<String> taskIds) async {
    for (var taskId in taskIds) {
      await markOperationAutoResolvedUsecase(taskId);
    }
  }
}
