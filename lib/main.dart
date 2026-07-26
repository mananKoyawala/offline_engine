import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_engine/feature/presentation/pages/task_page.dart';
import 'package:offline_engine/locator/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  runApp(ProviderScope(child: const OfflineEngineApp()));
}

class OfflineEngineApp extends StatelessWidget {
  const OfflineEngineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Engine',
      debugShowCheckedModeBanner: true,
      home: TaskPage(),
    );
  }
}
