import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/service_providers.dart';
import '../../core/services/sync_providers.dart';
import '../../core/utils/date_time_utils.dart';
import '../extensions/context_extensions.dart';
import '../models/app_view_models.dart';
import 'app_card.dart';

class SyncStatusCard extends ConsumerStatefulWidget {
  const SyncStatusCard({
    super.key,
    required this.userId,
    this.title = 'Sincronizacao',
    this.subtitle,
  });

  final String? userId;
  final String title;
  final String? subtitle;

  @override
  ConsumerState<SyncStatusCard> createState() => _SyncStatusCardState();
}

class _SyncStatusCardState extends ConsumerState<SyncStatusCard> {
  bool _isSubmitting = false;

  Future<void> _syncNow() async {
    final userId = widget.userId;
    if (_isSubmitting || userId == null || userId.isEmpty) return;

    setState(() => _isSubmitting = true);
    await ref.read(studyRepositoryProvider).forceSync(userId);
    final state = ref.read(syncServiceProvider).currentState;

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    context.showAppSnackBar(state.message ?? 'Sincronizacao concluida.');
  }

  @override
  Widget build(BuildContext context) {
    final syncOverviewAsync = ref.watch(syncOverviewProvider);

    return AppCard(
      child: syncOverviewAsync.when(
        data: (overview) => _SyncStatusContent(
          overview: overview,
          title: widget.title,
          subtitle: widget.subtitle,
          isSubmitting: _isSubmitting,
          canSync: widget.userId != null && widget.userId!.isNotEmpty,
          onSyncNow: _syncNow,
        ),
        loading: () => const SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(error.toString(), style: context.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _SyncStatusContent extends StatelessWidget {
  const _SyncStatusContent({
    required this.overview,
    required this.title,
    required this.subtitle,
    required this.isSubmitting,
    required this.canSync,
    required this.onSyncNow,
  });

  final SyncOverview overview;
  final String title;
  final String? subtitle;
  final bool isSubmitting;
  final bool canSync;
  final Future<void> Function() onSyncNow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(theme, overview);
    final statusLabel = _statusLabel(overview);
    final detailLabel = _detailLabel(overview);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: context.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            _StatusPill(label: statusLabel, color: statusColor),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          detailLabel,
          style: context.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.82),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _MetricPill(
              icon: overview.isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
              label: overview.isOnline ? 'Conectado' : 'Offline',
            ),
            _MetricPill(
              icon: Icons.outbox_outlined,
              label: 'Fila ${overview.queue.pendingItems}',
            ),
            if (overview.queue.blockedItems > 0)
              _MetricPill(
                icon: Icons.hourglass_bottom_rounded,
                label: 'Aguardando ${overview.queue.blockedItems}',
              ),
            _MetricPill(
              icon: Icons.error_outline_rounded,
              label: 'Falhas ${overview.queue.failedItems}',
            ),
            if (overview.queue.oldestPendingAt != null)
              _MetricPill(
                icon: Icons.schedule_rounded,
                label:
                    'Mais antigo ${DateTimeUtils.shortDateTime(overview.queue.oldestPendingAt!)}',
              ),
          ],
        ),
        if (overview.queue.lastError != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: theme.colorScheme.error.withValues(alpha: 0.08),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.18),
              ),
            ),
            child: Text(
              overview.queue.lastError!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.84),
              ),
            ),
          ),
        ],
        const SizedBox(height: 14),
        Row(
          children: [
            FilledButton.icon(
              onPressed: canSync && !isSubmitting ? onSyncNow : null,
              icon: Icon(
                isSubmitting ? Icons.sync_disabled_rounded : Icons.sync_rounded,
              ),
              label: Text(isSubmitting ? 'Sincronizando...' : 'Sincronizar agora'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _footerLabel(overview),
                style: context.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.64),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Color _statusColor(ThemeData theme, SyncOverview overview) {
    switch (overview.runtime.phase) {
      case SyncActivityPhase.syncing:
        return theme.colorScheme.primary;
      case SyncActivityPhase.success:
        return theme.colorScheme.secondary;
      case SyncActivityPhase.cooldown:
        return theme.colorScheme.tertiary;
      case SyncActivityPhase.failed:
        return theme.colorScheme.error;
      case SyncActivityPhase.offline:
        return theme.colorScheme.tertiary;
      case SyncActivityPhase.idle:
        return overview.queue.hasFailures
            ? theme.colorScheme.error
            : theme.colorScheme.outline;
    }
  }

  static String _statusLabel(SyncOverview overview) {
    switch (overview.runtime.phase) {
      case SyncActivityPhase.syncing:
        return 'Sincronizando';
      case SyncActivityPhase.success:
        return 'Em dia';
      case SyncActivityPhase.cooldown:
        return 'Aguardando retry';
      case SyncActivityPhase.failed:
        return 'Com falha';
      case SyncActivityPhase.offline:
        return 'Offline';
      case SyncActivityPhase.idle:
        if (overview.queue.hasFailures) return 'Fila com erro';
        if (overview.queue.hasPendingItems) return 'Pendente';
        return 'Estavel';
    }
  }

  static String _detailLabel(SyncOverview overview) {
    final message = overview.runtime.message;
    if (message != null && message.isNotEmpty) return message;
    if (!overview.isOnline) {
      return 'Sem conexao no momento. O app continua operando offline-first.';
    }
    if (overview.queue.blockedItems > 0 && overview.queue.nextRetryAt != null) {
      return 'Parte da fila esta em cooldown ate ${DateTimeUtils.shortDateTime(overview.queue.nextRetryAt)}.';
    }
    if (overview.queue.hasFailures) {
      return 'Existem registros na fila que falharam e precisam de nova tentativa.';
    }
    if (overview.queue.hasPendingItems) {
      return 'Ha alteracoes locais aguardando envio para o Supabase.';
    }
    return 'Nenhuma alteracao pendente. O cache local e a nuvem estao alinhados.';
  }

  static String _footerLabel(SyncOverview overview) {
    final lastSuccess = overview.runtime.lastSuccessAt;
    final lastFailure = overview.runtime.lastFailureAt;

    if (lastFailure != null &&
        (lastSuccess == null || lastFailure.isAfter(lastSuccess))) {
      return 'Ultima falha em ${DateTimeUtils.shortDateTime(lastFailure)}.';
    }
    if (lastSuccess != null) {
      return 'Ultimo sync bem-sucedido em ${DateTimeUtils.shortDateTime(lastSuccess)}.';
    }
    return 'Ainda sem historico de sincronizacao bem-sucedida nesta sessao.';
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: context.textTheme.labelLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colorScheme.surface.withValues(alpha: 0.34),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.74),
          ),
          const SizedBox(width: 8),
          Text(label, style: context.textTheme.labelMedium),
        ],
      ),
    );
  }
}
