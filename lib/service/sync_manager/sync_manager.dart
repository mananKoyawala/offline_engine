import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:offline_engine/feature/tasks/presentation/getters/sync_operation_getters.dart';
import 'package:offline_engine/service/internet_service/internet_service.dart';
import 'package:offline_engine/service/operation_resolver/sync_operation_response_resolver.dart';
import 'package:offline_engine/service/queue_manager/queue_manager.dart';
import 'package:offline_engine/service/sync_processor/getters/sync_manager_getters.dart';
import 'package:offline_engine/service/sync_processor/params/sync_processor_params.dart';

@injectable
class SyncManager {
  final QueueManager _queueManager;
  final InternetService _internetService;

  SyncManager(this._queueManager, this._internetService);

  static bool _isSyncing = false;

  StreamSubscription<bool>? _internetSubscription;

  bool _isInitialized = false;
  bool _isInitializing = false;

  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;

    _isInitializing = true;

    try {
      await _internetService.initialize();

      _internetSubscription ??= _internetService.onStatusChanged.listen((
        isConnected,
      ) async {
        log('Internet status: $isConnected');

        if (isConnected) {
          await _processQueue();
          startSyncAll();
        }
      });

      _isInitialized = true;
    } finally {
      _isInitializing = false;
    }
  }

  void startSyncAll() async {
    if (_isSyncing || !_internetService.isConnected) return;
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
            await SyncOperationResponseResolver.resolveFailure(
              operations,
              failure,
            );
          },
          (response) async {
            log("Success : ${response.success}");

            await SyncOperationResponseResolver.resolveResponse(response);
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

  void stopSync() {}

  Future<void> _processQueue() async {
    final result = await getAllPendingOperationsUsecase();

    result.fold(
      (failure) {
        log('Failed to fetch pending operations');
      },
      (operations) {
        _queueManager.enqueueAll(operations);
      },
    );
  }
}
