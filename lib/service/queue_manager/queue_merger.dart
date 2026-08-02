import 'dart:developer';

import 'package:offline_engine/feature/tasks/data/models/sync_operation_item.dart';
import 'package:offline_engine/service/queue_manager/enums/queue_enums.dart';

//  TODO : APPLY COMMENT LOGIC AT TIME OF MARK STATUS SUCCESS
class MergeQueue {
  static void mergeOperation(
    QueueMerger type,
    SyncOperationItem first,
    SyncOperationItem last,
    List<SyncOperationItem> resultItems,
    List<String> autoResolvedTaskIds,
  ) {
    switch (type) {
      case QueueMerger.DEFAULT:
        log('GOT DEFAULT ITEM');
        // Fresh Item.
        resultItems.add(first);
        break;
      case QueueMerger.CREATE_UPDATE:
        log('GOT CREATE - UPDATE ITEM');
        // Mark all the operation as merged except the create one.
        resultItems.add(first.copyWith(payload: last.payload));
        break;
      case QueueMerger.CREATE_DELETE:
        // Marked all the operation as discarded
        autoResolvedTaskIds.add(first.taskId);
        log('GOT CREATE - DELETE ITEM');
        break;
      case QueueMerger.UPDATE_UPDATE:
        resultItems.add(last);
        // Mark all the operation as merged except the last one
        log('GOT UPDATE - UPDATE ITEM');
        break;
      case QueueMerger.UPDATE_DELETE:
        resultItems.add(last);
        // Mark all the operation as merged except the last one.
        log('GOT UPDATE - DELETE ITEM');
        break;
    }
  }
}
