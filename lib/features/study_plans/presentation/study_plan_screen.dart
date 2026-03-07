import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../tracks/application/tracks_controller.dart';

class StudyPlanScreen extends ConsumerWidget {
  const StudyPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(trackBlueprintsProvider);

    return PageFrame(
      title: 'Plano de estudo',
      subtitle: 'Roadmap manual ou sugerido por módulos principais.',
      tutorial: const PageTutorialData(
        id: 'study_plan',
        title: 'Como usar o plano',
        description:
            'O plano consolida os módulos da trilha para você saber o que vem depois.',
        steps: [
          'Use os módulos como sequência base da trilha escolhida.',
          'Cruze esta tela com tarefas para definir o que entra na semana.',
          'Volte aqui quando sentir que perdeu a ordem de estudo.',
        ],
      ),
      child: AsyncValueView(
        value: tracksAsync,
        data: (tracks) {
          return ListView.separated(
            itemCount: tracks.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final track = tracks[index];
              return AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.track.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...track.modules.map(
                      (module) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Icon(
                              module.isCore
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.circle_outlined,
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(module.title)),
                            Text('${module.estimatedHours}h'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
