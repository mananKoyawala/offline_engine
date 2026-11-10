import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todus/feature/register/domain/params/otp_params.dart';
import 'package:todus/feature/register/presentation/getters/otp_getters.dart';
import 'package:todus/feature/register/presentation/provider/state/otp_state.dart';

part 'otp_provider.g.dart';

const int _resendCooldownSeconds = 30;

@riverpod
class OtpNotifier extends _$OtpNotifier {
  Timer? _countdownTimer;

  @override
  OtpState build() {
    ref.onDispose(() => _countdownTimer?.cancel());
    // Start with cooldown so user can't immediately resend
    _startResendCountdown();
    return OtpState(resendCountdown: _resendCooldownSeconds);
  }

  /// Verifies the OTP. Returns the [VerifyOtpData] on success, null on failure.
  Future<({String accessToken, String refreshToken, String message})?> verifyOtp({
    required String email,
    required String otp,
  }) async {
    state = state.copyWith(isVerifying: true, hasError: false);

    final result = await otpUsecases.verifyOtp(
      VerifyOtpParams(email: email, otp: otp),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isVerifying: false,
          hasError: true,
          errorMessage: failure.message,
        );
        return null;
      },
      (response) {
        if (response.success && response.data != null) {
          state = state.copyWith(isVerifying: false, hasError: false);
          return (
            accessToken: response.data!.accessToken,
            refreshToken: response.data!.refreshToken,
            message: response.message,
          );
        } else {
          final msg = response.error.isNotEmpty
              ? response.error
              : response.message;
          state = state.copyWith(
            isVerifying: false,
            hasError: true,
            errorMessage: msg,
          );
          return null;
        }
      },
    );
  }

  Future<void> resendOtp({required String email}) async {
    if (!state.canResend) return;

    state = state.copyWith(isResending: true, hasError: false);

    final result = await otpUsecases.resendOtp(
      ResendOtpParams(email: email),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isResending: false,
          hasError: true,
          errorMessage: failure.message,
        );
      },
      (response) {
        if (response.success) {
          state = state.copyWith(
            isResending: false,
            hasError: false,
            resendCountdown: _resendCooldownSeconds,
          );
          Fluttertoast.showToast(msg: response.message);
          _startResendCountdown();
        } else {
          final msg = response.error.isNotEmpty
              ? response.error
              : response.message;
          state = state.copyWith(
            isResending: false,
            hasError: true,
            errorMessage: msg,
          );
        }
      },
    );
  }

  void _startResendCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCountdown <= 1) {
        timer.cancel();
        state = state.copyWith(resendCountdown: 0);
      } else {
        state = state.copyWith(resendCountdown: state.resendCountdown - 1);
      }
    });
  }
}
