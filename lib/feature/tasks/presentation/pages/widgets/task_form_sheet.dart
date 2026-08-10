import 'package:flutter/material.dart';
import 'package:offline_engine/core/theme/colors.dart';
import 'package:offline_engine/feature/tasks/domain/enitites/task_entity.dart';
import 'package:offline_engine/feature/tasks/domain/params/create_task_params.dart';
import 'package:offline_engine/feature/tasks/domain/params/update_task_params.dart';
import 'package:offline_engine/feature/tasks/presentation/enums/task_priority.dart';

/// Result returned by the form: either a CreateTaskParams (new task)
/// or an UpdateTaskParams (editing an existing task).
class TaskFormResult {
  final CreateTaskParams? createParams;
  final UpdateTaskParams? updateParams;

  TaskFormResult.create(this.createParams) : updateParams = null;
  TaskFormResult.update(this.updateParams) : createParams = null;
}

Future<void> showTaskFormSheet(
  BuildContext context, {
  TaskEntity? existingTask,
  required void Function(TaskFormResult result) onSubmit,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _TaskFormSheet(existingTask: existingTask, onSubmit: onSubmit),
      );
    },
  );
}

class _TaskFormSheet extends StatefulWidget {
  final TaskEntity? existingTask;
  final void Function(TaskFormResult result) onSubmit;

  const _TaskFormSheet({this.existingTask, required this.onSubmit});

  @override
  State<_TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<_TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late TaskPriority _priority;

  bool get isEditing => widget.existingTask != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingTask?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.existingTask?.description ?? '',
    );
    _priority = widget.existingTask?.priority ?? TaskPriority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descController.text.trim();

    if (isEditing) {
      widget.onSubmit(
        TaskFormResult.update(
          UpdateTaskParams(
            id: widget.existingTask!.id,
            title: title,
            description: description,
            priority: _priority,
            isCompleted: false,
          ),
        ),
      );
    } else {
      widget.onSubmit(
        TaskFormResult.create(
          CreateTaskParams(
            title: title,
            description: description,
            priority: _priority,
          ),
        ),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sheetColor = isDark ? const Color(0xFF16161A) : Colors.white;
    final fieldFill =
        isDark ? const Color(0xFF2B2B2F) : const Color(0xFFF7F7FA);
    final fieldBorder =
        isDark ? const Color(0xFF3C3C44) : const Color(0xFFE5E7EB);
    final titleColor = isDark ? Colors.white : const Color(0xFF111111);
    final labelColor =
        isDark ? const Color(0xFFB8B8C2) : const Color(0xFF6B7280);

    return Container(
      decoration: BoxDecoration(
        color: sheetColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.of(context).padding.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3C3C44)
                      : const Color(0xFFDDDDE6),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            // Header row
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: appColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isEditing ? Icons.edit_rounded : Icons.add_rounded,
                    color: appColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? 'Edit Task' : 'New Task',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      isEditing
                          ? 'Update your task details'
                          : 'What do you need to get done?',
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Title field label
            Text(
              'Title',
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              autofocus: !isEditing,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                color: titleColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Review design mockups',
                hintStyle: TextStyle(
                  color: labelColor.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: fieldFill,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: fieldBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: fieldBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: appColor, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5484D),
                    width: 1.2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5484D),
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description label
            Text(
              'Description',
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                color: titleColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Add more details (optional)',
                hintStyle: TextStyle(
                  color: labelColor.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: fieldFill,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: fieldBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: fieldBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: appColor, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Priority label
            Text(
              'Priority',
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 10),
            _buildPrioritySelector(isDark, titleColor),

            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  isEditing ? 'Save Changes' : 'Create Task',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector(bool isDark, Color titleColor) {
    final options = [
      (
        priority: TaskPriority.low,
        label: 'Low',
        icon: Icons.keyboard_double_arrow_down_rounded,
        color: const Color(0xFF30A46C),
      ),
      (
        priority: TaskPriority.medium,
        label: 'Medium',
        icon: Icons.drag_handle_rounded,
        color: const Color(0xFFF5A623),
      ),
      (
        priority: TaskPriority.high,
        label: 'High',
        icon: Icons.keyboard_double_arrow_up_rounded,
        color: const Color(0xFFE5484D),
      ),
    ];

    return Row(
      children: options.map((opt) {
        final isSelected = _priority == opt.priority;
        final color = opt.color;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _priority = opt.priority),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.only(
                right: opt.priority != TaskPriority.high ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.12)
                    : (isDark
                          ? const Color(0xFF2B2B2F)
                          : const Color(0xFFF7F7FA)),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? color.withValues(alpha: 0.5)
                      : (isDark
                            ? const Color(0xFF3C3C44)
                            : const Color(0xFFE5E7EB)),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    opt.icon,
                    size: 20,
                    color: isSelected
                        ? color
                        : (isDark
                              ? const Color(0xFF6C6C78)
                              : const Color(0xFFAAAAAA)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    opt.label,
                    style: TextStyle(
                      color: isSelected
                          ? color
                          : (isDark
                                ? const Color(0xFF8A8A96)
                                : const Color(0xFF9B9BA6)),
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
