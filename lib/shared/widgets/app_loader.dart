import 'package:flutter/material.dart';
import 'package:todus/core/theme/colors.dart';

/// A full-screen translucent overlay with a centered spinner.
/// Use [AppLoader.show] and [AppLoader.hide] to manage it.
class AppLoader {
  static OverlayEntry? _entry;

  static void show(BuildContext context) {
    if (_entry != null) return;
    _entry = OverlayEntry(builder: (_) => const _AppLoaderOverlay());
    Overlay.of(context).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class _AppLoaderOverlay extends StatelessWidget {
  const _AppLoaderOverlay();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withValues(alpha: 0.45),
        child: const Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}
