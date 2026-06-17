import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:offline_engine/feature/domain/enitites/task_entity.dart';
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
    try {
      final tasks = await getTasksLocalUsecase();
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e, st) {
      log('Failed to load tasks', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load tasks',
      );
    }
  }

  Future<bool> createTask(CreateTaskParams params) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final taskCreated = await createTasksLocalUsecase(params);

      if (taskCreated) {
        Fluttertoast.showToast(msg: "Task created");
        await refresh();
      } else {
        Fluttertoast.showToast(msg: "Failed to create task");
      }
      state = state.copyWith(isSubmitting: false);
      return taskCreated;
    } catch (e, st) {
      log('Failed to create task', error: e, stackTrace: st);
      Fluttertoast.showToast(msg: "Failed to create task");
      state = state.copyWith(isSubmitting: false);
      return false;
    }
  }

  Future<bool> updateTask(UpdateTaskParams params) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final taskUpdated = await updateTasksLocalUsecase(params);

      if (taskUpdated) {
        Fluttertoast.showToast(msg: "Task updated");
        await refresh();
      } else {
        Fluttertoast.showToast(msg: "Failed to update task");
      }
      state = state.copyWith(isSubmitting: false);
      return taskUpdated;
    } catch (e, st) {
      log('Failed to update task', error: e, stackTrace: st);
      Fluttertoast.showToast(msg: "Failed to update task");
      state = state.copyWith(isSubmitting: false);
      return false;
    }
  }

  Future<bool> deleteTask(UpdateTaskParams params, {String? taskId}) async {
    final previousTasks = state.tasks;
    if (taskId != null) {
      state = state.copyWith(
        tasks: previousTasks.where((t) => t.id != taskId).toList(),
        clearError: true,
      );
    }

    try {
      final taskDeleted = await deleteTasksLocalUsecase(params);

      if (taskDeleted) {
        Fluttertoast.showToast(msg: "Task deleted");
        await refresh();
      } else {
        Fluttertoast.showToast(msg: "Failed to delete task");
        state = state.copyWith(tasks: previousTasks);
      }
      return taskDeleted;
    } catch (e, st) {
      log('Failed to delete task', error: e, stackTrace: st);
      Fluttertoast.showToast(msg: "Failed to delete task");
      state = state.copyWith(tasks: previousTasks);
      return false;
    }
  }

  Future<List<TaskEntity>> fetchLocalTasks() async {
    final tasks = await getTasksLocalUsecase();
    state = state.copyWith(tasks: tasks);
    return tasks;
  }
}
