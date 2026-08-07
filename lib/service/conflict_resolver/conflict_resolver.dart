import 'dart:developer';
import 'package:offline_engine/feature/tasks/presentation/enums/task_priority.dart';
import 'package:offline_engine/feature/tasks/presentation/getters/sync_operation_getters.dart';
import 'package:offline_engine/service/conflict_resolver/conflict_resolver_params.dart';
import 'package:offline_engine/service/sync_processor/enums/sync_processor_enums.dart';
import 'package:offline_engine/service/sync_processor/model/sync_processor_response.dart';

class ConflictResolver {
  static Future<void> solveConflict(SyncProcessorOperation operation) async {
    final params = ConflictResolverParams(
      id: operation.entityId,
      title: operation.conflictData!.title,
      description: operation.conflictData!.description!,
      priority: TaskPriority.fromValue(operation.conflictData!.priority),
      isCompleted: operation.conflictData!.isCompleted,
      createdAt: operation.conflictData!.createdAt,
      updatedAt: operation.conflictData!.updatedAt,
      deletedAt: operation.conflictData!.deletedAt ?? '',
    );

    switch (operation.conflictType) {
      case SyncConflictType.none:
        return;
      case SyncConflictType.duplicate_create:
        // DELETE FROM LOCAL SYNC OPERATION
        log('duplicate_created');
        if (operation.conflictData != null) {
          solveDuplicateCreatedConflictUseCase(
            int.parse(operation.operationId),
            params,
            operation.conflictData!.version,
          );
        }
        break;
      case SyncConflictType.already_deleted:
        // DELETE FROM LOCAL SYNC OPERATION
        // MARK TASK AS DELETED
        log('already_deleted');
        if (operation.conflictData != null) {
          solveAlreadyDeletedConflictUseCase(
            int.parse(operation.operationId),
            params,
            operation.conflictData!.version,
          );
        }
        break;
      case SyncConflictType.version_mismatch:
        // UPDATE ENTIRELY CONFLICT DATA
        log('version_mismatch');
        if (operation.conflictData != null) {
          solveVersionMismatchConflictUsecase(
            int.parse(operation.operationId),
            params,
            operation.conflictData!.version,
          );
        }
        break;
      case SyncConflictType.deleted: // REQUEST IS TO UPDATE
        // DELETE FROM LOCAL SYNC OPERATION
        // MARK TASK AS DELETED
        if (operation.conflictData != null) {
          solveDeletedConflictUseCase(
            int.parse(operation.operationId),
            params,
            operation.conflictData!.version,
          );
        }
        log('deleted');
    }
  }
}
