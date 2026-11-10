import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todus/core/constants.dart';
import 'package:todus/core/global_getters.dart';
import 'package:todus/core/theme/colors.dart';
import 'package:todus/core/theme/theme_provider.dart';
import 'package:todus/feature/login/presentation/pages/login_page.dart';
import 'package:todus/feature/tasks/presentation/pages/task_page.dart';

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
    if (!mounted) return;
    _navigateUser();
  }

  void _navigateUser() async {
    final nextPage = prefsInstance.hasAuthSession
        ? const TaskPage()
        : const LoginPage();

    if (prefsInstance.hasAuthSession) {
      await syncManagerInstance.initialize();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.read(themeProvider).isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                isDarkMode ? AppLogo.dark : AppLogo.splash,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Todus',
              style: TextStyle(
                color: isDarkMode ? AppColors.primary : Colors.white,
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
