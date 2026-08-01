import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/tasks/domain/enitites/task_entity.dart';

part 'task_item.freezed.dart';
part 'task_item.g.dart';

@freezed
abstract class TaskItem with _$TaskItem {
  const TaskItem._();

  const factory TaskItem({
    String? id,
    String? title,
    String? description,
    int? priority,
    @Default(false) bool isCompleted,
    @Default(0) int version,
    DateTime? createdAt,
  }) = _TaskItem;

  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  factory TaskItem.fromDrift(Task task) {
    return TaskItem(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
      isCompleted: task.isCompleted,
      version: task.version,
      createdAt: task.createdAt,
    );
  }
}

extension TaskItemExt on TaskItem {
  TaskEntity toEntity() {
    return TaskEntity(
      id: id ?? '',
      title: title ?? '',
      description: description ?? '',
      priority: TaskPriority.fromValue(priority ?? 0),
      isCompleted: isCompleted,
    );
  }
}
