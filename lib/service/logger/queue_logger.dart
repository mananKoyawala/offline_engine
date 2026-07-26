import 'dart:developer';

import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/service/queue_manager/enums/queue_enums.dart';

class QueueLogger {
  static void printState(
    QueueAction action,
    Iterable<SyncOperationItem>? operations,
    int length,
  ) {
    log('''
================ Queue ================
Action     : ${action.name}
Queue Size : $length
Operations :
${operations == null || operations.isEmpty ? 'None' : operations.map((e) => '  • ${e.type} | ${e.taskId}').join('\n')}
=======================================
''');
  }
}

// TODO : Just Queue is setting as of now. We have to proceed futher for api call, mark success, conflict resolve and failed
