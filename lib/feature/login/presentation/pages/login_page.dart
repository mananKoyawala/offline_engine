import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_engine/core/global_getters.dart';
import 'package:offline_engine/feature/login/presentation/provider/login_provider.dart';
import 'package:offline_engine/feature/login/presentation/provider/state/login_state.dart';
import 'package:offline_engine/feature/tasks/presentation/pages/task_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  Future<void> _handleLogin() async {
    final success = await ref.read(loginProvider.notifier).login();

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const TaskPage()),
        (route) => false,
      );
      syncManagerInstance.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3A8A), Color(0xFF6D28D9)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 48),
                  _buildLoginButton(state),
                  const SizedBox(height: 24),
                  if (state.hasError) _buildErrorSection(state),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.lock_outline_rounded,
        color: Colors.white,
        size: 44,
      ),
    );
  }

  Widget _buildLoginButton(LoginState state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: state.isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1E3A8A),
          elevation: 6,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: state.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(Color(0xFF1E3A8A)),
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildErrorSection(LoginState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            state.errorMessage ?? 'Login failed. Please try again.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            state.canRetry
                ? 'You can retry now'
                : 'Please wait ${state.retryCountDown} s before retrying',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: state.canRetry ? _handleLogin : null,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white38,
                side: BorderSide(
                  color: state.canRetry ? Colors.white : Colors.white24,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
