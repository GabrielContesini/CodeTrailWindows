import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/app_enums.dart';
import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/page_frame.dart';
import '../application/analytics_controller.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsSummaryProvider);

    return PageFrame(
      title: 'Analytics',
      subtitle: 'Consistência, carga real de estudo e sinais para ajustar a semana.',
      tutorial: const PageTutorialData(
        id: 'analytics',
        title: 'Como usar analytics',
        description:
            'Olhe para esta tela para ajustar o plano com base em comportamento real, não só intenção.',
        steps: [
          'Veja o ritmo da semana atual versus a anterior.',
          'Use a produtividade média para entender qualidade, não só volume.',
          'Equilibre o mix entre teoria e prática olhando o foco aplicado.',
        ],
      ),
      child: AsyncValueView(
        value: analyticsAsync,
        data: (analytics) {
          final weeklyDelta = analytics.currentWeekHours - analytics.previousWeekHours;
          final weeklyDeltaLabel = weeklyDelta == 0
              ? 'Estável'
              : weeklyDelta > 0
                  ? '+${weeklyDelta.toStringAsFixed(1)}h'
                  : '${weeklyDelta.toStringAsFixed(1)}h';

          return LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 1320;

              return ListView(
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _InsightCard(
                        label: 'Semana atual',
                        value: '${analytics.currentWeekHours.toStringAsFixed(1)}h',
                        supporting:
                            'Comparado com ${analytics.previousWeekHours.toStringAsFixed(1)}h na semana anterior.',
                      ),
                      _InsightCard(
                        label: 'Ritmo semanal',
                        value: weeklyDeltaLabel,
                        supporting: weeklyDelta >= 0
                            ? 'Você está acelerando a cadência recente.'
                            : 'Semana mais leve do que a anterior.',
                      ),
                      _InsightCard(
                        label: 'Sessão média',
                        value: '${analytics.averageSessionMinutes.toStringAsFixed(0)} min',
                        supporting: 'Duração média das sessões registradas.',
                      ),
                      _InsightCard(
                        label: 'Produtividade',
                        value: '${analytics.averageProductivityScore.toStringAsFixed(1)}/5',
                        supporting:
                            analytics.dominantStudyType == null
                                ? 'Ainda sem sessões suficientes.'
                                : 'Modo dominante: ${analytics.dominantStudyType!.label}.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (compact) ...[
                    SizedBox(height: 320, child: _HoursByDayCard(analytics: analytics)),
                    const SizedBox(height: 16),
                    SizedBox(height: 320, child: _HoursByWeekCard(analytics: analytics)),
                    const SizedBox(height: 16),
                    SizedBox(height: 320, child: _DistributionCard(analytics: analytics)),
                  ] else
                    SizedBox(
                      height: 320,
                      child: Row(
                        children: [
                          Expanded(child: _HoursByDayCard(analytics: analytics)),
                          const SizedBox(width: 16),
                          Expanded(child: _HoursByWeekCard(analytics: analytics)),
                          const SizedBox(width: 16),
                          Expanded(child: _DistributionCard(analytics: analytics)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _MetricBox(
                          label: 'Taxa de conclusão',
                          value:
                              '${(analytics.completedTaskRate * 100).toStringAsFixed(0)}%',
                        ),
                        _MetricBox(
                          label: 'Revisões concluídas',
                          value: '${analytics.completedReviews}',
                        ),
                        _MetricBox(
                          label: 'Projetos concluídos',
                          value: '${analytics.completedProjects}',
                        ),
                        _MetricBox(
                          label: 'Consistência 30d',
                          value: '${analytics.consistencyDays} dias',
                        ),
                        _MetricBox(
                          label: 'Foco aplicado',
                          value: '${analytics.focusBalancePercent.toStringAsFixed(0)}%',
                        ),
                        _MetricBox(
                          label: 'Tipo dominante',
                          value: analytics.dominantStudyType?.label ?? 'Sem dados',
                        ),
                      ],
                    ),
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

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.label,
    required this.value,
    required this.supporting,
  });

  final String label;
  final String value;
  final String supporting;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              supporting,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _HoursByDayCard extends StatelessWidget {
  const _HoursByDayCard({required this.analytics});

  final dynamic analytics;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Horas por dia',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: analytics.hoursPerDay.isEmpty
                ? const _ChartEmptyState(label: 'Ainda sem horas registradas.')
                : BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(
                              analytics.hoursPerDay[value.toInt()].label,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ),
                      ),
                      barGroups: analytics.hoursPerDay
                          .asMap()
                          .entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.value,
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _HoursByWeekCard extends StatelessWidget {
  const _HoursByWeekCard({required this.analytics});

  final dynamic analytics;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Horas por semana',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: analytics.hoursPerWeek.isEmpty
                ? const _ChartEmptyState(label: 'Sem semanas suficientes ainda.')
                : LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(
                              analytics.hoursPerWeek[value.toInt()].label,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          barWidth: 3,
                          color: Theme.of(context).colorScheme.secondary,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.10),
                          ),
                          spots: analytics.hoursPerWeek
                              .asMap()
                              .entries
                              .map(
                                (entry) => FlSpot(
                                  entry.key.toDouble(),
                                  entry.value.value,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.analytics});

  final dynamic analytics;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribuição por tipo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: analytics.byType.isEmpty
                ? const _ChartEmptyState(label: 'Registre sessões para abrir o mix.')
                : PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 42,
                      sections: analytics.byType.entries
                          .map(
                            (entry) => PieChartSectionData(
                              title: entry.key.label,
                              value: entry.value,
                              radius: 76,
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChartEmptyState extends StatelessWidget {
  const _ChartEmptyState({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
