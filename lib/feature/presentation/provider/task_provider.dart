import 'dart:developer';

import 'package:offline_engine/feature/domain/enitites/task_entity.dart';
import 'package:offline_engine/feature/domain/params/update_task_params.dart';
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

  void callTheflow() async {}
}
