import 'package:offline_engine/core/import/app_imports.dart';

part 'task_api_response.g.dart';
part 'task_api_response.freezed.dart';

@freezed
abstract class TaskAPIResponse with _$TaskAPIResponse {
  const factory TaskAPIResponse({
    @Default(false) bool status,
    @Default('') String message,
    @Default([]) List<TaskItem> tasks,
  }) = _TaskAPIResponse;

  factory TaskAPIResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskAPIResponseFromJson(json);
}
