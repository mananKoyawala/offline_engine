import 'package:offline_engine/feature/tasks/data/models/sync_operation_item.dart';
import 'package:offline_engine/feature/tasks/presentation/enums/sync_operations.dart';
import 'package:offline_engine/feature/tasks/presentation/enums/task_priority.dart';
import 'package:offline_engine/service/sync_processor/enums/sync_processor_enums.dart';

class SyncProcessorParams {
  const SyncProcessorParams({
    required this.operationId,
    required this.id,
    required this.opType,
    this.clientVersion = 0,
    this.title,
    this.description,
    this.priority,
    this.isCompleted,
  });

  final String operationId;
  final String id;
  final SyncOperationType opType;
  final int clientVersion;
  final String? title;
  final String? description;
  final int? priority;
  final bool? isCompleted;

  factory SyncProcessorParams.fromOperation(SyncOperationItem operation) {
    final payload = operation.payload;

    return SyncProcessorParams(
      operationId: operation.id.toString(),
      id: operation.taskId,
      opType: switch (operation.type) {
        SyncOperations.create => SyncOperationType.create,
        SyncOperations.update => SyncOperationType.update,
        SyncOperations.delete => SyncOperationType.delete,
      },
      clientVersion: payload['version'] ?? 0,
      title: payload['title'],
      description: payload['description'],
      priority: TaskPriority.textToValue(payload['priority']),
      isCompleted: payload['is_completed'],
    );
  }

  Map<String, dynamic> toJson() => {
    'operation_id': operationId,
    'id': id,
    'op_type': opType.name,
    'client_version': clientVersion,
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (priority != null) 'priority': priority,
    if (isCompleted != null) 'is_completed': isCompleted,
  };
}
