import 'package:j_client/j_client.dart';
import 'package:offline_engine/feature/tasks/data/models/sync_operation_item.dart';
import 'package:offline_engine/feature/tasks/presentation/getters/sync_operation_getters.dart';
import 'package:offline_engine/service/sync/conflict_resolver/conflict_resolver.dart';
import 'package:offline_engine/service/sync/sync_processor/enums/sync_processor_enums.dart';
import 'package:offline_engine/service/sync/sync_processor/model/sync_processor_response.dart';

class SyncOperationResponseResolver {
  static Future<void> resolveResponse(SyncProcessorResponse response) async {
    for (final operation in response.data) {
      if (operation.status == SyncOperationStatus.success) {
        // To generate conflict comment this code
        await markOperationSuccessUsecase(
          int.parse(operation.operationId),
          operation.serverVersion ?? 1,
        );
        continue;
      }

      if (operation.status == SyncOperationStatus.conflict) {
        await ConflictResolver.solveConflict(operation);
      }

      if (operation.status == SyncOperationStatus.failed) {
        await markOperationFailedUsecase(
          int.parse(operation.operationId),
          operation.error != null ? operation.error!.detail : 'unknown',
        );
      }
    }
  }

  static Future<void> resolveFailure(
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
