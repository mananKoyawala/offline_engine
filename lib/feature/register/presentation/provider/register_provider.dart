import 'package:fluttertoast/fluttertoast.dart';
import 'package:todus/core/constants.dart';
import 'package:todus/feature/register/domain/params/register_params.dart';
import 'package:todus/feature/register/presentation/getters/register_getters.dart';
import 'package:todus/feature/register/presentation/provider/state/register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_provider.g.dart';

@riverpod
class RegisterNotifier extends _$RegisterNotifier {
  @override
  RegisterState build() {
    return const RegisterState();
  }

  /// Returns the success message from the server on success, null on failure.
  Future<String?> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, hasError: false, isSuccess: false);

    final params = RegisterParams(
      fullName: fullName,
      email: email,
      password: password,
    );

    final result = await registerUsecases.call(params);

    return result.fold<String?>(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          hasError: true,
        );
        Fluttertoast.showToast(msg: reigsterErr);
        return null;
      },
      (response) {
        if (response.success) {
          state = state.copyWith(
            isLoading: false,
            hasError: false,
            isSuccess: true,
          );
          return response.message;
        } else {
          final msg = response.error.isNotEmpty
              ? response.error
              : response.message;
          state = state.copyWith(
            isLoading: false,
            hasError: true,
            errorMessage: msg,
          );
          Fluttertoast.showToast(msg: msg);
          return null;
        }
      },
    );
  }

  void resetState() {
    state = const RegisterState();
  }
}
