import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offline_engine/core/theme/colors.dart';
import 'package:offline_engine/feature/tasks/domain/enitites/task_entity.dart';
import 'package:offline_engine/feature/tasks/presentation/enums/task_priority.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onTap;
  final VoidCallback onDeleteConfirmed;
  final ValueChanged<bool> onToggleComplete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDeleteConfirmed,
    required this.onToggleComplete,
  });

  Color get _priorityColor {
    switch (task.priority) {
      case TaskPriority.high:
        return const Color(0xFFE5484D);
      case TaskPriority.medium:
        return const Color(0xFFF5A623);
      case TaskPriority.low:
        return const Color(0xFF30A46C);
    }
  }

  String get _priorityLabel {
    switch (task.priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  IconData get _priorityIcon {
    switch (task.priority) {
      case TaskPriority.high:
        return Icons.keyboard_double_arrow_up_rounded;
      case TaskPriority.medium:
        return Icons.drag_handle_rounded;
      case TaskPriority.low:
        return Icons.keyboard_double_arrow_down_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDone = task.isCompleted;

    final cardColor = isDark ? const Color(0xFF1C1C22) : Colors.white;
    final borderColor = isDark
        ? (isDone
              ? const Color(0xFF2C2C34)
              : _priorityColor.withValues(alpha: 0.25))
        : (isDone ? const Color(0xFFEEEEF2) : _priorityColor.withValues(alpha: 0.2));
    final titleColor = isDark ? Colors.white : const Color(0xFF111111);
    final subtitleColor =
        isDark ? const Color(0xFFB0B0BA) : const Color(0xFF8A8A96);

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDeleteConfirmed(),
      background: const SizedBox.shrink(),
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: const Color(0xFFE5484D),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: _priorityColor.withValues(alpha: isDone ? 0.0 : 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Priority accent bar
                  Container(
                    width: 3,
                    height: task.description.isNotEmpty ? 64 : 40,
                    margin: const EdgeInsets.only(right: 14, top: 2),
                    decoration: BoxDecoration(
                      color: isDone
                          ? (isDark
                                ? const Color(0xFF3C3C44)
                                : const Color(0xFFDDDDE8))
                          : _priorityColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  color: isDone
                                      ? subtitleColor
                                      : titleColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationColor: subtitleColor,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Priority pill
                            if (!isDone)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _priorityColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _priorityIcon,
                                      size: 11,
                                      color: _priorityColor,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      _priorityLabel,
                                      style: TextStyle(
                                        color: _priorityColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Checkbox
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onToggleComplete(!isDone);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? appColor : Colors.transparent,
                        border: Border.all(
                          color: isDone
                              ? appColor
                              : (isDark
                                    ? const Color(0xFF4C4C56)
                                    : const Color(0xFFCCCCD6)),
                          width: 2,
                        ),
                      ),
                      child: isDone
                          ? const Icon(
                              Icons.check_rounded,
                              size: 15,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('"${task.title}" will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
