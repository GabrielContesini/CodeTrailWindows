import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/page_tutorial.dart';
import '../../../shared/models/app_view_models.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../../shared/widgets/sync_status_card.dart';
import '../../auth/application/auth_controller.dart';
import '../../dashboard/application/dashboard_controller.dart';
import '../../projects/application/projects_controller.dart';
import '../../reviews/application/reviews_controller.dart';
import '../../tasks/application/tasks_controller.dart';
import '../../tracks/application/tracks_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final tracksAsync = ref.watch(trackBlueprintsProvider);
    final tasksAsync = ref.watch(tasksProvider);
    final reviewsAsync = ref.watch(reviewsProvider);
    final projectsAsync = ref.watch(projectsProvider);
    final userId = ref.watch(currentUserIdProvider);

    return PageFrame(
      title: 'Dashboard',
      subtitle:
          'Uma visão mais editorial do seu workspace: foco, fila de execução e progresso prático em uma única superfície.',
      tutorial: const PageTutorialData(
        id: 'dashboard',
        title: 'Como usar o dashboard desktop',
        description:
            'Nesta versão, o dashboard foi reorganizado para desktop. Você ganha contexto à esquerda, execução no centro e leitura rápida do estado geral.',
        steps: [
          'Comece pela sessão de foco para destravar o dia.',
          'Acompanhe a fila de execução antes de trocar de módulo.',
          'Use trilhas e projetos como leitura de médio prazo.',
        ],
      ),
      actions: [
        OutlinedButton.icon(
          onPressed: () => context.go(AppRoutes.analytics),
          icon: const Icon(Icons.insights_outlined),
          label: const Text('Abrir analytics'),
        ),
        FilledButton.icon(
          onPressed: () => context.go(AppRoutes.newSession),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Nova sessão'),
        ),
      ],
      child: AsyncValueView(
        value: summaryAsync,
        data: (summary) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final topWide = constraints.maxWidth >= 1380;
              final bottomWide = constraints.maxWidth >= 1320;
              final metricColumns = constraints.maxWidth >= 1480
                  ? 4
                  : constraints.maxWidth >= 1040
                  ? 2
                  : 1;

              return ListView(
                children: [
                  if (topWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _CommandDeck(summary: summary)),
                        const SizedBox(width: 14),
                        Expanded(flex: 4, child: _FocusConsole(summary: summary)),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _CommandDeck(summary: summary),
                        const SizedBox(height: 14),
                        _FocusConsole(summary: summary),
                      ],
                    ),
                  const SizedBox(height: 16),
                  SyncStatusCard(
                    userId: userId,
                    title: 'Sincronizacao',
                    subtitle:
                        'Esta estacao salva primeiro no cache local e envia para o Supabase quando a rede permite.',
                  ),
                  const SizedBox(height: 16),
                  _MetricGrid(
                    columns: metricColumns,
                    children: [
                      _MetricCard(
                        title: 'Horas na semana',
                        value: summary.hoursThisWeek.toStringAsFixed(1),
                        subtitle: 'Volume consolidado de estudo recente.',
                        icon: Icons.schedule_rounded,
                      ),
                      _MetricCard(
                        title: 'Streak',
                        value: '${summary.streakDays} dias',
                        subtitle: 'Sequência ativa de consistência.',
                        icon: Icons.local_fire_department_outlined,
                      ),
                      _MetricCard(
                        title: 'Revisões urgentes',
                        value: '${summary.overdueReviews}',
                        subtitle: 'Itens vencidos pedindo retenção.',
                        icon: Icons.history_toggle_off_rounded,
                      ),
                      _MetricCard(
                        title: 'Projetos ativos',
                        value: '${summary.activeProjects}',
                        subtitle: 'Portfólio atualmente em execução.',
                        icon: Icons.account_tree_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (bottomWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: _ExecutionBoard(
                            tasksAsync: tasksAsync,
                            reviewsAsync: reviewsAsync,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              _TrackPulse(tracksAsync: tracksAsync),
                              const SizedBox(height: 14),
                              _ProjectPulse(projectsAsync: projectsAsync),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _ExecutionBoard(
                          tasksAsync: tasksAsync,
                          reviewsAsync: reviewsAsync,
                        ),
                        const SizedBox(height: 14),
                        _TrackPulse(tracksAsync: tracksAsync),
                        const SizedBox(height: 14),
                        _ProjectPulse(projectsAsync: projectsAsync),
                      ],
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _CommandDeck extends StatelessWidget {
  const _CommandDeck({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nextSessionLabel = summary.nextSession == null
        ? 'Nenhuma sessão iniciada ainda. Use um bloco de 25 a 50 minutos para começar o histórico.'
        : '${summary.nextSession!.type.label} • ${DateTimeUtils.shortDateTime(summary.nextSession!.startTime)} • ${DateTimeUtils.minutesToReadable(summary.nextSession!.durationMinutes)}';

    return AppCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.16),
              theme.colorScheme.surface.withValues(alpha: 0.12),
              theme.colorScheme.secondary.withValues(alpha: 0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: theme.colorScheme.surface.withValues(alpha: 0.62),
                ),
                child: Text(
                  summary.totalSessions == 0
                      ? 'Primeiro ciclo'
                      : 'Comando do dia',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                summary.totalSessions == 0
                    ? 'Comece registrando sua primeira sessão de foco.'
                    : 'Você já gerou histórico. Agora use esse histórico para priorizar.',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Text(
                  'A versão Windows foi redesenhada para servir como central de operação. Use o bloco abaixo para partir de intenção para ação concreta sem abrir várias telas ao mesmo tempo.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.76),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: theme.colorScheme.surface.withValues(alpha: 0.46),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.82),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Próxima sessão',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(nextSessionLabel, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _QuickLaunchTile(
                    route: AppRoutes.newSession,
                    icon: Icons.play_arrow_rounded,
                    title: 'Iniciar foco',
                    subtitle: 'Abrir cronômetro e contexto da sessão.',
                  ),
                  _QuickLaunchTile(
                    route: AppRoutes.tasks,
                    icon: Icons.add_task_rounded,
                    title: 'Nova tarefa',
                    subtitle: 'Converter intenção em próximo passo.',
                  ),
                  _QuickLaunchTile(
                    route: AppRoutes.notes,
                    icon: Icons.note_alt_outlined,
                    title: 'Abrir notas',
                    subtitle: 'Registrar comando, resumo ou bloqueio.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickLaunchTile extends StatelessWidget {
  const _QuickLaunchTile({
    required this.route,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String route;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 220,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => context.go(route),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.82),
              ),
              color: theme.colorScheme.surface.withValues(alpha: 0.42),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FocusConsole extends StatelessWidget {
  const _FocusConsole({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Pendências de tarefa',
        '${summary.pendingTasks}',
        'Próximos passos ainda abertos.',
        Icons.check_circle_outline_rounded,
      ),
      (
        'Revisões urgentes',
        '${summary.overdueReviews}',
        'Retenção em risco neste momento.',
        Icons.history_edu_outlined,
      ),
      (
        'Projetos ativos',
        '${summary.activeProjects}',
        'Entregas práticas em andamento.',
        Icons.rocket_launch_outlined,
      ),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Radar de atenção',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Leitura rápida do que merece atenção antes de abrir outra área do app.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 18),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _PriorityTile(
                title: item.$1,
                value: item.$2,
                subtitle: item.$3,
                icon: item.$4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityTile extends StatelessWidget {
  const _PriorityTile({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.82),
        ),
        color: theme.colorScheme.surface.withValues(alpha: 0.32),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.columns, required this.children});

  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final width = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExecutionBoard extends StatelessWidget {
  const _ExecutionBoard({
    required this.tasksAsync,
    required this.reviewsAsync,
  });

  final AsyncValue<List<TaskEntity>> tasksAsync;
  final AsyncValue<List<ReviewEntity>> reviewsAsync;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: SizedBox(
        height: 410,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fila de execução',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Aqui ficam os itens que exigem ação imediata para manter o estudo útil.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 720;
                  final tasksPanel = _AsyncQueuePanel(
                    title: 'Tarefas do dia',
                    emptyLabel:
                        'Sem tarefas pendentes. Abra Tarefas e defina a próxima ação.',
                    asyncValue: tasksAsync,
                    builder: (data) =>
                        data.take(6).map((item) => item.title).toList(),
                  );
                  final reviewsPanel = _AsyncQueuePanel(
                    title: 'Revisões pendentes',
                    emptyLabel:
                        'Nenhuma revisão pendente agora. Gere revisões ao concluir conteúdos-chave.',
                    asyncValue: reviewsAsync,
                    builder: (data) =>
                        data.take(6).map((item) => item.title).toList(),
                  );

                  if (!wide) {
                    return Column(
                      children: [
                        Expanded(child: tasksPanel),
                        const SizedBox(height: 12),
                        Expanded(child: reviewsPanel),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: tasksPanel),
                      const SizedBox(width: 12),
                      Expanded(child: reviewsPanel),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AsyncQueuePanel<T> extends StatelessWidget {
  const _AsyncQueuePanel({
    required this.title,
    required this.emptyLabel,
    required this.asyncValue,
    required this.builder,
  });

  final String title;
  final String emptyLabel;
  final AsyncValue<T> asyncValue;
  final List<String> Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.82),
        ),
        color: theme.colorScheme.surface.withValues(alpha: 0.32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: asyncValue.when(
              data: (data) {
                final items = builder(data);
                if (items.isEmpty) {
                  return Text(emptyLabel, style: theme.textTheme.bodySmall);
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: theme.colorScheme.surface.withValues(alpha: 0.42),
                    ),
                    child: Text(
                      items[index],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.84),
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text(error.toString()),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackPulse extends StatelessWidget {
  const _TrackPulse({required this.tracksAsync});

  final AsyncValue<List<TrackBlueprint>> tracksAsync;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: SizedBox(
        height: 198,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pulso das trilhas',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: tracksAsync.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const Text(
                      'Selecione uma trilha para começar a medir skills e módulos.',
                    );
                  }
                  return ListView.separated(
                    itemCount: data.length > 4 ? 4 : data.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return _LinearSnapshotTile(
                        title: item.track.name,
                        percent: item.progressPercent,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text(error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectPulse extends StatelessWidget {
  const _ProjectPulse({required this.projectsAsync});

  final AsyncValue<List<ProjectBundle>> projectsAsync;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: SizedBox(
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Projetos em andamento',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: projectsAsync.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const Text(
                      'Sem projetos ativos. Use a área de projetos para transformar estudo em portfólio.',
                    );
                  }
                  return ListView.separated(
                    itemCount: data.length > 4 ? 4 : data.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return _LinearSnapshotTile(
                        title: item.project.title,
                        percent: item.project.progressPercent,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text(error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinearSnapshotTile extends StatelessWidget {
  const _LinearSnapshotTile({required this.title, required this.percent});

  final String title;
  final double percent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.82),
        ),
        color: theme.colorScheme.surface.withValues(alpha: 0.34),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${percent.toStringAsFixed(0)}%',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(value: percent / 100),
          ),
        ],
      ),
    );
  }
}
