import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/services/study_plan_generator.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/app_view_models.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../auth/application/auth_controller.dart';
import '../../tracks/application/tracks_controller.dart';
import '../application/onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _goalController = TextEditingController();
  final _areaController = TextEditingController(text: 'Tecnologia');
  final _hoursController = TextEditingController(text: '2');
  final _daysController = TextEditingController(text: '5');
  final _formKey = GlobalKey<FormState>();

  SkillLevel _level = SkillLevel.beginner;
  FocusType _focus = FocusType.job;
  String? _trackId;
  DateTime _deadline = DateTime.now().add(const Duration(days: 120));

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    _areaController.dispose();
    _hoursController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tracksAsync = ref.watch(trackBlueprintsProvider);
    final onboardingState = ref.watch(onboardingControllerProvider);
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      body: SafeArea(
        child: AsyncValueView<List<TrackBlueprint>>(
          value: tracksAsync,
          loadingMessage: 'Preparando trilhas iniciais...',
          data: (tracks) {
            _trackId ??= tracks.isNotEmpty ? tracks.first.track.id : null;
            final selectedTrack = tracks.firstWhere(
              (item) => item.track.id == _trackId,
              orElse: () => tracks.first,
            );
            final preview = StudyPlanGenerator.buildPreview(
              OnboardingInput(
                userId: userId ?? 'preview-user',
                name: _nameController.text.trim().isEmpty
                    ? 'Seu nome'
                    : _nameController.text.trim(),
                objective: _goalController.text.trim().isEmpty
                    ? 'Entrar em uma rotina de estudo consistente'
                    : _goalController.text.trim(),
                desiredArea: _areaController.text.trim().isEmpty
                    ? 'Tecnologia'
                    : _areaController.text.trim(),
                trackId: selectedTrack.track.id,
                selectedTrackName: selectedTrack.track.name,
                currentLevel: _level,
                hoursPerDay: int.tryParse(_hoursController.text) ?? 2,
                daysPerWeek: int.tryParse(_daysController.text) ?? 5,
                deadline: _deadline,
                focusType: _focus,
              ),
              blueprint: selectedTrack,
            );

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seu plano inicial',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Defina objetivo, trilha, ritmo e prazo. O app cria a base do seu workspace.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  preview.headline,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _PreviewChip(
                                      label: 'Ritmo',
                                      value: preview.confidenceLabel,
                                    ),
                                    _PreviewChip(
                                      label: 'Semana',
                                      value: '${preview.weeklyHours}h',
                                    ),
                                    _PreviewChip(
                                      label: 'Horizonte',
                                      value: '${preview.horizonWeeks} sem',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...preview.milestones.take(2).map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Icon(
                                            Icons.check_circle_outline_rounded,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(item)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: ListView.separated(
                              itemCount: tracks.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final track = tracks[index];
                                final selected = track.track.id == _trackId;
                                return InkWell(
                                  onTap: () =>
                                      setState(() => _trackId = track.track.id),
                                  borderRadius: BorderRadius.circular(22),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: selected
                                          ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.14)
                                          : Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                      border: Border.all(
                                        color: selected
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Theme.of(
                                                context,
                                              ).colorScheme.outline,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          track.track.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(track.track.description),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: AppCard(
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            Text(
                              'Onboarding',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nome',
                              ),
                              onChanged: (_) => setState(() {}),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Informe o nome'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _goalController,
                              decoration: const InputDecoration(
                                labelText: 'Objetivo principal',
                              ),
                              onChanged: (_) => setState(() {}),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Informe o objetivo'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _areaController,
                              decoration: const InputDecoration(
                                labelText: 'Área desejada',
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<SkillLevel>(
                              initialValue: _level,
                              decoration: const InputDecoration(
                                labelText: 'Nível atual',
                              ),
                              items: SkillLevel.values
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _level = value ?? _level),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<FocusType>(
                              initialValue: _focus,
                              decoration: const InputDecoration(
                                labelText: 'Foco principal',
                              ),
                              items: FocusType.values
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item.label),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _focus = value ?? _focus),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _hoursController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Horas por dia',
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _daysController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Dias por semana',
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 730),
                                  ),
                                  initialDate: _deadline,
                                );
                                if (picked != null) {
                                  setState(() => _deadline = picked);
                                }
                              },
                              icon: const Icon(Icons.calendar_today_rounded),
                              label: Text(
                                'Prazo-meta: ${_deadline.day}/${_deadline.month}/${_deadline.year}',
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed:
                                    onboardingState.isLoading || userId == null
                                    ? null
                                    : () async {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        final selectedTrack = tracks.firstWhere(
                                          (item) => item.track.id == _trackId,
                                        );
                                        final success = await ref
                                            .read(
                                              onboardingControllerProvider
                                                  .notifier,
                                            )
                                            .submit(
                                              OnboardingInput(
                                                userId: userId,
                                                name: _nameController.text
                                                    .trim(),
                                                objective: _goalController.text
                                                    .trim(),
                                                desiredArea: _areaController
                                                    .text
                                                    .trim(),
                                                trackId: selectedTrack.track.id,
                                                selectedTrackName:
                                                    selectedTrack.track.name,
                                                currentLevel: _level,
                                                hoursPerDay:
                                                    int.tryParse(
                                                      _hoursController.text,
                                                    ) ??
                                                    2,
                                                daysPerWeek:
                                                    int.tryParse(
                                                      _daysController.text,
                                                    ) ??
                                                    5,
                                                deadline: _deadline,
                                                focusType: _focus,
                                              ),
                                            );
                                        if (!context.mounted || !success) {
                                          return;
                                        }
                                        context.go(AppRoutes.dashboard);
                                      },
                                child: Text(
                                  onboardingState.isLoading
                                      ? 'Gerando plano...'
                                      : 'Finalizar onboarding',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
