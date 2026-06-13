import 'package:flutter/material.dart';

void main() {
  runApp(const OfflineEngineApp());
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.green);
  }
}
