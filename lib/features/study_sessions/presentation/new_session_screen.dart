import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/router/app_router.dart';
import '../../../core/services/service_providers.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/app_view_models.dart';
import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../auth/application/auth_controller.dart';
import '../../tracks/application/tracks_controller.dart';
import '../application/study_sessions_controller.dart';

class NewSessionScreen extends ConsumerStatefulWidget {
  const NewSessionScreen({super.key});

  @override
  ConsumerState<NewSessionScreen> createState() => _NewSessionScreenState();
}

class _NewSessionScreenState extends ConsumerState<NewSessionScreen> {
  final _uuid = const Uuid();
  final _notesController = TextEditingController();
  final _stopwatch = Stopwatch();

  Timer? _ticker;
  SessionType _type = SessionType.practice;
  int _productivity = 4;
  String? _trackId;
  String? _skillId;
  String? _moduleId;
  DateTime? _startedAt;

  @override
  void dispose() {
    _notesController.dispose();
    _ticker?.cancel();
    unawaited(
      ref.read(notificationServiceProvider).cancelSessionNotifications(),
    );
    super.dispose();
  }

  Future<void> _start() async {
    if (_stopwatch.isRunning) {
      return;
    }

    _startedAt ??= DateTime.now().toUtc();
    _stopwatch.start();
    _ticker?.cancel();
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
    setState(() {});

    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.showOngoingStudySession(
      title: 'Sessão em andamento',
      body: 'Seu foco está ativo. Continue até fechar este bloco.',
    );
    await notificationService.scheduleEndingSessionReminder(
      remindAt: DateTime.now().toUtc().add(const Duration(minutes: 50)),
      title: 'Sessão prestes a vencer',
      body: 'Feche, pause ou salve sua sessão atual.',
    );
  }

  Future<void> _pause() async {
    _stopwatch.stop();
    _ticker?.cancel();
    setState(() {});
    await ref.read(notificationServiceProvider).cancelSessionNotifications();
  }

  Future<void> _saveSession() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null || _stopwatch.elapsed.inSeconds == 0) {
      return;
    }

    final now = DateTime.now().toUtc();
    final elapsedMinutes = _stopwatch.elapsed.inMinutes == 0
        ? 1
        : _stopwatch.elapsed.inMinutes;

    _stopwatch.stop();
    _ticker?.cancel();

    final session = StudySessionEntity(
      id: _uuid.v4(),
      userId: userId,
      trackId: _trackId,
      skillId: _skillId,
      moduleId: _moduleId,
      type: _type,
      startTime: _startedAt ?? now,
      endTime: now,
      durationMinutes: elapsedMinutes,
      notes: _notesController.text.trim(),
      productivityScore: _productivity,
      createdAt: now,
      updatedAt: now,
    );

    await ref.read(studySessionActionsProvider).save(session);
    await ref.read(notificationServiceProvider).cancelSessionNotifications();

    if (!mounted) {
      return;
    }

    context.showAppSnackBar('Sessão salva com sucesso.');
    context.go(AppRoutes.sessions);
  }

  @override
  Widget build(BuildContext context) {
    final tracksAsync = ref.watch(trackBlueprintsProvider);
    final userId = ref.watch(currentUserIdProvider);

    return PageFrame(
      title: 'Nova sessão',
      subtitle:
          'Inicie um bloco de foco, acompanhe o cronômetro e salve mesmo em uma sessão curta de teste.',
      tutorial: const PageTutorialData(
        id: 'new_session',
        title: 'Como registrar uma sessão',
        description:
            'O fluxo agora foi simplificado para você conseguir iniciar, pausar e salvar sem ambiguidade.',
        steps: [
          'Escolha o tipo e, se quiser, vincule trilha, skill e módulo.',
          'Use o botão grande de iniciar para ativar cronômetro e notificação.',
          'Finalize com salvar; sessões curtas já podem ser usadas para teste.',
        ],
      ),
      actions: [
        OutlinedButton.icon(
          onPressed: _stopwatch.isRunning ? _pause : _start,
          icon: Icon(
            _stopwatch.isRunning
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
          ),
          label: Text(_stopwatch.isRunning ? 'Pausar' : 'Iniciar'),
        ),
        FilledButton.icon(
          onPressed: userId == null || _stopwatch.elapsed.inSeconds == 0
              ? null
              : _saveSession,
          icon: const Icon(Icons.save_rounded),
          label: const Text('Salvar'),
        ),
      ],
      child: AsyncValueView(
        value: tracksAsync,
        data: (tracks) {
          final selectedTrackIndex = tracks.indexWhere(
            (item) => item.track.id == _trackId,
          );
          final selectedTrack = selectedTrackIndex >= 0
              ? tracks[selectedTrackIndex]
              : null;
          final templates = _sessionTemplatesFor(selectedTrack);

          return LayoutBuilder(
            builder: (context, constraints) {
              final sideBySide =
                  constraints.maxWidth >= 1440 && constraints.maxHeight >= 760;
              final notesPanelHeight = constraints.maxHeight >= 860
                  ? 420.0
                  : constraints.maxHeight >= 740
                  ? 360.0
                  : 300.0;

              final setupCard = AppCard(
                child: LayoutBuilder(
                  builder: (context, cardConstraints) {
                    final minHeight = cardConstraints.hasBoundedHeight
                        ? cardConstraints.maxHeight
                        : 0.0;
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: minHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1),
                              ),
                              child: Text(
                                _stopwatch.isRunning
                                    ? 'Sessão em andamento'
                                    : _startedAt == null
                                    ? 'Pronto para começar'
                                    : 'Sessão pausada',
                                style: Theme.of(
                                  context,
                                ).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              _formatDuration(_stopwatch.elapsed),
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enquanto o cronômetro roda, o app mantém uma notificação de sessão ativa no Android.',
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Templates rápidos',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: templates
                                  .map(
                                    (template) => InkWell(
                                      borderRadius: BorderRadius.circular(18),
                                      onTap: () =>
                                          _applyTemplate(template, selectedTrack),
                                      child: Container(
                                        width: 220,
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(18),
                                          border: Border.all(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.outline,
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withValues(alpha: 0.24),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              template.icon,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              template.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              template.subtitle,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 24),
                            FilledButton.icon(
                              onPressed: _stopwatch.isRunning ? _pause : _start,
                              icon: Icon(
                                _stopwatch.isRunning
                                    ? Icons.pause_circle_outline_rounded
                                    : Icons.play_circle_outline_rounded,
                              ),
                              label: Text(
                                _stopwatch.isRunning
                                    ? 'Pausar sessão'
                                    : _startedAt == null
                                    ? 'Iniciar sessão'
                                    : 'Retomar sessão',
                              ),
                            ),
                            const SizedBox(height: 18),
                            DropdownButtonFormField<SessionType>(
                              key: ValueKey(_type),
                              initialValue: _type,
                              isExpanded: true,
                              menuMaxHeight: 280,
                              decoration: const InputDecoration(
                                labelText: 'Tipo',
                              ),
                              items: SessionType.values
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item.label),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _type = value ?? _type),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              key: ValueKey('track-$_trackId'),
                              initialValue: _trackId,
                              isExpanded: true,
                              menuMaxHeight: 280,
                              decoration: const InputDecoration(
                                labelText: 'Trilha',
                              ),
                              items: tracks
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item.track.id,
                                      child: Text(item.track.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) => setState(() {
                                _trackId = value;
                                _skillId = null;
                                _moduleId = null;
                              }),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              key: ValueKey('skill-$_trackId-$_skillId'),
                              initialValue: _skillId,
                              isExpanded: true,
                              menuMaxHeight: 280,
                              decoration: const InputDecoration(
                                labelText: 'Skill',
                              ),
                              items: (selectedTrack?.skills ?? const [])
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item.id,
                                      child: Text(item.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _skillId = value),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              key: ValueKey('module-$_trackId-$_moduleId'),
                              initialValue: _moduleId,
                              isExpanded: true,
                              menuMaxHeight: 280,
                              decoration: const InputDecoration(
                                labelText: 'Módulo',
                              ),
                              items: (selectedTrack?.modules ?? const [])
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item.id,
                                      child: Text(item.title),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _moduleId = value),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );

              final notesCard = AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notas da sessão',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: TextField(
                        controller: _notesController,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText:
                              'O que foi estudado? Onde travou? Qual próximo passo vai destravar o progresso?',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Produtividade percebida',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Slider(
                      value: _productivity.toDouble(),
                      divisions: 4,
                      min: 1,
                      max: 5,
                      label: '$_productivity',
                      onChanged: (value) =>
                          setState(() => _productivity = value.toInt()),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed:
                            userId == null || _stopwatch.elapsed.inSeconds == 0
                            ? null
                            : _saveSession,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Salvar sessão'),
                      ),
                    ),
                  ],
                ),
              );

              if (!sideBySide) {
                return ListView(
                  children: [
                    setupCard,
                    const SizedBox(height: 14),
                    SizedBox(height: notesPanelHeight, child: notesCard),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(flex: 5, child: setupCard),
                  const SizedBox(width: 14),
                  Expanded(flex: 6, child: notesCard),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _applyTemplate(
    _SessionTemplateOption template,
    TrackBlueprint? selectedTrack,
  ) {
    setState(() {
      _type = template.type;
      _productivity = template.productivity;
      if (selectedTrack != null) {
        _trackId = selectedTrack.track.id;
        if (template.prefersCoreModule && selectedTrack.modules.isNotEmpty) {
          _moduleId = selectedTrack.modules.first.id;
        }
      }
      _notesController.text = template.prefillText(selectedTrack);
    });
  }

  List<_SessionTemplateOption> _sessionTemplatesFor(TrackBlueprint? track) {
    return [
      _SessionTemplateOption(
        title: 'Deep focus',
        subtitle: 'Teoria com objetivo claro e checkpoint de entendimento.',
        icon: Icons.menu_book_rounded,
        type: SessionType.theory,
        productivity: 4,
        prefillBuilder: (selectedTrack) =>
            'Objetivo do bloco:\n- Entender o conceito central.\n\nAnotacoes-chave:\n- \n- \n\nProximo passo:\n- ${selectedTrack?.track.name ?? 'Aplicar o conceito em um exemplo rápido.'}',
      ),
      _SessionTemplateOption(
        title: 'Sprint prático',
        subtitle: 'Mao no codigo, entrega pequena e feedback rapido.',
        icon: Icons.code_rounded,
        type: SessionType.practice,
        productivity: 5,
        prefersCoreModule: true,
        prefillBuilder: (selectedTrack) =>
            'Entregavel da sessao:\n- ${selectedTrack?.modules.isNotEmpty == true ? selectedTrack!.modules.first.title : 'Resolver um bloco prático'}\n\nBloqueios:\n- \n\nEvidencia de progresso:\n- ',
      ),
      _SessionTemplateOption(
        title: 'Revisao ativa',
        subtitle: 'Consolidar memoria com perguntas, gaps e retomada.',
        icon: Icons.refresh_rounded,
        type: SessionType.review,
        productivity: 4,
        prefillBuilder: (_) =>
            'Conteudos revisados:\n- \n- \n\nO que ainda errei:\n- \n\nProxima revisao:\n- ',
      ),
      _SessionTemplateOption(
        title: 'Projeto guiado',
        subtitle: 'Avance uma etapa concreta do portfolio ou case.',
        icon: Icons.rocket_launch_outlined,
        type: SessionType.project,
        productivity: 5,
        prefersCoreModule: true,
        prefillBuilder: (selectedTrack) =>
            'Etapa do projeto:\n- \n\nLigacao com a trilha:\n- ${selectedTrack?.track.name ?? 'Projeto aplicado'}\n\nResultado da sessao:\n- ',
      ),
    ];
  }
}

class _SessionTemplateOption {
  const _SessionTemplateOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.type,
    required this.productivity,
    required this.prefillBuilder,
    this.prefersCoreModule = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final SessionType type;
  final int productivity;
  final bool prefersCoreModule;
  final String Function(TrackBlueprint? track) prefillBuilder;

  String prefillText(TrackBlueprint? track) => prefillBuilder(track);
}
