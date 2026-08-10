import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_engine/core/global_getters.dart';
import 'package:offline_engine/core/theme/colors.dart';
import 'package:offline_engine/core/theme/theme_provider.dart';
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
    final isDarkMode = ref.watch(themeProvider).isDarkMode;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final surfaceColor = isDarkMode
        ? const Color(0xFF1A1A1F)
        : const Color(0xFFF7F7FA);
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF111111);
    final subtitleColor = isDarkMode
        ? const Color(0xFFB0B0BA)
        : const Color(0xFF8A8A96);
    final borderColor = isDarkMode
        ? const Color(0xFF2C2C34)
        : const Color(0xFFEEEEF2);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              isDarkMode: isDarkMode,
              titleColor: titleColor,
              subtitleColor: subtitleColor,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
            ),
            Expanded(
              child: RefreshIndicator(
                color: appColor,
                onRefresh: () => ref.read(taskProvider.notifier).refresh(),
                child: _buildBody(
                  state: state,
                  isDarkMode: isDarkMode,
                  titleColor: titleColor,
                  subtitleColor: subtitleColor,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(isDarkMode),
    );
  }

  Widget _buildHeader({
    required bool isDarkMode,
    required Color titleColor,
    required Color subtitleColor,
    required Color surfaceColor,
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
          // Branding logo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: appColor,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Text(
              'OE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Tasks',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                Text(
                  'Offline Engine',
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          _buildIconButton(
            icon: Icons.sync_rounded,
            isDarkMode: isDarkMode,
            onTap: () => syncManagerInstance.startSyncAll(),
          ),
          const SizedBox(width: 6),
          _buildIconButton(
            icon: Icons.info_outline_rounded,
            isDarkMode: isDarkMode,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SyncOperationsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
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
            icon,
            size: 20,
            color: isDarkMode
                ? const Color(0xFFB0B0BA)
                : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appColor.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: _openCreateForm,
        backgroundColor: appColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text(
          'New Task',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildBody({
    required TaskState state,
    required bool isDarkMode,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    if (state.isLoading && state.tasks.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: appColor, strokeWidth: 2.4),
      );
    }

    if (state.errorMessage != null && state.tasks.isEmpty) {
      return _buildMessage(
        icon: Icons.error_outline_rounded,
        title: 'Something went wrong',
        subtitle: state.errorMessage!,
        isDarkMode: isDarkMode,
        titleColor: titleColor,
        subtitleColor: subtitleColor,
        iconColor: Colors.redAccent,
      );
    }

    if (state.tasks.isEmpty) {
      return _buildMessage(
        icon: Icons.checklist_rtl_rounded,
        title: 'No tasks yet',
        subtitle: 'Tap "New Task" to create your first one.',
        isDarkMode: isDarkMode,
        titleColor: titleColor,
        subtitleColor: subtitleColor,
        iconColor: appColor.withValues(alpha: 0.35),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
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
    required bool isDarkMode,
    required Color titleColor,
    required Color subtitleColor,
    required Color iconColor,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF2B2B2F)
                    : const Color(0xFFF0F0F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 36, color: iconColor),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
