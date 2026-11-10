import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todus/feature/account/domain/params/delete_account_params.dart';
import 'package:todus/feature/account/presentation/getters/account_getters.dart';
import 'package:todus/feature/account/presentation/provider/state/delete_account_state.dart';

part 'delete_account_provider.g.dart';

@Riverpod(keepAlive: true)
class DeleteAccountNotifier extends _$DeleteAccountNotifier {
  @override
  DeleteAccountState build() => const DeleteAccountState();

  /// Returns the success message on success, null on failure.
  Future<String?> requestDeletion({required String reason}) async {
    state = state.copyWith(isLoading: true, hasError: false);

    final result = await accountUsecases.requestAccountDeletion(
      DeleteAccountParams(reason: reason),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: failure.message,
        );
        return null;
      },
      (response) {
        if (response.success) {
          state = state.copyWith(isLoading: false, hasError: false);
          Fluttertoast.showToast(
            msg:
                'Please wait for admin approval of your account deletion request',
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
          return null;
        }
      },
    );
  }
}
