import 'package:fluttertoast/fluttertoast.dart';
import 'package:offline_engine/feature/domain/params/create_task_params.dart';
import 'package:offline_engine/feature/domain/params/update_task_params.dart';
import 'package:offline_engine/feature/presentation/getters/task_getters.dart';
import 'package:offline_engine/feature/presentation/provider/state/task_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_provider.g.dart';

@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  TaskState build() {
    Future.microtask(refresh);
    return const TaskState(isLoading: true);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await getTasksLocalUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load tasks',
        );
      },
      (tasks) {
        state = state.copyWith(tasks: tasks, isLoading: false);
      },
    );
  }

  Future<void> createTask(CreateTaskParams params) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    final result = await createTasksLocalUsecase(params);

    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: "Failed to create task");
        state = state.copyWith(isSubmitting: false);
      },
      (taskCreated) async {
        if (taskCreated) {
          Fluttertoast.showToast(msg: "Task created");
          await refresh();
        } else {
          Fluttertoast.showToast(msg: "Failed to create task");
        }
      },
    );
  }

  Future<void> updateTask(UpdateTaskParams params) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    final result = await updateTasksLocalUsecase(params);

    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: "Failed to update task");
        state = state.copyWith(isSubmitting: false);
      },
      (taskUpdated) async {
        if (taskUpdated) {
          Fluttertoast.showToast(msg: "Task updated");
          await refresh();
        } else {
          Fluttertoast.showToast(msg: "Failed to update task");
        }
        state = state.copyWith(isSubmitting: false);
      },
    );
  }

  Future<void> deleteTask(UpdateTaskParams params, {String? taskId}) async {
    final previousTasks = state.tasks;
    if (taskId != null) {
      state = state.copyWith(
        tasks: previousTasks.where((t) => t.id != taskId).toList(),
        clearError: true,
      );
    }

    final result = await deleteTasksLocalUsecase(params);

    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: "Failed to delete task");
        state = state.copyWith(tasks: previousTasks);
      },
      (taskDeleted) async {
        if (taskDeleted) {
          Fluttertoast.showToast(msg: "Task deleted");
          await refresh();
        } else {
          Fluttertoast.showToast(msg: "Failed to delete task");
          state = state.copyWith(tasks: previousTasks);
        }
      },
    );
  }

  Future<void> fetchLocalTasks() async {
    final result = await getTasksLocalUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(tasks: []);
      },
      (tasks) {
        state = state.copyWith(tasks: tasks);
      },
    );
  }
}
