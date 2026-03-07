import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/service_providers.dart';
import '../../../core/services/sync_providers.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/models/app_view_models.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../../shared/widgets/sync_status_card.dart';
import '../../auth/application/auth_controller.dart';

class SettingsSyncScreen extends ConsumerStatefulWidget {
  const SettingsSyncScreen({super.key});

  @override
  ConsumerState<SettingsSyncScreen> createState() => _SettingsSyncScreenState();
}

class _SettingsSyncScreenState extends ConsumerState<SettingsSyncScreen> {
  bool _isSubmitting = false;

  Future<void> _syncNow() async {
    final userId = ref.read(currentUserIdProvider);
    if (_isSubmitting || userId == null || userId.isEmpty) return;

    setState(() => _isSubmitting = true);
    await ref.read(studyRepositoryProvider).forceSync(userId);
    final snapshot = ref.read(syncServiceProvider).currentState;
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    context.showAppSnackBar(snapshot.message ?? 'Sincronizacao concluida.');
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(currentUserIdProvider);
    final overviewAsync = ref.watch(syncOverviewProvider);
    final queueAsync = ref.watch(syncQueueItemsProvider);

    return PageFrame(
      title: 'Sincronizacao',
      subtitle:
          'Diagnostico detalhado da fila local, conectividade e ultimas tentativas de envio para o Supabase.',
      actions: [
        FilledButton.tonalIcon(
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back_rounded),
          label: const Text('Voltar'),
        ),
      ],
      child: ListView(
        children: [
          SyncStatusCard(
            userId: userId,
            title: 'Panorama geral',
            subtitle:
                'Use este painel para entender rapidamente se a estacao esta online, com fila pendente ou com falhas de envio.',
          ),
          const SizedBox(height: 14),
          overviewAsync.when(
            data: (overview) => _SyncHighlightsCard(overview: overview),
            loading: () => const AppCard(
              child: SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (error, _) => AppCard(child: Text(error.toString())),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fila pendente',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Cada item abaixo representa uma alteracao local que ainda precisa ser confirmada no Supabase.',
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _isSubmitting ? null : _syncNow,
                  icon: Icon(
                    _isSubmitting
                        ? Icons.sync_disabled_rounded
                        : Icons.sync_rounded,
                  ),
                  label: Text(
                    _isSubmitting ? 'Sincronizando...' : 'Tentar agora',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          queueAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const AppCard(
                  child: _EmptyQueueState(),
                );
              }

              return AppCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...items.take(30).map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _QueueItemTile(item: item),
                      ),
                    ),
                    if (items.length > 30)
                      Text(
                        'Mostrando os 30 itens mais recentes da fila.',
                        style: context.textTheme.bodySmall,
                      ),
                  ],
                ),
              );
            },
            loading: () => const AppCard(
              child: SizedBox(
                height: 140,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (error, _) => AppCard(child: Text(error.toString())),
          ),
        ],
      ),
    );
  }
}

class _SyncHighlightsCard extends StatelessWidget {
  const _SyncHighlightsCard({required this.overview});

  final SyncOverview overview;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _InfoBlock(
            title: 'Conectividade',
            value: overview.isOnline ? 'Online' : 'Offline',
            subtitle: overview.isOnline
                ? 'A sincronizacao pode ser executada agora.'
                : 'Novas alteracoes ficam seguras no cache local.',
          ),
          _InfoBlock(
            title: 'Itens pendentes',
            value: '${overview.queue.pendingItems}',
            subtitle: 'Registros aguardando confirmacao na nuvem.',
          ),
          _InfoBlock(
            title: 'Itens com falha',
            value: '${overview.queue.failedItems}',
            subtitle: overview.queue.hasFailures
                ? 'Existem registros que ja falharam ao sincronizar.'
                : 'Nenhuma falha registrada na fila atual.',
          ),
          _InfoBlock(
            title: 'Em cooldown',
            value: '${overview.queue.blockedItems}',
            subtitle: overview.queue.nextRetryAt == null
                ? 'Nenhum item aguardando janela de retry.'
                : 'Proxima tentativa em ${DateTimeUtils.shortDateTime(overview.queue.nextRetryAt)}.',
          ),
          _InfoBlock(
            title: 'Ultimo sucesso',
            value: DateTimeUtils.shortDateTime(overview.runtime.lastSuccessAt),
            subtitle: 'Momento da ultima sincronizacao bem-sucedida.',
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colorScheme.outline),
        color: context.colorScheme.surface.withValues(alpha: 0.32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textTheme.labelLarge),
          const SizedBox(height: 6),
          Text(
            value,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: context.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _QueueItemTile extends StatelessWidget {
  const _QueueItemTile({required this.item});

  final SyncQueueItemViewModel item;

  @override
  Widget build(BuildContext context) {
    final actionLabel = item.action == 'upsert' ? 'Atualizar' : 'Excluir';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.hasError
              ? context.colorScheme.error.withValues(alpha: 0.3)
              : context.colorScheme.outline,
        ),
        color: item.hasError
            ? context.colorScheme.error.withValues(alpha: 0.06)
            : context.colorScheme.surface.withValues(alpha: 0.28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_friendlyTableName(item.tableName)} • $actionLabel',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Tentativas ${item.attempts}',
                style: context.textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Registro ${item.recordId}',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SmallPill(
                label: 'Criado ${DateTimeUtils.shortDateTime(item.createdAt)}',
              ),
              _SmallPill(
                label:
                    'Ultima tentativa ${DateTimeUtils.shortDateTime(item.updatedAt)}',
              ),
              _SmallPill(
                label: item.nextRetryAt == null
                    ? 'Pronto para retry'
                    : 'Retry ${DateTimeUtils.shortDateTime(item.nextRetryAt)}',
              ),
            ],
          ),
          if (item.lastError != null) ...[
            const SizedBox(height: 10),
            Text(
              item.lastError!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.84),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: context.colorScheme.surface.withValues(alpha: 0.34),
        border: Border.all(color: context.colorScheme.outline),
      ),
      child: Text(label, style: context.textTheme.labelMedium),
    );
  }
}

class _EmptyQueueState extends StatelessWidget {
  const _EmptyQueueState();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nenhum item pendente',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'A fila local esta vazia. Isso indica que o cache local e a nuvem estao alinhados neste momento.',
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

String _friendlyTableName(String tableName) {
  switch (tableName) {
    case 'profiles':
      return 'Perfil';
    case 'user_goals':
      return 'Meta';
    case 'study_sessions':
      return 'Sessao';
    case 'tasks':
      return 'Tarefa';
    case 'reviews':
      return 'Revisao';
    case 'projects':
      return 'Projeto';
    case 'project_steps':
      return 'Etapa';
    case 'study_notes':
      return 'Nota';
    case 'app_settings':
      return 'Configuracao';
    case 'user_skill_progress':
      return 'Progresso de skill';
    default:
      return tableName;
  }
}
