import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_engine/feature/tasks/presentation/getters/sync_operation_getters.dart';
import 'package:offline_engine/feature/tasks/presentation/getters/task_getters.dart';
import 'package:offline_engine/service/internet_service/internet_service.dart';
import 'package:offline_engine/service/operation_resolver/sync_operation_response_resolver.dart';
import 'package:offline_engine/service/queue_manager/queue_manager.dart';
import 'package:offline_engine/service/sync_event_bus/sync_event_bus.dart';
import 'package:offline_engine/service/sync_processor/getters/sync_manager_getters.dart';
import 'package:offline_engine/service/sync_processor/params/sync_processor_params.dart';

@lazySingleton
class SyncManager with WidgetsBindingObserver {
  final QueueManager _queueManager;
  final InternetService _internetService;
  final SyncEventBus _syncEventBus;

  SyncManager(this._queueManager, this._internetService, this._syncEventBus);

  bool _isSyncing = false;
  bool _isFetchingRemote = false;

  final StreamController<bool> _syncingStateController =
      StreamController<bool>.broadcast();

  /// Emits `true` when a sync starts and `false` when it ends.
  Stream<bool> get onSyncingStateChanged => _syncingStateController.stream;

  StreamSubscription<bool>? _internetSubscription;
  StreamSubscription<void>? _taskWriteSubscription;
  Timer? _syncDebounceTimer;

  // Fires after a successful remote fetch so listeners (e.g. TaskNotifier)
  // can refresh themselves without SyncManager knowing about Riverpod.
  final StreamController<void> _remoteFetchDoneController =
      StreamController<void>.broadcast();

  Stream<void> get onRemoteFetchDone => _remoteFetchDoneController.stream;

  bool _isInitialized = false;
  bool _isInitializing = false;

  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;

    _isInitializing = true;

    try {
      await _internetService.initialize();

      // Register globally for app lifecycle events.
      WidgetsBinding.instance.addObserver(this);

      // Fetch latest data from server on app start.
      await fetchRemoteTasks();

      // Sync when connectivity is restored.
      _internetSubscription ??= _internetService.onStatusChanged.listen((
        isConnected,
      ) async {
        log('Internet status: $isConnected');

        if (isConnected) {
          await fetchRemoteTasks();
          await _processQueue();
          startSyncAll();
        }
      });

      // Sync whenever a local task write is committed (create / update / delete).
      // Debounced by 5 seconds so rapid successive writes are batched into
      // a single sync call instead of firing one request per operation.
      _taskWriteSubscription ??= _syncEventBus.onTaskWritten.listen((_) {
        log('SyncEventBus: task written – debounce reset');
        _syncDebounceTimer?.cancel();
        _syncDebounceTimer = Timer(const Duration(seconds: 5), () async {
          log('SyncEventBus: debounce elapsed – syncing');
          await _processQueue();
          startSyncAll();
        });
      });

      _isInitialized = true;
    } finally {
      _isInitializing = false;
    }
  }

  // Called by Flutter when the app returns to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchRemoteTasks();
    }
  }

  /// Fetches the latest tasks from the server and upserts them into local DB.
  /// Notifies [onRemoteFetchDone] on success so UI layers can refresh.
  /// Safe to call at any time — skips if offline or already fetching.
  Future<void> fetchRemoteTasks() async {
    if (_isFetchingRemote || !_internetService.isConnected) return;

    _isFetchingRemote = true;
    log('# Fetching remote tasks...');

    try {
      final result = await fetchAndUpsertTasksUsecase();
      result.fold(
        (failure) => log('fetchRemoteTasks failed: ${failure.message}'),
        (_) {
          log('fetchRemoteTasks succeeded');
          if (!_remoteFetchDoneController.isClosed) {
            _remoteFetchDoneController.add(null);
          }
        },
      );
    } finally {
      _isFetchingRemote = false;
    }
  }

  void startSyncAll() async {
    if (_isSyncing || !_internetService.isConnected) return;
    log('# ========================');
    log('# Start of Syncing All Operations');
    log('# ========================');
    _isSyncing = true;
    if (!_syncingStateController.isClosed) _syncingStateController.add(true);

    try {
      final operations = _queueManager.peekAll();

      if (operations.isNotEmpty) {
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
      if (!_syncingStateController.isClosed) _syncingStateController.add(false);
    }

    await SyncOperationResponseResolver.resolveAutoResolvedTaskIds(
      _queueManager.getAutoResolvedTaskIds,
    );

    _queueManager.clear();

    // Notify listeners (e.g. TaskNotifier) to refresh the local task list
    // now that conflicts are resolved and operations are completed.
    if (!_remoteFetchDoneController.isClosed) {
      _remoteFetchDoneController.add(null);
    }

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

  @disposeMethod
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _syncDebounceTimer?.cancel();
    _internetSubscription?.cancel();
    _taskWriteSubscription?.cancel();
    _remoteFetchDoneController.close();
    _syncingStateController.close();
  }
}
