import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_engine/core/theme/colors.dart';
import 'package:offline_engine/core/theme/theme_provider.dart';
import 'package:offline_engine/feature/login/presentation/pages/login_page.dart';

class SpalshPage extends ConsumerStatefulWidget {
  const SpalshPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SpalshPageState();
}

class _SpalshPageState extends ConsumerState<SpalshPage> {
  @override
  void initState() {
    super.initState();

    _loadNextPage();
  }

  void _loadNextPage() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    _navigateUser();
  }

  void _navigateUser() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.read(themeProvider).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : appColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDarkMode ? appColor : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'OE',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : appColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Offline Engine',
              style: TextStyle(
                color: isDarkMode ? appColor : Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Sync anywhere. Instantly.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
