import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todus/core/constants.dart';
import 'package:todus/core/theme/colors.dart';
import 'package:todus/core/theme/theme_provider.dart';
import 'package:todus/feature/register/presentation/pages/otp_page.dart';
import 'package:todus/feature/register/presentation/provider/register_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Hide passwords when submit is attempted
    if (!_obscurePassword || !_obscureConfirmPassword) {
      setState(() {
        _obscurePassword = true;
        _obscureConfirmPassword = true;
      });
    }

    final email = _emailController.text.trim();
    final message = await ref
        .read(registerProvider.notifier)
        .register(
          fullName: _fullNameController.text.trim(),
          email: email,
          password: _passwordController.text,
        );

    if (!mounted) return;

    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => OtpPage(email: email)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final fieldFillColor = isDarkMode
        ? const Color(0xFF2B2B2F)
        : const Color(0xFFF7F7FA);
    final fieldBorderColor = isDarkMode
        ? const Color(0xFF404049)
        : const Color(0xFFE5E7EB);
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF111111);
    final bodyColor = isDarkMode
        ? const Color(0xFFB0B0BA)
        : const Color(0xFF8A8A96);
    final labelColor = isDarkMode
        ? const Color(0xFFB8B8C2)
        : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBranding(isDarkMode),
                    const SizedBox(height: 26),
                    Text(
                      'Create account',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 33,
                        height: 1.05,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sign up to start syncing your workspace',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: bodyColor,
                        fontSize: 16,
                        height: 1.2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Full Name
                    Text(
                      'Full Name',
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildField(
                      hintText: 'Enter Full Name',
                      controller: _fullNameController,
                      isDarkMode: isDarkMode,
                      borderColor: fieldBorderColor,
                      filledColor: fieldFillColor,
                      textColor: titleColor,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        final trimmed = value?.trim() ?? '';
                        if (trimmed.isEmpty) {
                          return 'Full name is required';
                        }
                        if (trimmed.length < 2) {
                          return 'Full name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email
                    Text(
                      'Email',
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildField(
                      hintText: 'Enter Email',
                      controller: _emailController,
                      isDarkMode: isDarkMode,
                      borderColor: fieldBorderColor,
                      filledColor: fieldFillColor,
                      textColor: titleColor,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        final trimmed = value?.trim() ?? '';
                        if (trimmed.isEmpty) {
                          return 'Email is required';
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(trimmed)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password
                    Text(
                      'Password',
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildField(
                      hintText: 'Enter Password',
                      controller: _passwordController,
                      isDarkMode: isDarkMode,
                      borderColor: fieldBorderColor,
                      filledColor: fieldFillColor,
                      textColor: titleColor,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        color: appColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildField(
                      hintText: 'Re-enter Password',
                      controller: _confirmPasswordController,
                      isDarkMode: isDarkMode,
                      borderColor: fieldBorderColor,
                      filledColor: fieldFillColor,
                      textColor: titleColor,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        color: appColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // Register button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: appColor.withValues(
                            alpha: 0.65,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Already have an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: bodyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: appColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranding(bool isDarkMode) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            isDarkMode ? AppLogo.dark : AppLogo.light,
            width: 66,
            height: 66,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Todus',
          style: TextStyle(
            color: isDarkMode ? Colors.white : const Color(0xFF111111),
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sync anywhere. Instantly.',
          style: TextStyle(
            color: isDarkMode
                ? const Color(0xFF9A9AA6)
                : const Color(0xFF9B9BA6),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required bool isDarkMode,
    required Color borderColor,
    required Color filledColor,
    required Color textColor,
    String? hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: filledColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: appColor, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5484D), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5484D), width: 1.2),
        ),
        errorStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
