import 'dart:developer';

import 'package:offline_engine/feature/data/models/sync_operation_item.dart';
import 'package:offline_engine/feature/domain/enitites/task_entity.dart';
import 'package:offline_engine/feature/domain/params/create_task_params.dart';
import 'package:offline_engine/feature/domain/params/update_task_params.dart';
import 'package:offline_engine/feature/presentation/enums/task_priority.dart';
import 'package:offline_engine/feature/presentation/provider/getters/sync_operation_getters.dart';
import 'package:offline_engine/feature/presentation/provider/getters/task_getters.dart';
import 'package:offline_engine/feature/presentation/provider/state/task_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_provider.g.dart';

@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  TaskState build() {
    return const TaskState();
  }

  void callTheflow() async {
    List<TaskEntity> data = await getTasksLocalUsecase();
    List<SyncOperationItem> syncData = await getSyncOperationLocalUsecase();
    log('TASK LIST : ${data.length}');
    log('SYNC OPERATION LIST : ${syncData.length}');

    if (await createTasksLocalUsecase(
      CreateTaskParams(
        title: "title1",
        description: "description1",
        priority: TaskPriority.low,
      ),
    )) {
      log("Created");
    } else {
      log("Not created");
    }

    if (await updateTasksLocalUsecase(
      UpdateTaskParams(
        id: data.first.id,
        title: data.first.title,
        description: data.first.description,
        priority: data.first.priority,
        isCompleted: true,
      ),
    )) {
      log("Updated");
    } else {
      log("Not updated");
    }

    data = await getTasksLocalUsecase();

    if (await deleteTasksLocalUsecase(
      UpdateTaskParams(
        id: data.first.id,
        title: data.first.title,
        description: data.first.description,
        priority: data.first.priority,
        isCompleted: true,
      ),
    )) {
      log("Deleted");
    } else {
      log("Not deleted");
    }

    data = await getTasksLocalUsecase();

    log('TASK LIST : ${data.length}');
  }
}
