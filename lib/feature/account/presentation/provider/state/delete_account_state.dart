import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_account_state.freezed.dart';

@freezed
abstract class DeleteAccountState with _$DeleteAccountState {
  const factory DeleteAccountState({
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    @Default(null) String? errorMessage,
  }) = _DeleteAccountState;
}
