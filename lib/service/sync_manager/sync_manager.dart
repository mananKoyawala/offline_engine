import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:j_client/j_client.dart';
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

  void startSyncAll() async {
    if (_isSyncing) return;
    log('# ========================');
    log('# Start of Syncing All Operations');
    log('# ========================');
    _isSyncing = true;

    try {
      // peek operation from queue
      final operations = _queueManager.peekAll();

      if (operations.isNotEmpty) {
        // send to backend

        final result = await syncOperationUsecase(
          operations
              .map((operation) => SyncProcessorParams.fromOperation(operation))
              .toList(),
        );
        await result.fold(
          (failure) async {
            log("Failure : ${failure.message}");
            await SyncOperationResponseResolver.resolveFailureAll(
              operations,
              failure,
            );
          },
          (response) async {
            log("Success : ${response.success}");
            if (response.success) {
              _queueManager.dequeue();
              await SyncOperationResponseResolver.resolveResponseAll(response);
            } else {
              await SyncOperationResponseResolver.resolveFailureAll(
                operations,
                ApiFailure.serverError(message: response.status.toString()),
              );
            }
          },
        );
      }
    } finally {
      _isSyncing = false;
    }

    // Resolve auto resolve items
    await SyncOperationResponseResolver.resolveAutoResolvedTaskIds(
      _queueManager.getAutoResolvedTaskIds,
    );

    _queueManager.clear();

    log('# ========================');
    log('# End of Syncing All Operations');
    log('# ========================');
  }

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
            if (response.success) {
              _queueManager.dequeue();
              await SyncOperationResponseResolver.resolveResponse(
                operation.id,
                response,
              );
            } else {
              await SyncOperationResponseResolver.resolveFailure(
                operation.id,
                ApiFailure.serverError(message: response.status.toString()),
              );
            }
          },
        );
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
