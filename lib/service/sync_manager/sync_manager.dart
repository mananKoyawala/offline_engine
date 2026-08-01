import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:offline_engine/feature/tasks/presentation/getters/sync_operation_getters.dart';
import 'package:offline_engine/service/operation_resolver/sync_operation_response_resolver.dart';
import 'package:offline_engine/service/queue_manager/queue_manager.dart';
import 'package:offline_engine/service/sync_processor/getters/sync_manager_getters.dart';
import 'package:offline_engine/service/sync_processor/params/sync_processor_params.dart';

@injectable
class SyncManager {
  final QueueManager _queueManager;

  SyncManager(this._queueManager);

  static bool _isSyncing = false;

  void initialize() async {
    final result = await getAllPendingOperationsUsecase();
    await result.fold(
      (failure) {
        log('failed to fetch pending operations');
      },
      (operations) {
        _queueManager.enqueueAll(operations);
      },
    );
  } // Load all pending operations

  void startSync() async {
    if (_isSyncing) return;
    log('# ========================');
    log('# Start of Syncing Operations');
    log('# ========================');
    _isSyncing = true;

    try {
      // peek operation from queue
      final operation = _queueManager.peek();

      if (operation != null) {
        // send to backend

        final result = await syncOperationUsecase([
          SyncProcessorParams.fromOperation(operation),
        ]);
        await result.fold(
          (failure) async {
            log("Failure : ${failure.message}");
            await SyncOperationResponseResolver.resolveFailure(
              operation.id,
              failure,
            );
          },
          (response) async {
            log("Success : ${response.success}");
            await SyncOperationResponseResolver.resolveResponse(
              operation.id,
              response,
            );
          },
        );

        _queueManager.dequeue();
      }
    } finally {
      _isSyncing = false;
    }

    log('# ========================');
    log('# End of Syncing Operations');
    log('# ========================');
  }

  void stopSync() {}

  void processQueue() {}
}
