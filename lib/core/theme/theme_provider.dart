import 'package:offline_engine/core/theme/state/theme_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeState build() {
    return ThemeState();
  }

  void changeThemeMode(bool value) {
    state = state.copyWith(isDarkMode: value);
  }
}
