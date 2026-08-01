import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_engine/feature/tasks/domain/enitites/task_entity.dart';
import 'package:offline_engine/feature/tasks/domain/params/update_task_params.dart';
import 'package:offline_engine/feature/tasks/presentation/pages/sync_operations_page.dart';
import 'package:offline_engine/feature/tasks/presentation/pages/widgets/task_card.dart';
import 'package:offline_engine/feature/tasks/presentation/pages/widgets/task_form_sheet.dart';
import 'package:offline_engine/feature/tasks/presentation/provider/task_provider.dart';
import 'package:offline_engine/feature/tasks/presentation/provider/state/task_state.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  void _openCreateForm() {
    // syncManagerInstance.startSync();
    // return;
    showTaskFormSheet(
      context,
      onSubmit: (result) {
        if (result.createParams != null) {
          ref.read(taskProvider.notifier).createTask(result.createParams!);
        }
      },
    );
  }

  void _openEditForm(TaskEntity task) {
    showTaskFormSheet(
      context,
      existingTask: task,
      onSubmit: (result) {
        if (result.updateParams != null) {
          ref.read(taskProvider.notifier).updateTask(result.updateParams!);
        }
      },
    );
  }

  void _deleteTask(TaskEntity task) {
    ref
        .read(taskProvider.notifier)
        .deleteTask(
          UpdateTaskParams(
            id: task.id,
            title: task.title,
            description: task.description,
            priority: task.priority,
            isCompleted: task.isCompleted,
          ),
        );
  }

  void _toggleComplete(TaskEntity task, bool isDone) {
    ref
        .read(taskProvider.notifier)
        .updateTask(
          UpdateTaskParams(
            id: task.id,
            title: task.title,
            description: task.description,
            priority: task.priority,
            isCompleted: isDone,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SyncOperationsPage()),
              );
            },
            icon: Icon(Icons.info),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(taskProvider.notifier).refresh(),
        child: _buildBody(state, theme),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateForm,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  Widget _buildBody(TaskState state, ThemeData theme) {
    if (state.isLoading && state.tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.tasks.isEmpty) {
      return _buildMessage(
        icon: Icons.error_outline,
        title: 'Something went wrong',
        subtitle: state.errorMessage!,
        theme: theme,
      );
    }

    if (state.tasks.isEmpty) {
      return _buildMessage(
        icon: Icons.checklist_rtl,
        title: 'No tasks yet',
        subtitle: 'Tap "New Task" to create your first one.',
        theme: theme,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: state.tasks.length,
      itemBuilder: (context, index) {
        final task = state.tasks[index];
        return TaskCard(
          task: task,
          onTap: () => _openEditForm(task),
          onDeleteConfirmed: () => _deleteTask(task),
          onToggleComplete: (isDone) => _toggleComplete(task, isDone),
        );
      },
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeData theme,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 56,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
