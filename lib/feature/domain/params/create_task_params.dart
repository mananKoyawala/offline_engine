import 'package:offline_engine/core/import/app_imports.dart';

part 'create_task_params.freezed.dart';
part 'create_task_params.g.dart';

@freezed
abstract class CreateTaskParams with _$CreateTaskParams {
  const factory CreateTaskParams({
    required String title,
    required String description,
    required TaskPriority priority,
  }) = _CreateTaskParams;

  factory CreateTaskParams.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskParamsFromJson(json);
}
