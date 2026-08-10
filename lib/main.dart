import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_engine/core/app_container.dart';
import 'package:offline_engine/core/navigator_key.dart';
import 'package:offline_engine/feature/splash/presentation/pages/spalsh_page.dart';
import 'package:offline_engine/locator/locator.dart';

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

class OfflineEngineApp extends StatelessWidget {
  const OfflineEngineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Engine',
      debugShowCheckedModeBanner: true,
      navigatorKey: navigatorKey,
      home: SpalshPage(),
    );
  }
}
