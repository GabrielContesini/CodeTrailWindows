import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../tracks/application/tracks_controller.dart';

class TrackDetailsScreen extends ConsumerWidget {
  const TrackDetailsScreen({super.key, required this.trackId});

  final String trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackAsync = ref.watch(selectedTrackProvider(trackId));

    return PageFrame(
      title: 'Detalhes da trilha',
      subtitle: 'Skills, módulos sugeridos e progresso atual.',
      tutorial: const PageTutorialData(
        id: 'track_details',
        title: 'Como ler a trilha',
        description:
            'Os detalhes conectam skill, progresso e módulos sugeridos em uma única visão.',
        steps: [
          'Leia as skills para entender o que precisa dominar.',
          'Use as barras de progresso para localizar gargalos.',
          'Transforme módulos prioritários em tarefas ou sessões.',
        ],
      ),
      child: AsyncValueView(
        value: trackAsync,
        data: (track) {
          if (track == null) {
            return const Center(child: Text('Trilha não encontrada.'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 1180;

              final skillsCard = AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.track.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    Text(track.track.roadmapSummary),
                    const SizedBox(height: 20),
                    Text(
                      'Skills',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: track.skills.length,
                        separatorBuilder: (_, _) => const Divider(height: 24),
                        itemBuilder: (context, index) {
                          final skill = track.skills[index];
                          final progress =
                              track.progressBySkill[skill.id]?.progressPercent ??
                              0;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                skill.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 6),
                              Text(skill.description),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(value: progress / 100),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );

              final modulesCard = AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Módulos sugeridos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: track.modules.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final module = track.modules[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  module.title,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 6),
                                Text(module.summary),
                                const SizedBox(height: 8),
                                Text('${module.estimatedHours}h estimadas'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );

              return Flex(
                direction: compact ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: skillsCard),
                  SizedBox(
                    width: compact ? 0 : 16,
                    height: compact ? 16 : 0,
                  ),
                  Expanded(child: modulesCard),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
