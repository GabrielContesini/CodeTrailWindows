import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/icon_mapper.dart';
import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../tracks/application/tracks_controller.dart';

class TracksScreen extends ConsumerWidget {
  const TracksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(trackBlueprintsProvider);

    return PageFrame(
      title: 'Trilhas',
      subtitle: 'Roadmaps por carreira com skills, módulos e progresso.',
      tutorial: const PageTutorialData(
        id: 'tracks',
        title: 'Como escolher uma trilha',
        description:
            'As trilhas agrupam carreira, skills e módulos para dar direção ao estudo.',
        steps: [
          'Abra uma trilha para ver skills e módulos sugeridos.',
          'Compare progresso para entender onde está acumulando atraso.',
          'Use a trilha como referência e não como prisão rígida.',
        ],
      ),
      child: AsyncValueView(
        value: tracksAsync,
        data: (tracks) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final int columns =
                  (constraints.maxWidth / 340).floor().clamp(1, 4);
              final aspectRatio = switch (columns) {
                1 => 1.08,
                2 => 1.26,
                3 => 1.34,
                _ => 1.4,
              };

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  final item = tracks[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: () =>
                        context.go('${AppRoutes.trackDetails}/${item.track.id}'),
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              IconMapper.fromKey(item.track.iconKey),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item.track.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.track.description,
                            maxLines: columns == 1 ? 4 : 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          LinearProgressIndicator(
                            value: item.progressPercent / 100,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${item.skills.length} skills • ${item.modules.length} módulos • ${item.progressPercent.toStringAsFixed(0)}%',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
