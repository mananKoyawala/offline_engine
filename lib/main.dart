import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_engine/core/app_container.dart';
import 'package:offline_engine/core/theme/colors.dart';
import 'package:offline_engine/core/theme/theme_provider.dart';
import 'package:offline_engine/core/navigator_key.dart';
import 'package:offline_engine/feature/splash/presentation/pages/splash_page.dart';
import 'package:offline_engine/locator/locator.dart';
import 'package:offline_engine/shared/widgets/sync_banner_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  final container = ProviderContainer();
  appContainer = container;
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const OfflineEngineApp(),
    ),
  );
}

class OfflineEngineApp extends ConsumerWidget {
  const OfflineEngineApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;

    return MaterialApp(
      title: 'Offline Engine',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: appColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: appColor,
          brightness: Brightness.dark,
        ),
      ),
      home: SpalshPage(),
      builder: (context, child) =>
          SyncBannerWrapper(child: child ?? const SizedBox.shrink()),
    );
  }
}
