import 'dart:collection';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/service/logger/queue_logger.dart';
import 'package:offline_engine/service/queue_manager/enums/queue_enums.dart';

class QueueManager {
  static final Queue<SyncOperationItem> _queue = Queue();

  static void enqueue(SyncOperationItem operation) {
    // Resolve the state
    // CREATE DELETE
    // CREATE UPDATE
    // UPDATE UPDATE
    // UPDATE DELETE

    _queue.add(operation);

    QueueLogger.printState(QueueAction.enqueue, [operation], length);
  }

  static void enqueueAll(Iterable<SyncOperationItem> operations) {
    // Resolve the state
    // CREATE DELETE
    // CREATE UPDATE
    // UPDATE UPDATE
    // UPDATE DELETE

    _queue.addAll(operations);

    QueueLogger.printState(QueueAction.enqueueAll, operations, length);
  }

  static SyncOperationItem? dequeue() {
    if (_queue.isEmpty) return null;
    final operation = _queue.removeFirst();

    QueueLogger.printState(QueueAction.dequeue, [operation], length);

    return operation;
  } // Deletes the first element of Queue

  static SyncOperationItem? peek() {
    final operation = _queue.firstOrNull;
    QueueLogger.printState(
      QueueAction.peek,
      operation != null ? [operation] : null,
      length,
    );

    return operation;
  } // Returns first element of Queue

  static bool get isEmpty => _queue.isEmpty;

  static int get length => _queue.length;

  static List<SyncOperationItem> get items => List.unmodifiable(_queue);

  static void clear() {
    _queue.clear();
    QueueLogger.printState(QueueAction.clear, null, length);
  }
}
