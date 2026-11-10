import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_state.freezed.dart';

@freezed
abstract class OtpState with _$OtpState {
  const OtpState._();

  const factory OtpState({
    @Default(false) bool isVerifying,
    @Default(false) bool isResending,
    @Default(false) bool hasError,
    @Default(null) String? errorMessage,
    @Default(0) int resendCountdown,
  }) = _OtpState;

  bool get canResend => resendCountdown == 0 && !isResending;
}
