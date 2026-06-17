import 'package:flutter/material.dart';
import 'package:offline_engine/feature/domain/enitites/task_entity.dart';
import 'package:offline_engine/feature/domain/params/create_task_params.dart';
import 'package:offline_engine/feature/domain/params/update_task_params.dart';
import 'package:offline_engine/feature/presentation/enums/task_priority.dart';

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
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.of(context).padding.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Text(
              isEditing ? 'Edit Task' : 'New Task',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              autofocus: !isEditing,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text('Priority', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<TaskPriority>(
              segments: const [
                ButtonSegment(
                  value: TaskPriority.low,
                  label: Text('Low'),
                  icon: Icon(Icons.south, size: 16),
                ),
                ButtonSegment(
                  value: TaskPriority.medium,
                  label: Text('Medium'),
                  icon: Icon(Icons.remove, size: 16),
                ),
                ButtonSegment(
                  value: TaskPriority.high,
                  label: Text('High'),
                  icon: Icon(Icons.north, size: 16),
                ),
              ],
              selected: {_priority},
              onSelectionChanged: (selection) {
                setState(() => _priority = selection.first);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(isEditing ? 'Save Changes' : 'Create Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
