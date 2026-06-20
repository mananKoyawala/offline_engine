import 'package:freezed_annotation/freezed_annotation.dart';
part 'api_response.freezed.dart';
part 'api_response.g.dart';

@freezed
abstract class APIResponse with _$APIResponse {
  const APIResponse._();

  const factory APIResponse({
    @Default(false) bool status,
    @Default('') String message,
  }) = _APIResponse;

  factory APIResponse.fromJson(Map<String, dynamic> json) =>
      _$APIResponseFromJson(json);
}
