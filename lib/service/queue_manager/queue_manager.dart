import 'dart:collection';
import 'package:injectable/injectable.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/tasks/presentation/enums/sync_operations.dart';
import 'package:offline_engine/service/logger/queue_logger.dart';
import 'package:offline_engine/service/queue_manager/enums/queue_enums.dart';
import 'package:offline_engine/service/queue_manager/queue_merger.dart';

@lazySingleton
class QueueManager {
  final Queue<SyncOperationItem> _queue = Queue();
  List<String> _autoResolvedTaskIds = [];

  void enqueueAll(Iterable<SyncOperationItem> operations) {
    // Resolve the state
    final resolvedStates = _resolveQueueState(operations);

    clear();

    _queue.addAll(resolvedStates);

    QueueLogger.printState(QueueAction.enqueueAll, resolvedStates, length);
  }

  SyncOperationItem? dequeue() {
    if (_queue.isEmpty) return null;
    final operation = _queue.removeFirst();

    QueueLogger.printState(QueueAction.dequeue, [operation], length);

    return operation;
  } // Deletes the first element of Queue

  SyncOperationItem? peek() {
    final operation = _queue.firstOrNull;
    QueueLogger.printState(
      QueueAction.peek,
      operation != null ? [operation] : null,
      length,
    );

    return operation;
  } // Returns first element of Queue

  List<SyncOperationItem> peekAll() =>
      _queue.map((e) => e).toList(); // Returns Queue

  bool get isEmpty => _queue.isEmpty;

  int get length => _queue.length;

  List<SyncOperationItem> get items => List.unmodifiable(_queue);

  void clear() {
    _queue.clear();
    QueueLogger.printState(QueueAction.clear, null, length);
  }

  // Helper to resolve operation states
  Iterable<SyncOperationItem> _resolveQueueState(
    Iterable<SyncOperationItem> operations,
  ) {
    final distinctTaskItems = {
      for (final item in operations) item.taskId: item,
    }.values.toList();

    // Items should go for sync
    final List<SyncOperationItem> resultItems = [];
    final List<String> autoResolvedTaskIds = [];

    for (var item in distinctTaskItems) {
      final first = operations.firstWhere((i) => i.taskId == item.taskId);
      final last = operations.lastWhere((i) => i.taskId == item.taskId);

      if (first.id == last.id) {
        MergeQueue.mergeOperation(
          QueueMerger.DEFAULT,
          first,
          last,
          resultItems,
          autoResolvedTaskIds,
        );
      } else if (first.type == SyncOperations.create &&
          last.type == SyncOperations.update) {
        MergeQueue.mergeOperation(
          QueueMerger.CREATE_UPDATE,
          first,
          last,
          resultItems,
          autoResolvedTaskIds,
        );
      } else if (first.type == SyncOperations.update &&
          last.type == SyncOperations.update) {
        MergeQueue.mergeOperation(
          QueueMerger.UPDATE_UPDATE,
          first,
          last,
          resultItems,
          autoResolvedTaskIds,
        );
      } else if (first.type == SyncOperations.create &&
          last.type == SyncOperations.delete) {
        MergeQueue.mergeOperation(
          QueueMerger.CREATE_DELETE,
          first,
          last,
          resultItems,
          autoResolvedTaskIds,
        );
      } else if (first.type == SyncOperations.update &&
          last.type == SyncOperations.delete) {
        MergeQueue.mergeOperation(
          QueueMerger.UPDATE_DELETE,
          first,
          last,
          resultItems,
          autoResolvedTaskIds,
        );
      }
    }

    setAutoResolvedTaskIds = autoResolvedTaskIds; // Resolved by SyncManager

    return resultItems;
  }

  set setAutoResolvedTaskIds(List<String> ids) => _autoResolvedTaskIds = ids;

  List<String> get getAutoResolvedTaskIds => _autoResolvedTaskIds;
}
