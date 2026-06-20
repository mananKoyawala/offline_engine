import 'package:offline_engine/core/import/app_imports.dart';

part 'update_task_params.freezed.dart';
part 'update_task_params.g.dart';

@freezed
abstract class UpdateTaskParams with _$UpdateTaskParams {
  const factory UpdateTaskParams({
    required String id,
    required String title,
    required String description,
    @TaskPriorityConverter() required TaskPriority priority,
    required bool isCompleted,
  }) = _UpdateTaskParams;

  factory UpdateTaskParams.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskParamsFromJson(json);
}

class TaskPriorityConverter implements JsonConverter<TaskPriority, int> {
  const TaskPriorityConverter();

  @override
  TaskPriority fromJson(int json) {
    return TaskPriority.fromValue(json);
  }

  @override
  int toJson(TaskPriority object) {
    return object.value;
  }
}
