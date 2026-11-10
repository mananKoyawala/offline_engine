import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_response.freezed.dart';
part 'otp_response.g.dart';

// --- Verify OTP ---

@freezed
abstract class VerifyOtpResponse with _$VerifyOtpResponse {
  const factory VerifyOtpResponse({
    @Default(false) bool success,
    @Default(0) @JsonKey(name: 'status_code') int statusCode,
    @Default('') String message,
    @Default('') String error,
    VerifyOtpData? data,
  }) = _VerifyOtpResponse;

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);
}

@freezed
abstract class VerifyOtpData with _$VerifyOtpData {
  const factory VerifyOtpData({
    @Default(OtpUser()) OtpUser user,
    @Default('') @JsonKey(name: 'access_token') String accessToken,
    @Default('') @JsonKey(name: 'refresh_token') String refreshToken,
  }) = _VerifyOtpData;

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpDataFromJson(json);
}

@freezed
abstract class OtpUser with _$OtpUser {
  const factory OtpUser({
    @Default('') String id,
    @Default('') @JsonKey(name: 'full_name') String fullName,
    @Default('') String email,
    @Default(false) @JsonKey(name: 'email_verified') bool emailVerified,
    @JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt,
  }) = _OtpUser;

  factory OtpUser.fromJson(Map<String, dynamic> json) =>
      _$OtpUserFromJson(json);
}

// --- Resend OTP ---

@freezed
abstract class ResendOtpResponse with _$ResendOtpResponse {
  const factory ResendOtpResponse({
    @Default(false) bool success,
    @Default(0) @JsonKey(name: 'status_code') int statusCode,
    @Default('') String message,
    @Default('') String error,
  }) = _ResendOtpResponse;

  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$ResendOtpResponseFromJson(json);
}
