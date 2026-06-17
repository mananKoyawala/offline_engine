import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:offline_engine/feature/domain/enitites/task_entity.dart';

part 'task_state.freezed.dart';

@freezed
abstract class TaskState with _$TaskState {
  const factory TaskState({
    String? error,
    @Default(false) bool isLoading,
    @Default(null) String? errorMessage,
    @Default(false) clearError,
    @Default(false) isSubmitting,
    @Default([]) List<TaskEntity> tasks,
  }) = _TaskState;
}
