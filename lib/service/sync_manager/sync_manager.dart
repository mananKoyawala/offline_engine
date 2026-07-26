import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:offline_engine/feature/presentation/getters/sync_operation_getters.dart';
import 'package:offline_engine/service/queue_manager/queue_manager.dart';
import 'package:offline_engine/service/sync_processor/getters/sync_manager_getters.dart';
import 'package:offline_engine/service/sync_processor/params/sync_processor_params.dart';

@injectable
class SyncManager {
  final QueueManager _queueManager;

  SyncManager(this._queueManager);

  bool _isSyncing = false;

  @postConstruct
  void initialize() async {
    final result = await getAllPendingOperationsUsecase();
    result.fold(
      (failure) {
        log('failed to fetch pending operations');
      },
      (operations) {
        _queueManager.enqueueAll(operations);

        // TODO : Make it automatically
        startSync();
      },
    );
  } // Load all pending operations

  void startSync() async {
    if (_isSyncing) return;

    _isSyncing = true;

    // peek operation from queue
    final operation = _queueManager.peek();

    if (operation != null) {
      // send to backend

      final result = await syncOperationUsecase([
        SyncProcessorParams.fromOperation(operation),
      ]);
      result.fold(
        (failure) {
          log("Failure : ${failure.message}");
        },
        (response) {
          log("Success : ${response.success}");
        },
      );
    }
  }

  void stopSync() {}

  void processQueue() {}
}
