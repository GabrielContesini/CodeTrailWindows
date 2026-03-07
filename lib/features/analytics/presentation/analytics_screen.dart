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
      subtitle: 'Consistência, horas estudadas e evolução operacional.',
      tutorial: const PageTutorialData(
        id: 'analytics',
        title: 'Como usar analytics',
        description:
            'Olhe para esta tela para ajustar o plano com base em comportamento real, não só intenção.',
        steps: [
          'Leia horas por dia para entender sua cadência recente.',
          'Veja a distribuição por tipo para equilibrar teoria e prática.',
          'Use as métricas finais para medir execução, revisão e entrega.',
        ],
      ),
      child: AsyncValueView(
        value: analyticsAsync,
        data: (analytics) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 1180;

              final hoursCard = AppCard(
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
                      child: BarChart(
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
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

              final distributionCard = AppCard(
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
                      child: PieChart(
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

              return ListView(
                children: [
                  if (compact) ...[
                    SizedBox(height: 320, child: hoursCard),
                    const SizedBox(height: 16),
                    SizedBox(height: 320, child: distributionCard),
                  ] else
                    SizedBox(
                      height: 320,
                      child: Row(
                        children: [
                          Expanded(child: hoursCard),
                          const SizedBox(width: 16),
                          Expanded(child: distributionCard),
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
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
