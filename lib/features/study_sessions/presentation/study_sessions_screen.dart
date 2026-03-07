import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../core/utils/layout_utils.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/app_view_models.dart';
import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../auth/application/auth_controller.dart';
import '../../tracks/application/tracks_controller.dart';
import '../application/study_sessions_controller.dart';

class StudySessionsScreen extends ConsumerWidget {
  const StudySessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(studySessionsProvider);
    final tracksAsync = ref.watch(trackBlueprintsProvider);

    return PageFrame(
      title: 'Sessões de estudo',
      subtitle: 'Cronômetro, histórico e registro de produtividade.',
      tutorial: const PageTutorialData(
        id: 'sessions',
        title: 'Como ler o histórico de sessões',
        description:
            'Use esta lista para validar consistência, produtividade e volume real de estudo.',
        steps: [
          'Abra “Nova sessão” para registrar um novo bloco de foco.',
          'Edite uma sessão para corrigir notas, vínculo de skill ou duração.',
          'Exclua registros indevidos sem deixar lixo no banco local.',
        ],
      ),
      actions: [
        FilledButton.icon(
          onPressed: () => context.go(AppRoutes.newSession),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Nova sessão'),
        ),
      ],
      child: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => ListView(
          children: const [
            AppCard(
              child: Text('Não foi possível carregar o histórico de sessões.'),
            ),
          ],
        ),
        data: (sessions) => tracksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => ListView(
            children: const [
              AppCard(
                child: Text('Não foi possível carregar as trilhas vinculadas.'),
              ),
            ],
          ),
          data: (tracks) => _SessionsList(sessions: sessions, tracks: tracks),
        ),
      ),
    );
  }
}

class _SessionsList extends ConsumerWidget {
  const _SessionsList({required this.sessions, required this.tracks});

  final List<StudySessionEntity> sessions;
  final List<TrackBlueprint> tracks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sessions.isEmpty) {
      return ListView(
        children: const [
          AppCard(
            child: Text(
              'Nenhuma sessão registrada ainda. Use “Nova sessão” para começar.',
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      itemCount: sessions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final session = sessions[index];
        final track = _findTrack(tracks, session.trackId);
        final skillName = _findSkillName(track, session.skillId);
        final moduleName = _findModuleName(track, session.moduleId);

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.type.label,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${DateTimeUtils.shortDateTime(session.startTime)} • ${DateTimeUtils.minutesToReadable(session.durationMinutes)}',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.10),
                    ),
                    child: Text(
                      'Prod. ${session.productivityScore}/5',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (track != null) _MetaChip(label: track.track.name),
                  if (skillName != null) _MetaChip(label: skillName),
                  if (moduleName != null) _MetaChip(label: moduleName),
                ],
              ),
              if (session.notes.trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  session.notes,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => _showSessionDialog(
                      context,
                      ref,
                      tracks,
                      initial: session,
                    ),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar'),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () => _confirmDelete(context, ref, session),
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('Excluir'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    StudySessionEntity session,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir sessão'),
          content: Text(
            'Remover a sessão de ${DateTimeUtils.shortDateTime(session.startTime)}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await ref.read(studySessionActionsProvider).delete(session.id);
    if (context.mounted) {
      context.showAppSnackBar('Sessão removida.');
    }
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.34),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

Future<void> _showSessionDialog(
  BuildContext context,
  WidgetRef ref,
  List<TrackBlueprint> tracks, {
  StudySessionEntity? initial,
}) async {
  final userId = ref.read(currentUserIdProvider);
  final uuid = const Uuid();
  if (userId == null) return;

  final notesController = TextEditingController(text: initial?.notes ?? '');
  final durationController = TextEditingController(
    text: (initial?.durationMinutes ?? 50).toString(),
  );
  var type = initial?.type ?? SessionType.practice;
  var productivity = initial?.productivityScore ?? 4;
  var trackId = initial?.trackId ?? '';
  var skillId = initial?.skillId ?? '';
  var moduleId = initial?.moduleId ?? '';
  var startedAt = initial?.startTime.toLocal() ?? DateTime.now();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          final selectedTrack = _findTrack(
            tracks,
            trackId.isEmpty ? null : trackId,
          );
          final dialogWidth = responsiveDialogWidth(
            dialogContext,
            ideal: 560,
            min: 340,
          );

          return AlertDialog(
            title: Text(initial == null ? 'Nova sessão manual' : 'Editar sessão'),
            content: SizedBox(
              width: dialogWidth,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<SessionType>(
                      initialValue: type,
                      decoration: const InputDecoration(labelText: 'Tipo'),
                      items: SessionType.values
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => type = value ?? type),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: trackId.isEmpty ? null : trackId,
                      decoration: const InputDecoration(labelText: 'Trilha'),
                      items: tracks
                          .map(
                            (item) => DropdownMenuItem(
                              value: item.track.id,
                              child: Text(item.track.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          trackId = value ?? '';
                          skillId = '';
                          moduleId = '';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: skillId.isEmpty ? null : skillId,
                      decoration: const InputDecoration(labelText: 'Skill'),
                      items: (selectedTrack?.skills ?? const [])
                          .map(
                            (item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => skillId = value ?? ''),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: moduleId.isEmpty ? null : moduleId,
                      decoration: const InputDecoration(labelText: 'Módulo'),
                      items: (selectedTrack?.modules ?? const [])
                          .map(
                            (item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.title),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => moduleId = value ?? ''),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Duração em minutos',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Data e hora de início'),
                      subtitle: Text(DateTimeUtils.shortDateTime(startedAt)),
                      trailing: const Icon(Icons.schedule_rounded),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: dialogContext,
                          initialDate: startedAt,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date == null || !dialogContext.mounted) {
                          return;
                        }
                        final time = await showTimePicker(
                          context: dialogContext,
                          initialTime: TimeOfDay.fromDateTime(startedAt),
                        );
                        if (time == null) return;
                        setState(() {
                          startedAt = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      minLines: 4,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: 'Notas',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Produtividade percebida: $productivity/5',
                          style: Theme.of(dialogContext).textTheme.titleMedium,
                        ),
                        Slider(
                          value: productivity.toDouble(),
                          divisions: 4,
                          min: 1,
                          max: 5,
                          label: '$productivity',
                          onChanged: (value) =>
                              setState(() => productivity = value.toInt()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  final durationMinutes =
                      int.tryParse(durationController.text.trim()) ?? 0;
                  if (durationMinutes <= 0) {
                    dialogContext.showAppSnackBar(
                      'Informe uma duração válida em minutos.',
                    );
                    return;
                  }

                  final now = DateTime.now().toUtc();
                  final startUtc = startedAt.toUtc();
                  final endUtc = startUtc.add(Duration(minutes: durationMinutes));

                  await ref.read(studySessionActionsProvider).save(
                        StudySessionEntity(
                          id: initial?.id ?? uuid.v4(),
                          userId: userId,
                          trackId: trackId.isEmpty ? null : trackId,
                          skillId: skillId.isEmpty ? null : skillId,
                          moduleId: moduleId.isEmpty ? null : moduleId,
                          type: type,
                          startTime: startUtc,
                          endTime: endUtc,
                          durationMinutes: durationMinutes,
                          notes: notesController.text.trim(),
                          productivityScore: productivity,
                          createdAt: initial?.createdAt ?? now,
                          updatedAt: now,
                        ),
                      );
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                    context.showAppSnackBar(
                      initial == null
                          ? 'Sessão criada.'
                          : 'Sessão atualizada.',
                    );
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      );
    },
  );
}

TrackBlueprint? _findTrack(List<TrackBlueprint> tracks, String? trackId) {
  for (final track in tracks) {
    if (track.track.id == trackId) return track;
  }
  return null;
}

String? _findSkillName(TrackBlueprint? track, String? skillId) {
  if (track == null || skillId == null) return null;
  for (final skill in track.skills) {
    if (skill.id == skillId) return skill.name;
  }
  return null;
}

String? _findModuleName(TrackBlueprint? track, String? moduleId) {
  if (track == null || moduleId == null) return null;
  for (final module in track.modules) {
    if (module.id == moduleId) return module.title;
  }
  return null;
}
