import 'package:offline_engine/core/global_getters.dart';
import 'package:offline_engine/core/theme/state/theme_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeState build() {
    return ThemeState(isDarkMode: prefsInstance.getThemeMode());
  }

  bool get isDarkMode => state.isDarkMode;

  Future<void> changeThemeMode(bool value) async {
    state = state.copyWith(isDarkMode: value);
    await prefsInstance.setThemeMode(value);
  }
}
