import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_engine/feature/presentation/provider/task_provider.dart';
import 'package:offline_engine/locator/locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(ProviderScope(child: const OfflineEngineApp()));
}

class OfflineEngineApp extends StatelessWidget {
  const OfflineEngineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Engine',
      debugShowCheckedModeBanner: true,
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(taskProvider.notifier);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: notifier.callTheflow,
              child: Text("Click me"),
            ),
          ],
        ),
      ),
    );
  }
}
