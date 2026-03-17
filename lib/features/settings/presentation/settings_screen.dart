import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/app_update_models.dart';
import '../../../shared/models/app_view_models.dart';
import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../../shared/widgets/sync_status_card.dart';
import '../../auth/application/auth_controller.dart';
import '../../billing/application/billing_controller.dart';
import '../../billing/presentation/widgets/billing_plan_badge.dart';
import '../../billing/presentation/widgets/billing_trial_banner.dart';
import '../../tracks/application/tracks_controller.dart';
import '../application/app_update_controller.dart';
import '../application/settings_controller.dart';
import 'widgets/settings_common.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final profileAsync = ref.watch(profileProvider);
    final goalAsync = ref.watch(userGoalProvider);
    final tracksAsync = ref.watch(trackBlueprintsProvider);
    final appUpdateAsync = ref.watch(appUpdateControllerProvider);
    final session = ref.watch(authSessionProvider).asData?.value;
    final userId = ref.watch(currentUserIdProvider);
    final billingSnapshot = ref.watch(currentBillingSnapshotProvider);

    final hasError =
        settingsAsync.hasError ||
        profileAsync.hasError ||
        goalAsync.hasError ||
        tracksAsync.hasError;
    final isLoading =
        settingsAsync.isLoading ||
        profileAsync.isLoading ||
        goalAsync.isLoading ||
        tracksAsync.isLoading;

    return PageFrame(
      title: 'Perfil',
      subtitle:
          'Conta, metas, notificações e manutenção do seu workspace de estudo.',
      tutorial: const PageTutorialData(
        id: 'settings-profile-hub',
        title: 'Como usar o perfil',
        description:
            'Este hub concentra conta, rotina, alertas e ações de suporte.',
        steps: [
          'Abra Conta para editar nome, área, nível e trilha ativa.',
          'Use Metas e Notificações para ajustar a rotina do tablet.',
          'Ajuda reúne atalhos de suporte e redefinição dos tutoriais.',
        ],
      ),
      child: Builder(
        builder: (context) {
          if (hasError) {
            return ListView(
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Não foi possível carregar o perfil',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tente recarregar os dados locais e abrir a tela novamente.',
                      ),
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                        onPressed: () {
                          ref.invalidate(appSettingsProvider);
                          ref.invalidate(profileProvider);
                          ref.invalidate(userGoalProvider);
                          ref.invalidate(trackBlueprintsProvider);
                        },
                        child: const Text('Recarregar'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = settingsAsync.asData?.value;
          final profile = profileAsync.asData?.value;
          final goal = goalAsync.asData?.value;
          final tracks = tracksAsync.asData?.value ?? const <TrackBlueprint>[];
          final updateState = appUpdateAsync.asData?.value;
          final fullName = profile?.fullName ?? 'Seu perfil CodeTrail';
          final email = session?.user.email ?? profile?.email ?? 'Sem e-mail';
          final selectedTrackName = _trackNameFor(
            profile?.selectedTrackId,
            tracks,
          );

          return LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1120;
              final leftColumn = Column(
                children: [
                  SettingsProfileHeroCard(
                    fullName: fullName,
                    email: email,
                    selectedTrackName: selectedTrackName,
                    levelLabel: profile?.currentLevel.label ?? 'Sem nível',
                    focusLabel: goal?.focusType.label ?? 'Sem foco',
                    notificationsLabel: (settings?.notificationsEnabled ?? true)
                        ? 'Alertas ativos'
                        : 'Alertas pausados',
                    onEditAccount: () => context.push(AppRoutes.settingsAccount),
                  ),
                  const SizedBox(height: 14),
                  BillingTrialBanner(
                    snapshot: billingSnapshot,
                    onPrimaryAction: () =>
                        context.push(AppRoutes.settingsBilling),
                    primaryLabel: 'Plano e cobrança',
                  ),
                  const SizedBox(height: 14),
                  SyncStatusCard(
                    userId: userId,
                    title: 'Estado da sincronizacao',
                    subtitle:
                        'Use este painel para verificar fila, falhas e status de rede antes de alternar entre desktop e tablet.',
                  ),
                  const SizedBox(height: 14),
                  SettingsOverviewCard(
                    goal: goal,
                    settings: settings,
                    onThemeTap: () => _showThemeSheet(context, ref, settings),
                  ),
                ],
              );

              final rightColumn = Column(
                children: [
                  SettingsSectionCard(
                    title: 'Sua conta',
                    subtitle:
                        'Ajuste identidade, planejamento e segurança.',
                    children: [
                      SettingsActionTile(
                        icon: Icons.workspace_premium_outlined,
                        title: 'Plano e cobrança',
                        subtitle:
                            'Plano ${billingSnapshot.currentPlanCode.name.toUpperCase()} • ${billingSnapshot.isTrialing ? 'trial ativo' : 'gerenciar assinatura'}',
                        onTap: () => context.push(AppRoutes.settingsBilling),
                        trailing: BillingPlanBadge(
                          planCode: billingSnapshot.currentPlanCode,
                        ),
                      ),
                      SettingsActionTile(
                        icon: Icons.person_outline_rounded,
                        title: 'Conta',
                        subtitle:
                            'Nome, e-mail, área, nível e trilha ativa.',
                        onTap: () => context.push(AppRoutes.settingsAccount),
                      ),
                      SettingsActionTile(
                        icon: Icons.flag_outlined,
                        title: 'Metas',
                        subtitle: goal == null
                            ? 'Objetivo principal ainda não definido.'
                            : goal.primaryGoal,
                        onTap: goal == null
                            ? () => context.showAppSnackBar(
                                  'Conclua o onboarding para editar a meta.',
                                )
                            : () => _showGoalSheet(context, ref, goal),
                      ),
                      SettingsActionTile(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notificações',
                        subtitle: notificationsSummary(settings),
                        onTap: () =>
                            _showNotificationSheet(context, ref, settings),
                      ),
                      SettingsActionTile(
                        icon: Icons.security_rounded,
                        title: 'Segurança',
                        subtitle:
                            'Redefina a senha e revise o acesso deste tablet.',
                        onTap: () => _showSecuritySheet(context, ref, email),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SettingsSectionCard(
                    title: 'Sistema',
                    subtitle: 'Preferências, suporte e manutenção do app.',
                    children: [
                      SettingsActionTile(
                        icon: Icons.palette_outlined,
                        title: 'Tema',
                        subtitle:
                            'Modo ${themeLabel(settings?.themePreference ?? ThemePreference.dark).toLowerCase()}.',
                        onTap: () => _showThemeSheet(context, ref, settings),
                      ),
                      SettingsActionTile(
                        icon: Icons.language_rounded,
                        title: 'Idioma',
                        subtitle:
                            'Português (Brasil) como padrão desta build.',
                        onTap: () => _showLanguageSheet(context),
                      ),
                      SettingsActionTile(
                        icon: Icons.system_update_alt_rounded,
                        title: 'Atualizações',
                        subtitle: _updateSubtitle(updateState),
                        onTap: () => _showUpdateSheet(context, ref),
                      ),
                      SettingsActionTile(
                        icon: Icons.sync_rounded,
                        title: 'Sincronização',
                        subtitle:
                            'Veja fila local, falhas recentes e force nova tentativa.',
                        onTap: () => context.push(AppRoutes.settingsSync),
                      ),
                      SettingsActionTile(
                        icon: Icons.help_outline_rounded,
                        title: 'Ajuda',
                        subtitle:
                            'Tutoriais, FAQ e manutenção das integrações.',
                        onTap: () => context.push(AppRoutes.settingsHelp),
                      ),
                      SettingsActionTile(
                        icon: Icons.logout_rounded,
                        title: 'Encerrar sessão',
                        subtitle: 'Sai da conta atual somente neste tablet.',
                        destructive: true,
                        onTap: () => _confirmLogout(context, ref),
                      ),
                    ],
                  ),
                ],
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 8),
                child: wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 360, child: leftColumn),
                          const SizedBox(width: 14),
                          Expanded(child: rightColumn),
                        ],
                      )
                    : Column(
                        children: [
                          leftColumn,
                          const SizedBox(height: 14),
                          rightColumn,
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

Future<void> _showUpdateSheet(BuildContext context, WidgetRef ref) async {
  final state = ref.read(appUpdateControllerProvider).asData?.value;

  await _showSettingsSheet(
    context: context,
    title: 'Atualizações do Windows',
    subtitle:
        'O app verifica novas versões no GitHub Releases e pode abrir o instalador automaticamente.',
    builder: (sheetContext, setState) {
      return Consumer(
        builder: (context, ref, _) {
          final controllerState = ref.watch(appUpdateControllerProvider);
          final snapshot = controllerState.asData?.value ?? state;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoTile(
                icon: Icons.desktop_windows_rounded,
                title: 'Versão atual',
                subtitle: snapshot?.currentVersion ?? 'Não disponível',
              ),
              const SizedBox(height: 10),
              _InfoTile(
                icon: Icons.cloud_download_outlined,
                title: 'Status',
                subtitle: _updateSubtitle(snapshot),
              ),
              if (snapshot?.availableUpdate != null) ...[
                const SizedBox(height: 10),
                _InfoTile(
                  icon: Icons.new_releases_outlined,
                  title: 'Nova versão',
                  subtitle:
                      '${snapshot!.availableUpdate!.version} • ${_formatReleaseDate(snapshot.availableUpdate!.publishedAt)}',
                ),
              ],
              if ((snapshot?.errorMessage ?? '').isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  snapshot!.errorMessage!,
                  style: sheetContext.textTheme.bodySmall?.copyWith(
                    color: sheetContext.colorScheme.error,
                  ),
                ),
              ],
              if (snapshot?.isDownloading == true) ...[
                const SizedBox(height: 14),
                LinearProgressIndicator(value: snapshot?.downloadProgress),
              ],
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  OutlinedButton.icon(
                    onPressed: controllerState.isLoading || snapshot?.isChecking == true
                        ? null
                        : () async {
                            await ref
                                .read(appUpdateControllerProvider.notifier)
                                .checkForUpdates(force: true);
                          },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      snapshot?.isChecking == true
                          ? 'Verificando...'
                          : 'Verificar agora',
                    ),
                  ),
                  if (snapshot?.availableUpdate != null)
                    OutlinedButton.icon(
                      onPressed: snapshot?.isDownloading == true
                          ? null
                          : () async {
                              await ref
                                  .read(appUpdateControllerProvider.notifier)
                                  .openReleaseNotes();
                            },
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text('Ver mudanças'),
                    ),
                  if (snapshot?.availableUpdate != null)
                    FilledButton.icon(
                      onPressed: snapshot?.isDownloading == true
                          ? null
                          : () async {
                              final started = await ref
                                  .read(appUpdateControllerProvider.notifier)
                                  .downloadAndInstall();
                              if (sheetContext.mounted && started) {
                                Navigator.of(sheetContext).pop();
                                context.showAppSnackBar(
                                  'Instalador iniciado. Conclua a atualização para aplicar a nova versão.',
                                );
                              }
                            },
                      icon: const Icon(Icons.download_rounded),
                      label: Text(
                        snapshot?.isDownloading == true
                            ? 'Baixando...'
                            : 'Atualizar agora',
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _showGoalSheet(
  BuildContext context,
  WidgetRef ref,
  UserGoalEntity goal,
) async {
  final objectiveController = TextEditingController(text: goal.primaryGoal);
  var focusType = goal.focusType;
  var hoursPerDay = goal.hoursPerDay;
  var daysPerWeek = goal.daysPerWeek;

  await _showSettingsSheet(
    context: context,
    title: 'Metas',
    subtitle: 'Ajuste o alvo principal e o ritmo semanal do plano.',
    builder: (sheetContext, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: objectiveController,
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Objetivo principal'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<FocusType>(
            initialValue: focusType,
            decoration: const InputDecoration(labelText: 'Foco'),
            items: FocusType.values
                .map(
                  (item) =>
                      DropdownMenuItem(value: item, child: Text(item.label)),
                )
                .toList(),
            onChanged: (value) => setState(() => focusType = value ?? focusType),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: hoursPerDay,
                  decoration: const InputDecoration(labelText: 'Horas por dia'),
                  items: List.generate(12, (index) => index + 1)
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text('$value h'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => hoursPerDay = value ?? hoursPerDay),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: daysPerWeek,
                  decoration: const InputDecoration(labelText: 'Dias por semana'),
                  items: List.generate(7, (index) => index + 1)
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text('$value dias'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => daysPerWeek = value ?? daysPerWeek),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                final nextObjective = objectiveController.text.trim();
                if (nextObjective.isEmpty) {
                  sheetContext.showAppSnackBar(
                    'Informe o objetivo principal.',
                  );
                  return;
                }

                await ref.read(appSettingsProvider.notifier).saveGoal(
                  goal.copyWith(
                    primaryGoal: nextObjective,
                    focusType: focusType,
                    hoursPerDay: hoursPerDay,
                    daysPerWeek: daysPerWeek,
                    updatedAt: DateTime.now().toUtc(),
                  ),
                );
                if (sheetContext.mounted) {
                  Navigator.of(sheetContext).pop();
                  context.showAppSnackBar('Meta atualizada.');
                }
              },
              child: const Text('Salvar ajustes'),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _showNotificationSheet(
  BuildContext context,
  WidgetRef ref,
  AppSettingsEntity? settings,
) async {
  var enabled = settings?.notificationsEnabled ?? true;
  var reminderHour = settings?.dailyReminderHour ?? 20;

  await _showSettingsSheet(
    context: context,
    title: 'Notificações',
    subtitle: 'Controle sessões, revisões e lembrete diário do tablet.',
    builder: (sheetContext, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Alertas do app'),
            subtitle: const Text('Sessões, revisões e lembrete diário.'),
            value: enabled,
            onChanged: (value) => setState(() => enabled = value),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: reminderHour,
            decoration: const InputDecoration(
              labelText: 'Hora do lembrete diário',
            ),
            items: List.generate(18, (index) => index + 6)
                .map(
                  (hour) => DropdownMenuItem(
                    value: hour,
                    child: Text('${hour.toString().padLeft(2, '0')}:00'),
                  ),
                )
                .toList(),
            onChanged: enabled
                ? (value) => setState(() => reminderHour = value ?? reminderHour)
                : null,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                final controller = ref.read(appSettingsProvider.notifier);
                await controller.toggleNotifications(enabled);
                if (enabled) {
                  await controller.updateReminderHour(reminderHour);
                }
                if (sheetContext.mounted) {
                  Navigator.of(sheetContext).pop();
                  context.showAppSnackBar('Preferências de alerta atualizadas.');
                }
              },
              child: const Text('Salvar preferências'),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _showSecuritySheet(
  BuildContext context,
  WidgetRef ref,
  String email,
) async {
  var sending = false;

  await _showSettingsSheet(
    context: context,
    title: 'Segurança',
    subtitle: 'Redefina a senha da conta conectada neste tablet.',
    builder: (sheetContext, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _InfoTile(
            icon: Icons.mail_outline_rounded,
            title: 'E-mail vinculado',
            subtitle: email,
          ),
          const SizedBox(height: 10),
          const _InfoTile(
            icon: Icons.shield_outlined,
            title: 'Sessão local',
            subtitle: 'A conta atual está ativa apenas neste dispositivo.',
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: !email.contains('@') || sending
                  ? null
                  : () async {
                      setState(() => sending = true);
                      final success = await ref
                          .read(authControllerProvider.notifier)
                          .resetPassword(email);
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                        context.showAppSnackBar(
                          success
                              ? 'Link de redefinição enviado para $email.'
                              : 'Não foi possível enviar o link de redefinição.',
                        );
                      }
                    },
              child: Text(
                sending ? 'Enviando...' : 'Enviar link de redefinição',
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _showThemeSheet(
  BuildContext context,
  WidgetRef ref,
  AppSettingsEntity? settings,
) async {
  final selectedTheme = settings?.themePreference ?? ThemePreference.dark;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 520,
                maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.72,
              ),
              child: AppCard(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tema',
                        style: sheetContext.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Escolha como o CodeTrail aparece no tablet.',
                        style: sheetContext.textTheme.bodySmall?.copyWith(
                          color: sheetContext.colorScheme.onSurface.withValues(
                            alpha: 0.68,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...ThemePreference.values.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _ChoiceTile(
                            title: item.label,
                            subtitle:
                                'Aplicar modo ${item.label.toLowerCase()}.',
                            selected: item == selectedTheme,
                            onTap: () async {
                              await ref
                                  .read(appSettingsProvider.notifier)
                                  .updateTheme(item);
                              if (sheetContext.mounted) {
                                Navigator.of(sheetContext).pop();
                                context.showAppSnackBar(
                                  'Tema ${item.label.toLowerCase()} aplicado.',
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> _showLanguageSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 520,
                maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.72,
              ),
              child: AppCard(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Idioma',
                        style: sheetContext.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Português (Brasil) é o idioma ativo nesta build.',
                        style: sheetContext.textTheme.bodySmall?.copyWith(
                          color: sheetContext.colorScheme.onSurface.withValues(
                            alpha: 0.68,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const _ChoiceTile(
                        title: 'Português (Brasil)',
                        subtitle: 'Idioma padrão do app atualmente.',
                        selected: true,
                      ),
                      const SizedBox(height: 10),
                      _ChoiceTile(
                        title: 'English',
                        subtitle:
                            'Suporte multilíngue entra em uma próxima build.',
                        selected: false,
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          context.showAppSnackBar(
                            'Suporte multilíngue entra em uma próxima build.',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Encerrar sessão'),
        content: const Text(
          'Você será redirecionado para a tela de login neste tablet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sair'),
          ),
        ],
      );
    },
  );

  if (shouldLogout != true) return;

  await ref.read(authControllerProvider.notifier).signOut();
  if (context.mounted) {
    context.go(AppRoutes.login);
  }
}

Future<void> _showSettingsSheet({
  required BuildContext context,
  required String title,
  required String subtitle,
  required Widget Function(
    BuildContext context,
    void Function(VoidCallback fn) setState,
  )
  builder,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                18,
                0,
                18,
                18 + MediaQuery.viewInsetsOf(sheetContext).bottom,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 620,
                    maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.78,
                  ),
                  child: AppCard(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: sheetContext.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            style: sheetContext.textTheme.bodySmall?.copyWith(
                              color: sheetContext.colorScheme.onSurface
                                  .withValues(alpha: 0.68),
                            ),
                          ),
                          const SizedBox(height: 16),
                          builder(sheetContext, setState),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colorScheme.outline),
        color: context.colorScheme.surface.withValues(alpha: 0.34),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colorScheme.primary.withValues(alpha: 0.14),
            ),
            child: Icon(icon, color: context.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: context.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? context.colorScheme.primary
                  : context.colorScheme.outline,
            ),
            color: selected
                ? context.colorScheme.primary.withValues(alpha: 0.12)
                : context.colorScheme.surface.withValues(alpha: 0.34),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: context.textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.chevron_right_rounded,
                color: selected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurface.withValues(alpha: 0.52),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _trackNameFor(String? trackId, List<TrackBlueprint> blueprints) {
  for (final blueprint in blueprints) {
    if (blueprint.track.id == trackId) return blueprint.track.name;
  }
  return 'Trilha ainda não definida';
}

String _updateSubtitle(AppUpdateState? state) {
  if (state == null) {
    return 'Verifique novas versões publicadas para o Windows.';
  }
  if (state.isChecking) {
    return 'Consultando a release mais recente no GitHub.';
  }
  if (state.availableUpdate != null) {
    return 'Nova versão ${state.availableUpdate!.version} pronta para instalar.';
  }
  return 'Você já está na versão mais recente (${state.currentVersion}).';
}

String _formatReleaseDate(DateTime date) {
  final local = date.toLocal();
  return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}
