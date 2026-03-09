import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/app_enums.dart';
import '../../../shared/models/app_view_models.dart';
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
        data: (AnalyticsSummary analytics) {
          final weeklyDelta =
              analytics.currentWeekHours - analytics.previousWeekHours;
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

  final AnalyticsSummary analytics;

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
                : RepaintBoundary(
                    child: BarChart(
                      BarChartData(
                        minY: 0,
                        alignment: BarChartAlignment.spaceAround,
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: _gridInterval(
                            analytics.hoursPerDay,
                          ),
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.14),
                            strokeWidth: 1,
                          ),
                        ),
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
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) => _chartTitle(
                                context,
                                value,
                                analytics.hoursPerDay,
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
                                    width: 20,
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.secondary,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
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

  final AnalyticsSummary analytics;

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
                : RepaintBoundary(
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: analytics.hoursPerWeek.length <= 1
                            ? 1
                            : (analytics.hoursPerWeek.length - 1).toDouble(),
                        minY: 0,
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: _gridInterval(
                            analytics.hoursPerWeek,
                          ),
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Theme.of(
                              context,
                            ).colorScheme.outline.withValues(alpha: 0.14),
                            strokeWidth: 1,
                          ),
                        ),
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
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) => _chartTitle(
                                context,
                                value,
                                analytics.hoursPerWeek,
                              ),
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            barWidth: 3,
                            color: Theme.of(context).colorScheme.secondary,
                            dotData: FlDotData(
                              show: analytics.hoursPerWeek.length < 8,
                            ),
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
          ),
        ],
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.analytics});

  final AnalyticsSummary analytics;

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
                : Column(
                    children: [
                      Expanded(
                        child: RepaintBoundary(
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 4,
                              centerSpaceRadius: 42,
                              sections: analytics.byType.entries
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => PieChartSectionData(
                                      title: '',
                                      value: entry.value.value,
                                      radius: 76,
                                      color: _distributionColor(
                                        context,
                                        entry.key,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: analytics.byType.entries
                            .toList()
                            .asMap()
                            .entries
                            .map(
                              (entry) => _LegendChip(
                                color: _distributionColor(context, entry.key),
                                label:
                                    '${entry.value.key.label} • ${entry.value.value.toStringAsFixed(1)}h',
                              ),
                            )
                            .toList(),
                      ),
                    ],
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

Widget _chartTitle(
  BuildContext context,
  double value,
  List<ChartDatum> points,
) {
  final index = value.round();
  if (index < 0 || index >= points.length) {
    return const SizedBox.shrink();
  }

  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
      points[index].label,
      style: Theme.of(context).textTheme.labelSmall,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

double _gridInterval(List<ChartDatum> points) {
  if (points.isEmpty) {
    return 1;
  }

  final maxValue = points
      .map((item) => item.value)
      .fold<double>(0, (current, value) => value > current ? value : current);
  if (maxValue <= 2) {
    return 0.5;
  }
  if (maxValue <= 6) {
    return 1;
  }
  return (maxValue / 4).clamp(1, maxValue);
}

Color _distributionColor(BuildContext context, int index) {
  final scheme = Theme.of(context).colorScheme;
  final palette = <Color>[
    scheme.primary,
    scheme.secondary,
    scheme.tertiary,
    scheme.primary.withValues(alpha: 0.72),
    scheme.secondary.withValues(alpha: 0.72),
  ];
  return palette[index % palette.length];
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
