import 'dart:async';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:offline_engine/core/global_getters.dart';
import 'package:offline_engine/feature/tasks/domain/params/create_task_params.dart';
import 'package:offline_engine/feature/tasks/domain/params/update_task_params.dart';
import 'package:offline_engine/feature/tasks/presentation/enums/task_priority.dart';
import 'package:offline_engine/feature/tasks/presentation/getters/task_getters.dart';
import 'package:offline_engine/feature/tasks/presentation/provider/state/task_state.dart';
import 'package:offline_engine/service/audio/task_complete_sound_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_provider.g.dart';

@riverpod
class TaskNotifier extends _$TaskNotifier {
  StreamSubscription<void>? _remoteFetchSubscription;
  bool _isRefreshing = false;

  @override
  TaskState build() {
    // Auto-refresh whenever SyncManager completes a remote fetch.
    _remoteFetchSubscription?.cancel();
    _remoteFetchSubscription = syncManagerInstance.onRemoteFetchDone.listen(
      (_) {
        // Remote fetch already done by SyncManager — just reload local DB.
        if (!_isRefreshing) refresh();
      },
    );

    // Cancel the subscription when the provider is disposed.
    ref.onDispose(() => _remoteFetchSubscription?.cancel());

    Future.microtask(refresh);
    return const TaskState(isLoading: true);
  }

  Future<void> refresh({bool remote = false}) async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    state = state.copyWith(isLoading: true, clearError: true);

    // Hit the network only on explicit/manual refresh and when connected.
    if (remote && syncManagerInstance.isConnected) {
      await syncManagerInstance.fetchRemoteTasks();
    }

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

    _isRefreshing = false;
  }

  Future<void> createTask(CreateTaskParams params) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    final result = await createTasksLocalUsecase(params);

    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: 'Failed to create task');
        state = state.copyWith(isSubmitting: false);
      },
      (taskCreated) async {
        if (taskCreated) {
          Fluttertoast.showToast(msg: 'Task created');
          await refresh();
        } else {
          Fluttertoast.showToast(msg: 'Failed to create task');
        }
      },
    );
  }

  Future<void> updateTask(
    UpdateTaskParams params, {
    bool playCompletionSound = false,
  }) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    final result = await updateTasksLocalUsecase(params);

    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: 'Failed to update task');
        state = state.copyWith(isSubmitting: false);
      },
      (taskUpdated) async {
        if (taskUpdated) {
          Fluttertoast.showToast(msg: 'Task updated');
          if (playCompletionSound && params.isCompleted) {
            await TaskCompleteSoundService.playSelectedSound();
          }
          await refresh();
        } else {
          Fluttertoast.showToast(msg: 'Failed to update task');
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
        Fluttertoast.showToast(msg: 'Failed to delete task');
        state = state.copyWith(tasks: previousTasks);
      },
      (taskDeleted) async {
        if (taskDeleted) {
          Fluttertoast.showToast(msg: 'Task deleted');
          await refresh();
        } else {
          Fluttertoast.showToast(msg: 'Failed to delete task');
          state = state.copyWith(tasks: previousTasks);
        }
      },
    );
  }

  Future<void> fetchLocalTasks() async {
    final result = await getTasksLocalUsecase();

    result.fold((failure) {}, (tasks) {
      state = state.copyWith(tasks: tasks);
    });
  }

  Future<void> initScheduler() async {
    final createParams1 = CreateTaskParams(
      title: 'title 1',
      description: 'description 1',
      priority: TaskPriority.low,
    );

    final createParams2 = CreateTaskParams(
      title: 'title 2',
      description: 'description 2',
      priority: TaskPriority.medium,
    );

    final createParams3 = CreateTaskParams(
      title: 'title 3',
      description: 'description 3',
      priority: TaskPriority.high,
    );

    await _schedulerTime();
    await createTask(createParams1);

    await _schedulerTime();
    await createTask(createParams2);

    await _schedulerTime();
    await createTask(createParams3);

    await _schedulerTime();
    await fetchLocalTasks();
    log(state.tasks.length.toString());
    var task = state.tasks.first;
    final updateParams1 = UpdateTaskParams(
      id: task.id,
      title: task.title,
      description: 'Updated description',
      priority: TaskPriority.high,
      isCompleted: task.isCompleted,
    );

    await _schedulerTime();
    await updateTask(updateParams1);

    await _schedulerTime();
    await fetchLocalTasks();

    await _schedulerTime();
    final updateParams2 = UpdateTaskParams(
      id: task.id,
      title: 'Title updated',
      description: task.description,
      priority: task.priority,
      isCompleted: true,
    );
    await updateTask(updateParams2);

    await _schedulerTime();
    await fetchLocalTasks();

    await _schedulerTime();
    task = state.tasks.last;
    final deleteParams2 = UpdateTaskParams(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
      isCompleted: task.isCompleted,
    );
    await deleteTask(deleteParams2);
  }

  Future<void> _schedulerTime() async {
    await Future.delayed(const Duration(milliseconds: 1500));
  }
}
