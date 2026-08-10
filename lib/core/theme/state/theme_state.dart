import 'package:offline_engine/core/import/app_imports.dart';

part 'theme_state.freezed.dart';

@freezed
abstract class ThemeState with _$ThemeState {
  const factory ThemeState({@Default(false) bool isDarkMode}) = _ThemeState;
}
