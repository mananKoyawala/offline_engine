import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_engine/core/constants.dart';
import 'package:offline_engine/core/global_getters.dart';
import 'package:offline_engine/core/theme/colors.dart';
import 'package:offline_engine/core/theme/theme_provider.dart';

class TaskCompleteSoundPage extends ConsumerStatefulWidget {
  const TaskCompleteSoundPage({super.key});

  @override
  ConsumerState<TaskCompleteSoundPage> createState() =>
      _TaskCompleteSoundPageState();
}

class _TaskCompleteSoundPageState extends ConsumerState<TaskCompleteSoundPage> {
  late String _currentSound;

  @override
  void initState() {
    super.initState();
    _currentSound = prefsInstance.getTaskCompleteSound();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF111111);
    final subtitleColor = isDarkMode
        ? const Color(0xFFB0B0BA)
        : const Color(0xFF8A8A96);
    final borderColor = isDarkMode
        ? const Color(0xFF2C2C34)
        : const Color(0xFFEEEEF2);
    final cardColor = isDarkMode ? const Color(0xFF1C1C22) : const Color(0xFFF7F7FA);

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
                  _buildIntroCard(
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    cardColor: cardColor,
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 18),
                  ...AppAudio.taskCompleteSounds.map(
                    (option) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AudioOptionTile(
                        option: option,
                        isSelected: option.assetPath == _currentSound,
                        isDarkMode: isDarkMode,
                        titleColor: titleColor,
                        subtitleColor: subtitleColor,
                        cardColor: cardColor,
                        borderColor: borderColor,
                        onTap: () async {
                          await prefsInstance.setTaskCompleteSound(
                            option.assetPath,
                          );
                          if (!mounted) return;
                          setState(() {
                            _currentSound = option.assetPath;
                          });
                          HapticFeedback.selectionClick();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                    ? const Color(0xFF2B2B2F)
                    : const Color(0xFFF0F0F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: isDarkMode
                    ? const Color(0xFFB0B0BA)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task Complete Sound',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                Text(
                  'Choose the audio that plays when a task is completed',
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

  Widget _buildIntroCard({
    required Color titleColor,
    required Color subtitleColor,
    required Color cardColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: appColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.graphic_eq_rounded, color: appColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Audio list',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap any sound below to save it as your task complete sound.',
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                    height: 1.45,
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

class _AudioOptionTile extends StatelessWidget {
  final AppAudioOption option;
  final bool isSelected;
  final bool isDarkMode;
  final Color titleColor;
  final Color subtitleColor;
  final Color cardColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _AudioOptionTile({
    required this.option,
    required this.isSelected,
    required this.isDarkMode,
    required this.titleColor,
    required this.subtitleColor,
    required this.cardColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? appColor : borderColor,
              width: isSelected ? 1.4 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: appColor.withValues(alpha: 0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected
                      ? appColor.withValues(alpha: 0.12)
                      : (isDarkMode
                            ? const Color(0xFF2B2B2F)
                            : const Color(0xFFF0F0F5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? Icons.volume_up_rounded : Icons.music_note_rounded,
                  color: isSelected
                      ? appColor
                      : (isDarkMode
                            ? const Color(0xFFB0B0BA)
                            : const Color(0xFF6B7280)),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isSelected ? 'Currently selected' : 'Tap to select this sound',
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? appColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? appColor
                        : (isDarkMode
                              ? const Color(0xFF4C4C56)
                              : const Color(0xFFCCCCD6)),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
