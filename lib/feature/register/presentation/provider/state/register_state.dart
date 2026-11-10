import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
abstract class RegisterState with _$RegisterState {
  const RegisterState._();

  const factory RegisterState({
    @Default(false) bool isLoading,
    @Default(null) String? errorMessage,
    @Default(false) bool hasError,
    @Default(false) bool isSuccess,
  }) = _RegisterState;
}
