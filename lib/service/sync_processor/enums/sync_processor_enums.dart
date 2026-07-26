import 'package:offline_engine/core/import/app_imports.dart';

enum SyncOperationType {
  @JsonValue('create')
  create,

  @JsonValue('update')
  update,

  @JsonValue('delete')
  delete,
}

enum SyncOperationStatus {
  @JsonValue('success')
  success,

  @JsonValue('conflict')
  conflict,

  @JsonValue('failed')
  failed,
}

enum SyncConflictType {
  @JsonValue('duplicate_create')
  duplicateCreate,

  @JsonValue('deleted')
  deleted,
}
