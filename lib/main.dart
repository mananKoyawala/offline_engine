import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todus/core/app_container.dart';
import 'package:todus/core/theme/colors.dart';
import 'package:todus/core/theme/theme_provider.dart';
import 'package:todus/core/navigator_key.dart';
import 'package:todus/feature/splash/presentation/pages/splash_page.dart';
import 'package:todus/locator/locator.dart';
import 'package:todus/shared/widgets/sync_banner_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await setupLocator();
  final container = ProviderContainer();
  appContainer = container;
  runApp(
    UncontrolledProviderScope(container: container, child: const TodusApp()),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  });
}

class TodusApp extends ConsumerWidget {
  const TodusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;

    return MaterialApp(
      title: 'Todus',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
      ),
      home: SpalshPage(),
      builder: (context, child) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SyncBannerWrapper(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
