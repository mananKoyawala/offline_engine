import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:offline_engine/core/global_getters.dart';
import 'package:offline_engine/feature/login/domain/params/login_params.dart';
import 'package:offline_engine/feature/login/presentation/getters/login_getters.dart';
import 'package:offline_engine/feature/login/presentation/provider/state/login_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_provider.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  Timer? _countdownTimer;
  static const int _retryDelaySeconds = 5;

  @override
  LoginState build() {
    ref.onDispose(() => _countdownTimer?.cancel());
    return const LoginState();
  }

  Future<bool> login() async {
    state = state.copyWith(isLoading: true, hasError: false);

    final params = LoginParams(email: 'manan@gmail.com', password: 'Manan@123');

    final result = await loginUsecases.call(params);

    return await result.fold<Future<bool>>(
      (failure) async {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          hasError: true,
        );
        _startRetryCountdown();
        return false;
      },
      (response) async {
        if (response.success) {
          await prefsInstance.setAccessToken(response.data.accessToken);
          await prefsInstance.setRefreshToken(response.data.refreshToken);
          state = state.copyWith(isLoading: false, hasError: false);
        } else {
          state = state.copyWith(
            isLoading: false,
            hasError: true,
            errorMessage: 'Failed to login. Check what was the problem',
          );
          Fluttertoast.showToast(
            msg: 'Failed to login. Check what was the problem',
          );
          _startRetryCountdown();
        }

        return response.success;
      },
    );
  }

  void _startRetryCountdown() {
    _countdownTimer?.cancel();
    state = state.copyWith(retryCountDown: _retryDelaySeconds);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.retryCountDown <= 1) {
        timer.cancel();
        state = state.copyWith(retryCountDown: 0);
      } else {
        state = state.copyWith(retryCountDown: state.retryCountDown - 1);
      }
    });
  }
}
