import 'package:offline_engine/core/import/app_imports.dart';

part 'task_entity.freezed.dart';

@freezed
abstract class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    @Default('') String id,
    @Default('') String title,
    @Default('') String description,
    @Default(TaskPriority.medium) TaskPriority priority,
    @Default(false) bool isCompleted,
  }) = _TaskEntity;
}
