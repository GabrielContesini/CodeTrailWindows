import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/app_entities.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/app_view_models.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../auth/application/auth_controller.dart';
import '../../tracks/application/tracks_controller.dart';
import '../application/settings_controller.dart';
import 'widgets/settings_common.dart';

class SettingsAccountScreen extends ConsumerStatefulWidget {
  const SettingsAccountScreen({super.key});

  @override
  ConsumerState<SettingsAccountScreen> createState() =>
      _SettingsAccountScreenState();
}

class _SettingsAccountScreenState extends ConsumerState<SettingsAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _areaController = TextEditingController();

  String _selectedTrackId = '';
  SkillLevel _selectedLevel = SkillLevel.beginner;
  String? _seededProfileId;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final tracksAsync = ref.watch(trackBlueprintsProvider);
    final session = ref.watch(authSessionProvider).asData?.value;

    return PageFrame(
      title: 'Conta',
      subtitle: 'Dados principais do seu perfil dentro do CodeTrail.',
      actions: [
        FilledButton.tonalIcon(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
          label: const Text('Voltar'),
        ),
      ],
      child: Builder(
        builder: (context) {
          if (profileAsync.isLoading || tracksAsync.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileAsync.hasError || tracksAsync.hasError) {
            return ListView(
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Não foi possível carregar a conta',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tente novamente em alguns instantes.',
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          final profile = profileAsync.asData?.value;
          final tracks = tracksAsync.asData?.value ?? const <TrackBlueprint>[];
          final email = session?.user.email ?? profile?.email ?? 'Sem e-mail';
          if (profile == null) {
            return ListView(
              children: [
                AppCard(
                  child: Text(
                    'Perfil ainda indisponível. Complete o onboarding primeiro.',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          }

          _seedForm(profile, email);
          final trackName = _trackNameFor(_selectedTrackId, tracks);

          return LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1100;

              final hero = AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              context.colorScheme.primary.withValues(alpha: 0.94),
                              context.colorScheme.secondary.withValues(alpha: 0.88),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initialsFrom(profile.fullName),
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: const Color(0xFF06110A),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      profile.fullName,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      email,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurface.withValues(
                          alpha: 0.68,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SettingsOverviewRow(
                      label: 'Trilha',
                      value: trackName,
                    ),
                    SettingsOverviewRow(
                      label: 'Nível',
                      value: _selectedLevel.label,
                    ),
                    SettingsOverviewRow(
                      label: 'Conta',
                      value: 'Sincronizada com Supabase',
                    ),
                  ],
                ),
              );

              final formCard = AppCard(
                child: LayoutBuilder(
                  builder: (context, innerConstraints) {
                    final compactFields = innerConstraints.maxWidth < 720;

                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Editar dados',
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Atualize as informações centrais do seu perfil.',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface.withValues(
                                alpha: 0.68,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nome completo',
                            ),
                            validator: (value) {
                              if ((value ?? '').trim().isEmpty) {
                                return 'Informe o nome completo.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _emailController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'E-mail da conta',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _areaController,
                            decoration: const InputDecoration(
                              labelText: 'Área desejada',
                            ),
                            validator: (value) {
                              if ((value ?? '').trim().isEmpty) {
                                return 'Informe a área desejada.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          if (!compactFields)
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<SkillLevel>(
                                    initialValue: _selectedLevel,
                                    decoration: const InputDecoration(
                                      labelText: 'Nível atual',
                                    ),
                                    items: SkillLevel.values
                                        .map(
                                          (item) => DropdownMenuItem(
                                            value: item,
                                            child: Text(item.label),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      if (value == null) return;
                                      setState(() => _selectedLevel = value);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _selectedTrackId,
                                    decoration: const InputDecoration(
                                      labelText: 'Trilha ativa',
                                    ),
                                    items: [
                                      const DropdownMenuItem(
                                        value: '',
                                        child: Text('Sem trilha'),
                                      ),
                                      ...tracks.map(
                                        (item) => DropdownMenuItem(
                                          value: item.track.id,
                                          child: Text(item.track.name),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(
                                        () => _selectedTrackId = value ?? '',
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          if (compactFields)
                            Column(
                              children: [
                                DropdownButtonFormField<SkillLevel>(
                                  initialValue: _selectedLevel,
                                  decoration: const InputDecoration(
                                    labelText: 'Nível atual',
                                  ),
                                  items: SkillLevel.values
                                      .map(
                                        (item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(item.label),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() => _selectedLevel = value);
                                  },
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedTrackId,
                                  decoration: const InputDecoration(
                                    labelText: 'Trilha ativa',
                                  ),
                                  items: [
                                    const DropdownMenuItem(
                                      value: '',
                                      child: Text('Sem trilha'),
                                    ),
                                    ...tracks.map(
                                      (item) => DropdownMenuItem(
                                        value: item.track.id,
                                        child: Text(item.track.name),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(
                                      () => _selectedTrackId = value ?? '',
                                    );
                                  },
                                ),
                              ],
                            ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _saving
                                  ? null
                                  : () => _saveProfile(ref, profile),
                              child: Text(
                                _saving ? 'Salvando...' : 'Salvar alterações',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );

              return ListView(
                children: [
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 340, child: hero),
                        const SizedBox(width: 14),
                        Expanded(child: formCard),
                      ],
                    )
                  else ...[
                    hero,
                    const SizedBox(height: 14),
                    formCard,
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _seedForm(ProfileEntity profile, String email) {
    if (_seededProfileId == profile.id) return;
    _seededProfileId = profile.id;
    _nameController.text = profile.fullName;
    _emailController.text = email;
    _areaController.text = profile.desiredArea;
    _selectedLevel = profile.currentLevel;
    _selectedTrackId = profile.selectedTrackId ?? '';
  }

  Future<void> _saveProfile(
    WidgetRef ref,
    ProfileEntity profile,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    await ref.read(appSettingsProvider.notifier).saveProfile(
      profile.copyWith(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        desiredArea: _areaController.text.trim(),
        currentLevel: _selectedLevel,
        selectedTrackId: _selectedTrackId.isEmpty ? null : _selectedTrackId,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    if (!mounted) return;

    setState(() => _saving = false);
    context.showAppSnackBar('Dados da conta atualizados.');
  }
}

String _trackNameFor(String trackId, List<TrackBlueprint> tracks) {
  for (final item in tracks) {
    if (item.track.id == trackId) {
      return item.track.name;
    }
  }
  return 'Trilha ainda não definida';
}
