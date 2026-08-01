import 'dart:convert';

import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/feature/tasks/presentation/enums/sync_operations.dart';

part 'sync_operation_item.freezed.dart';
part 'sync_operation_item.g.dart';

@freezed
abstract class SyncOperationItem with _$SyncOperationItem {
  const SyncOperationItem._();

  const factory SyncOperationItem({
    @Default(0) int id,
    @Default('') String taskId,
    @Default({}) Map<String, dynamic> payload,
    @Default(SyncStatus.failed) SyncStatus status,
    @Default(SyncOperations.create) SyncOperations type,

    DateTime? createdAt,
  }) = _SyncOperationItem;

  factory SyncOperationItem.fromJson(Map<String, dynamic> json) =>
      _$SyncOperationItemFromJson(json);

  factory SyncOperationItem.fromDrift(SyncOperation data) {
    return SyncOperationItem(
      id: data.id,
      payload: jsonDecode(data.payload),
      type: SyncOperations.fromValue(data.type),
      status: SyncStatus.fromValue(data.status),
      taskId: data.taskId,
    );
  }
}
