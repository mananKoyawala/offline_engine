import 'package:offline_engine/core/import/app_imports.dart';

part 'conflict_resolver_params.freezed.dart';
part 'conflict_resolver_params.g.dart';

@freezed
abstract class ConflictResolverParams with _$ConflictResolverParams {
  const factory ConflictResolverParams({
    required String id,
    required String title,
    required String description,
    required TaskPriority priority,
    required bool isCompleted,
    required String createdAt,
    required String updatedAt,
    required String deletedAt,
  }) = _ConflictResolverParams;

  factory ConflictResolverParams.fromJson(Map<String, dynamic> json) =>
      _$ConflictResolverParamsFromJson(json);
}
