import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_engine/core/theme/colors.dart';
import 'package:offline_engine/core/theme/theme_provider.dart';
import 'package:offline_engine/feature/tasks/data/models/sync_operation_item.dart';
import 'package:offline_engine/feature/tasks/presentation/enums/sync_operations.dart';
import 'package:offline_engine/feature/tasks/presentation/provider/sync_operation_provider.dart';
import 'package:offline_engine/feature/tasks/presentation/provider/task_provider.dart';

class SyncOperationsPage extends ConsumerWidget {
  const SyncOperationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final syncOperations = ref.watch(syncOperationsProvider);

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
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
          children: [
            _buildHeader(
              context: context,
              ref: ref,
              isDarkMode: isDarkMode,
              titleColor: titleColor,
              subtitleColor: subtitleColor,
              borderColor: borderColor,
            ),
            Expanded(
              child: syncOperations.when(
                data: (streamData) => streamData.fold(
                  (failure) => _buildError(
                    failure.message,
                    isDarkMode,
                    titleColor,
                    subtitleColor,
                  ),
                  (data) => _buildDashboard(
                    context: context,
                    ref: ref,
                    data: data,
                    isDarkMode: isDarkMode,
                    titleColor: titleColor,
                    subtitleColor: subtitleColor,
                    borderColor: borderColor,
                  ),
                ),
                error: (e, _) => _buildError(
                  'Something went wrong',
                  isDarkMode,
                  titleColor,
                  subtitleColor,
                ),
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: appColor,
                    strokeWidth: 2.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader({
    required BuildContext context,
    required WidgetRef ref,
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
                  'Sync Dashboard',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                Text(
                  'Live operation metrics',
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          _buildIconBtn(
            icon: Icons.schedule_rounded,
            isDarkMode: isDarkMode,
            onTap: () => ref.read(taskProvider.notifier).initScheduler(),
            tooltip: 'Schedule Tasks',
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn({
    required IconData icon,
    required bool isDarkMode,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    final btn = Material(
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
    return tooltip != null ? Tooltip(message: tooltip, child: btn) : btn;
  }

  // ── Main dashboard ────────────────────────────────────────────────────────

  Widget _buildDashboard({
    required BuildContext context,
    required WidgetRef ref,
    required List<SyncOperationItem> data,
    required bool isDarkMode,
    required Color titleColor,
    required Color subtitleColor,
    required Color borderColor,
  }) {
    // Derive counts from the stream data for statuses without dedicated providers
    final versionResolvedCount = data
        .where((o) => o.status == SyncStatus.versionResolved)
        .length;
    final alreadyDeletedCount = data
        .where((o) => o.status == SyncStatus.alreadyDeleted)
        .length;
    final deleteResolvedCount = data
        .where((o) => o.status == SyncStatus.deleteResolved)
        .length;
    final duplicateCreateCount = data
        .where((o) => o.status == SyncStatus.duplicateCreate)
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        // ── Operation Status ──────────────────────────────────────────────
        _buildSectionHeader(
          icon: Icons.analytics_rounded,
          label: 'Operation Status',
          isDarkMode: isDarkMode,
          titleColor: titleColor,
        ),
        const SizedBox(height: 12),
        _buildStatusGrid(
          ref: ref,
          isDarkMode: isDarkMode,
          versionResolvedCount: versionResolvedCount,
          alreadyDeletedCount: alreadyDeletedCount,
          deleteResolvedCount: deleteResolvedCount,
          duplicateCreateCount: duplicateCreateCount,
        ),

        const SizedBox(height: 24),

        // ── Operation Type ────────────────────────────────────────────────
        _buildSectionHeader(
          icon: Icons.category_rounded,
          label: 'Operation Type',
          isDarkMode: isDarkMode,
          titleColor: titleColor,
        ),
        const SizedBox(height: 12),
        _buildTypeRow(ref: ref, isDarkMode: isDarkMode),

        const SizedBox(height: 24),

        // ── Operations List ───────────────────────────────────────────────
        _buildSectionHeader(
          icon: Icons.receipt_long_rounded,
          label: 'Operations  •  ${data.length}',
          isDarkMode: isDarkMode,
          titleColor: titleColor,
        ),
        const SizedBox(height: 12),

        if (data.isEmpty)
          _buildEmptyList(isDarkMode: isDarkMode, subtitleColor: subtitleColor)
        else
          ...data.map(
            (op) => _buildOperationTile(
              op: op,
              isDarkMode: isDarkMode,
              titleColor: titleColor,
              subtitleColor: subtitleColor,
            ),
          ),
      ],
    );
  }

  // ── Section header ────────────────────────────────────────────────────────

  Widget _buildSectionHeader({
    required IconData icon,
    required String label,
    required bool isDarkMode,
    required Color titleColor,
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: appColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: appColor),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: titleColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ── Status grid ───────────────────────────────────────────────────────────

  Widget _buildStatusGrid({
    required WidgetRef ref,
    required bool isDarkMode,
    required int versionResolvedCount,
    required int alreadyDeletedCount,
    required int deleteResolvedCount,
    required int duplicateCreateCount,
  }) {
    final pendingCount = ref.watch(pendingCountProvider).value ?? 0;
    final mergedCount = ref.watch(mergedCountProvider).value ?? 0;
    final failedCount = ref.watch(failedCountProvider).value ?? 0;
    final successCount = ref.watch(successCountProvider).value ?? 0;
    final autoResolvedCount = ref.watch(autoResolvedCountProvider).value ?? 0;

    final items = [
      _StatItem(
        label: 'Pending',
        value: pendingCount,
        icon: Icons.hourglass_top_rounded,
        color: const Color(0xFFF5A623),
      ),
      _StatItem(
        label: 'Success',
        value: successCount,
        icon: Icons.check_circle_rounded,
        color: const Color(0xFF30A46C),
      ),
      _StatItem(
        label: 'Merged',
        value: mergedCount,
        icon: Icons.merge_rounded,
        color: appColor,
      ),
      _StatItem(
        label: 'Failed',
        value: failedCount,
        icon: Icons.error_rounded,
        color: const Color(0xFFE5484D),
      ),
      _StatItem(
        label: 'Auto Resolved',
        value: autoResolvedCount,
        icon: Icons.auto_fix_high_rounded,
        color: const Color(0xFF7C6FFF),
      ),
      _StatItem(
        label: 'Version Resolved',
        value: versionResolvedCount,
        icon: Icons.history_toggle_off_rounded,
        color: const Color(0xFF06B6D4),
      ),
      _StatItem(
        label: 'Already Deleted',
        value: alreadyDeletedCount,
        icon: Icons.delete_forever_rounded,
        color: const Color(0xFFFF6B6B),
      ),
      _StatItem(
        label: 'Delete Resolved',
        value: deleteResolvedCount,
        icon: Icons.delete_sweep_rounded,
        color: const Color(0xFFFF9F43),
      ),
      _StatItem(
        label: 'Duplicate Create',
        value: duplicateCreateCount,
        icon: Icons.content_copy_rounded,
        color: const Color(0xFF26C6DA),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _buildStatCard(items[i], isDarkMode),
    );
  }

  Widget _buildStatCard(_StatItem item, bool isDarkMode) {
    final cardColor = isDarkMode ? const Color(0xFF1C1C22) : Colors.white;
    final borderColor = isDarkMode
        ? item.color.withValues(alpha: 0.2)
        : item.color.withValues(alpha: 0.15);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: item.color.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(item.icon, size: 16, color: item.color),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.value}',
                  style: TextStyle(
                    color: item.color,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.label,
                  style: TextStyle(
                    color: isDarkMode
                        ? const Color(0xFF8A8A96)
                        : const Color(0xFF9B9BA6),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Type row ──────────────────────────────────────────────────────────────

  Widget _buildTypeRow({required WidgetRef ref, required bool isDarkMode}) {
    final createCount = ref.watch(createCountProvider).value ?? 0;
    final updateCount = ref.watch(updateCountProvider).value ?? 0;
    final deleteCount = ref.watch(deleteCountProvider).value ?? 0;

    final types = [
      _StatItem(
        label: 'Create',
        value: createCount,
        icon: Icons.add_circle_rounded,
        color: const Color(0xFF30A46C),
      ),
      _StatItem(
        label: 'Update',
        value: updateCount,
        icon: Icons.edit_rounded,
        color: const Color(0xFFF5A623),
      ),
      _StatItem(
        label: 'Delete',
        value: deleteCount,
        icon: Icons.delete_rounded,
        color: const Color(0xFFE5484D),
      ),
    ];

    return Row(
      children: types
          .map(
            (t) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: t == types.last ? 0 : 10),
                child: _buildTypeCard(t, isDarkMode),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTypeCard(_StatItem item, bool isDarkMode) {
    final cardColor = isDarkMode ? const Color(0xFF1C1C22) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? item.color.withValues(alpha: 0.2)
              : item.color.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: item.color.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, size: 18, color: item.color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.value}',
                style: TextStyle(
                  color: item.color,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              Text(
                item.label,
                style: TextStyle(
                  color: isDarkMode
                      ? const Color(0xFF8A8A96)
                      : const Color(0xFF9B9BA6),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Operation list tile ───────────────────────────────────────────────────

  Widget _buildOperationTile({
    required SyncOperationItem op,
    required bool isDarkMode,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    final statusColor = _statusColor(op.status);
    final typeColor = _typeColor(op.type);
    final cardColor = isDarkMode ? const Color(0xFF1C1C22) : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2C2C34) : const Color(0xFFEEEEF2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status dot
            Container(
              width: 3,
              height: 44,
              margin: const EdgeInsets.only(right: 12, top: 2),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Task: ${op.taskId.isNotEmpty ? op.taskId : '—'}',
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          op.type.type.toUpperCase(),
                          style: TextStyle(
                            color: typeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'ID: ${op.id}',
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.3),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _statusLabel(op.status),
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _buildEmptyList({
    required bool isDarkMode,
    required Color subtitleColor,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF2B2B2F)
                    : const Color(0xFFF0F0F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.sync_disabled_rounded,
                size: 32,
                color: appColor.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No operations yet',
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error state ───────────────────────────────────────────────────────────

  Widget _buildError(
    String message,
    bool isDarkMode,
    Color titleColor,
    Color subtitleColor,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF2B2B2F)
                    : const Color(0xFFF0F0F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: Color(0xFFE5484D),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                color: titleColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: subtitleColor, fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Color _statusColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.pending:
        return const Color(0xFFF5A623);
      case SyncStatus.success:
        return const Color(0xFF30A46C);
      case SyncStatus.merged:
        return appColor;
      case SyncStatus.failed:
        return const Color(0xFFE5484D);
      case SyncStatus.autoResolved:
        return const Color(0xFF7C6FFF);
      case SyncStatus.versionResolved:
        return const Color(0xFF06B6D4);
      case SyncStatus.alreadyDeleted:
        return const Color(0xFFFF6B6B);
      case SyncStatus.deleteResolved:
        return const Color(0xFFFF9F43);
      case SyncStatus.duplicateCreate:
        return const Color(0xFF26C6DA);
    }
  }

  String _statusLabel(SyncStatus status) {
    switch (status) {
      case SyncStatus.pending:
        return 'Pending';
      case SyncStatus.success:
        return 'Success';
      case SyncStatus.merged:
        return 'Merged';
      case SyncStatus.failed:
        return 'Failed';
      case SyncStatus.autoResolved:
        return 'Auto Resolved';
      case SyncStatus.versionResolved:
        return 'Version Resolved';
      case SyncStatus.alreadyDeleted:
        return 'Already Deleted';
      case SyncStatus.deleteResolved:
        return 'Delete Resolved';
      case SyncStatus.duplicateCreate:
        return 'Duplicate Create';
    }
  }

  Color _typeColor(SyncOperations type) {
    switch (type) {
      case SyncOperations.create:
        return const Color(0xFF30A46C);
      case SyncOperations.update:
        return const Color(0xFFF5A623);
      case SyncOperations.delete:
        return const Color(0xFFE5484D);
    }
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _StatItem {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
