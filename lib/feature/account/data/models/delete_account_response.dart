import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_account_response.freezed.dart';
part 'delete_account_response.g.dart';

@freezed
abstract class DeleteAccountResponse with _$DeleteAccountResponse {
  const factory DeleteAccountResponse({
    @Default(false) bool success,
    @Default(0) @JsonKey(name: 'status_code') int statusCode,
    @Default('') String message,
    @Default('') String error,
    DeleteAccountData? data,
  }) = _DeleteAccountResponse;

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountResponseFromJson(json);
}

@freezed
abstract class DeleteAccountData with _$DeleteAccountData {
  const factory DeleteAccountData({
    @Default(0) @JsonKey(name: 'request_id') int requestId,
    @Default('') String status,
    @JsonKey(name: 'requested_at') DateTime? requestedAt,
  }) = _DeleteAccountData;

  factory DeleteAccountData.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountDataFromJson(json);
}
