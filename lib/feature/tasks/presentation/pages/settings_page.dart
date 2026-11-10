import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:todus/core/constants.dart';
import 'package:todus/core/global_getters.dart';
import 'package:todus/core/theme/colors.dart';
import 'package:todus/core/theme/theme_provider.dart';
import 'package:todus/feature/account/presentation/provider/delete_account_provider.dart';
import 'package:todus/feature/login/presentation/pages/login_page.dart';
import 'package:todus/feature/tasks/presentation/pages/task_complete_sound_page.dart';
import 'package:todus/shared/widgets/app_loader.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final currentSound = prefsInstance.getTaskCompleteSound();

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final titleColor = isDarkMode ? Colors.white : AppColors.color111111;
    final subtitleColor = isDarkMode
        ? AppColors.colorB0B0BA
        : AppColors.color8A8A96;
    final borderColor = isDarkMode
        ? AppColors.color2C2C34
        : AppColors.colorEEEEF2;
    final cardColor = isDarkMode
        ? AppColors.color1C1C22
        : AppColors.colorF7F7FA;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(
              context: context,
              isDarkMode: isDarkMode,
              titleColor: titleColor,
              subtitleColor: subtitleColor,
              borderColor: borderColor,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
                children: [
                  _SettingsRow(
                    label: 'Task complete sound',
                    value: _selectedSoundLabel(currentSound),
                    cardColor: cardColor,
                    borderColor: borderColor,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TaskCompleteSoundPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _TermsRow(
                    isDarkMode: isDarkMode,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    onTap: () {
                      launchUrl(
                        Uri.parse('https://todusapp.netlify.app/#privacy'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _DeleteAccountRow(
                    isDarkMode: isDarkMode,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    onTap: () => _handleDeleteAccount(context),
                  ),
                  const SizedBox(height: 12),
                  _LogoutRow(
                    isDarkMode: isDarkMode,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    onTap: () => _handleLogout(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _AppVersionFooter(
                isDarkMode: isDarkMode,
                subtitleColor: subtitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _selectedSoundLabel(String assetPath) {
    final selected = AppAudio.taskCompleteSounds.firstWhere(
      (option) => option.assetPath == assetPath,
      orElse: () => AppAudio.taskCompleteSounds.first,
    );
    return selected.label;
  }

  Future<void> _handleDeleteAccount(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _DeleteAccountSheet(
        isDarkMode: isDark,
        onConfirm: (reason) async => _submitDeletionRequest(context, reason),
      ),
    );
  }

  Future<void> _submitDeletionRequest(
    BuildContext context,
    String reason,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.color1C1C22 : Colors.white;
    final titleColor = isDark ? Colors.white : AppColors.color111111;
    final bodyColor = isDark
        ? AppColors.colorB0B0BA
        : AppColors.color8A8A96;

    final notifier = ref.read(deleteAccountProvider.notifier);

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppColors.color2C2C34 : AppColors.colorEEEEF2,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.colorE53935.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.colorE53935,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Delete account?',
                style: TextStyle(
                  color: titleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your deletion request will be reviewed by an admin and may take up to 30 days. You will not be able to log in until a decision is made.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: bodyColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark
                                ? AppColors.color3C3C44
                                : AppColors.colorE5E7EB,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: titleColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.colorE53935,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    // Close the bottom sheet
    Navigator.of(context).pop();

    if (!context.mounted) return;

    // Show full-screen loader
    AppLoader.show(context);

    final message = await notifier.requestDeletion(reason: reason);

    AppLoader.hide();

    if (!context.mounted) return;

    if (message != null) {
      syncManagerInstance.reset();
      await appDatabaseInstance.clearAllData();
      await prefsInstance.clearAuthSession();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bgColor = isDark ? AppColors.color1C1C22 : Colors.white;
        final titleColor = isDark ? Colors.white : AppColors.color111111;
        final bodyColor = isDark
            ? AppColors.colorB0B0BA
            : AppColors.color8A8A96;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? AppColors.color2C2C34
                    : AppColors.colorEEEEF2,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.colorE53935.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.colorE53935,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Log out?',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You will be signed out and returned to the login screen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: bodyColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: bodyColor,
                            side: BorderSide(
                              color: isDark
                                  ? AppColors.color3C3C44
                                  : AppColors.colorE5E7EB,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: titleColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorE53935,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Log out',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      syncManagerInstance.reset();
      await appDatabaseInstance.clearAllData();
      await prefsInstance.clearAuthSession();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  Widget _buildHeader({
    required BuildContext context,
    required bool isDarkMode,
    required Color titleColor,
    required Color subtitleColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.color2B2B2F
                    : AppColors.colorF0F0F5,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: isDarkMode
                    ? AppColors.colorB0B0BA
                    : AppColors.color6B7280,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                Text(
                  'Choose the sound for completed tasks',
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteAccountRow extends StatelessWidget {
  final bool isDarkMode;
  final Color cardColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _DeleteAccountRow({
    required this.isDarkMode,
    required this.cardColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const deleteRed = AppColors.colorE53935;
    final iconBg = deleteRed.withValues(alpha: 0.12);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: deleteRed,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Request account deletion',
                  style: TextStyle(
                    color: deleteRed,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteAccountSheet extends StatefulWidget {
  final bool isDarkMode;
  final Future<void> Function(String reason) onConfirm;

  const _DeleteAccountSheet({
    required this.isDarkMode,
    required this.onConfirm,
  });

  @override
  State<_DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<_DeleteAccountSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final reason = _controller.text.trim();
    await widget.onConfirm(reason);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgColor = isDark ? AppColors.color1C1C22 : Colors.white;
    final titleColor = isDark ? Colors.white : AppColors.color111111;
    final bodyColor = isDark
        ? AppColors.colorB0B0BA
        : AppColors.color8A8A96;
    final borderColor = isDark
        ? AppColors.color2C2C34
        : AppColors.colorEEEEF2;
    final fieldFill = isDark
        ? AppColors.color2B2B2F
        : AppColors.colorF7F7FA;
    final fieldBorder = isDark
        ? AppColors.color404049
        : AppColors.colorE5E7EB;
    const deleteRed = AppColors.colorE53935;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: borderColor, width: 1)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Request account deletion',
                style: TextStyle(
                  color: titleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tell us why you want to delete your account.',
                style: TextStyle(
                  color: bodyColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: _controller,
                builder: (_, value, __) {
                  final charCount = value.text.trim().length;
                  return TextFormField(
                    controller: _controller,
                    maxLength: 200,
                    maxLines: 4,
                    minLines: 3,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your reason…',
                      hintStyle: TextStyle(color: bodyColor),
                      filled: true,
                      fillColor: fieldFill,
                      counterText: '$charCount/200',
                      counterStyle: TextStyle(
                        color: charCount > 200 ? deleteRed : bodyColor,
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: fieldBorder, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: fieldBorder, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: deleteRed,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: deleteRed,
                          width: 1.2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      final trimmed = value?.trim() ?? '';
                      if (trimmed.isEmpty) return 'Reason is required';
                      if (trimmed.length < 10) {
                        return 'Reason must be at least 10 characters';
                      }
                      if (trimmed.length > 200) {
                        return 'Reason must be at most 200 characters';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deleteRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final String value;
  final Color cardColor;
  final Color borderColor;
  final Color titleColor;
  final Color subtitleColor;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.label,
    required this.value,
    required this.cardColor,
    required this.borderColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.graphic_eq_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.chevron_right_rounded,
                color: isDarkMode
                    ? AppColors.colorB0B0BA
                    : AppColors.color6B7280,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutRow extends StatelessWidget {
  final bool isDarkMode;
  final Color cardColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _LogoutRow({
    required this.isDarkMode,
    required this.cardColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const logoutRed = AppColors.colorE53935;
    final iconBg = logoutRed.withValues(alpha: 0.12);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: logoutRed,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Log out',
                  style: TextStyle(
                    color: logoutRed,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsRow extends StatelessWidget {
  final bool isDarkMode;
  final Color cardColor;
  final Color borderColor;
  final Color titleColor;
  final Color subtitleColor;
  final VoidCallback onTap;

  const _TermsRow({
    required this.isDarkMode,
    required this.cardColor,
    required this.borderColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.gavel_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Read our terms of service',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.chevron_right_rounded,
                color: isDarkMode
                    ? AppColors.colorB0B0BA
                    : AppColors.color6B7280,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppVersionFooter extends StatelessWidget {
  final bool isDarkMode;
  final Color subtitleColor;

  const _AppVersionFooter({
    required this.isDarkMode,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final versionText = snapshot.hasData
              ? 'v${snapshot.data!.version}'
              : 'Loading version...';

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.color1C1C22
                  : AppColors.colorF7F7FA,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isDarkMode
                    ? AppColors.color2C2C34
                    : AppColors.colorEEEEF2,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  size: 14,
                  color: AppColors.primary.withValues(alpha: 0.85),
                ),
                const SizedBox(width: 6),
                Text(
                  versionText,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
