import 'package:json_annotation/json_annotation.dart';
import 'package:offline_engine/core/import/app_imports.dart';

part 'update_task_params.freezed.dart';
part 'update_task_params.g.dart';

@freezed
abstract class UpdateTaskParams with _$UpdateTaskParams {
  const factory UpdateTaskParams({
    required String id,
    required String title,
    required String description,
    required TaskPriority priority,
    @JsonKey(name: 'is_completed') required bool isCompleted,
  }) = _UpdateTaskParams;

  factory UpdateTaskParams.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskParamsFromJson(json);
}
