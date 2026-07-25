import 'dart:collection';
import 'package:injectable/injectable.dart';
import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/service/logger/queue_logger.dart';
import 'package:offline_engine/service/queue_manager/enums/queue_enums.dart';

@lazySingleton
class QueueManager {
  final Queue<SyncOperationItem> _queue = Queue();

  void enqueue(SyncOperationItem operation) {
    // Resolve the state
    // CREATE DELETE
    // CREATE UPDATE
    // UPDATE UPDATE
    // UPDATE DELETE

    _queue.add(operation);

    QueueLogger.printState(QueueAction.enqueue, [operation], length);
  }

  void enqueueAll(Iterable<SyncOperationItem> operations) {
    // Resolve the state
    // CREATE DELETE
    // CREATE UPDATE
    // UPDATE UPDATE
    // UPDATE DELETE

    _queue.addAll(operations);

    QueueLogger.printState(QueueAction.enqueueAll, operations, length);
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

  bool get isEmpty => _queue.isEmpty;

  int get length => _queue.length;

  List<SyncOperationItem> get items => List.unmodifiable(_queue);

  void clear() {
    _queue.clear();
    QueueLogger.printState(QueueAction.clear, null, length);
  }
}
