import 'package:offline_engine/core/import/app_imports.dart';
import 'package:offline_engine/service/sync_processor/enums/sync_processor_enums.dart';

part 'sync_processor_response.freezed.dart';
part 'sync_processor_response.g.dart';

@freezed
abstract class SyncProcessorResponse with _$SyncProcessorResponse {
  const SyncProcessorResponse._();

  const factory SyncProcessorResponse({
    @Default(false) bool success,
    @Default(0) int status,
    @Default(SyncProcessorSummary()) SyncProcessorSummary summary,
    @Default(<SyncProcessorOperation>[]) List<SyncProcessorOperation> data,
  }) = _SyncProcessorResponse;

  factory SyncProcessorResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncProcessorResponseFromJson(json);
}

@freezed
abstract class SyncProcessorSummary with _$SyncProcessorSummary {
  const factory SyncProcessorSummary({
    @Default(0) int total,
    @Default(0) int success,
    @Default(0) int conflict,
    @Default(0) int failed,
  }) = _SyncProcessorSummary;

  factory SyncProcessorSummary.fromJson(Map<String, dynamic> json) =>
      _$SyncProcessorSummaryFromJson(json);
}

@freezed
abstract class SyncProcessorOperation with _$SyncProcessorOperation {
  const factory SyncProcessorOperation({
    @JsonKey(name: 'operation_id') @Default('') String operationId,

    @JsonKey(name: 'entity_id') @Default('') String entityId,

    @JsonKey(name: 'op_type') SyncOperationType? opType,

    SyncOperationStatus? status,

    @JsonKey(name: 'requires_resolution')
    @Default(false)
    bool requiresResolution,

    @JsonKey(name: 'conflict_type') SyncConflictType? conflictType,

    @JsonKey(name: 'client_version') @Default(0) int clientVersion,

    @JsonKey(name: 'server_version') int? serverVersion,

    @JsonKey(name: 'conflict_data') SyncProcessorConflictData? conflictData,

    SyncProcessorError? error,
  }) = _SyncProcessorOperation;

  factory SyncProcessorOperation.fromJson(Map<String, dynamic> json) =>
      _$SyncProcessorOperationFromJson(json);
}

@freezed
abstract class SyncProcessorConflictData with _$SyncProcessorConflictData {
  const factory SyncProcessorConflictData({
    @Default('') String id,
    @Default('') String title,
    String? description,
    @Default(0) int priority,

    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,

    @Default(0) int version,

    @JsonKey(name: 'user_id') @Default('') String userId,

    @JsonKey(name: 'created_at') @Default('') String createdAt,

    @JsonKey(name: 'updated_at') @Default('') String updatedAt,

    @JsonKey(name: 'deleted_at') String? deletedAt,
  }) = _SyncProcessorConflictData;

  factory SyncProcessorConflictData.fromJson(Map<String, dynamic> json) =>
      _$SyncProcessorConflictDataFromJson(json);
}

@freezed
abstract class SyncProcessorError with _$SyncProcessorError {
  const factory SyncProcessorError({
    @Default('') String code,
    @Default('') String detail,
    @Default(<String, dynamic>{}) Map<String, dynamic> fields,
  }) = _SyncProcessorError;

  factory SyncProcessorError.fromJson(Map<String, dynamic> json) =>
      _$SyncProcessorErrorFromJson(json);
}
