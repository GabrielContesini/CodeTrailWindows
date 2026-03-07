import 'package:flutter/material.dart';

import '../../../../domain/entities/app_entities.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/models/app_enums.dart';
import '../../../../shared/widgets/app_card.dart';

class SettingsProfileHeroCard extends StatelessWidget {
  const SettingsProfileHeroCard({
    super.key,
    required this.fullName,
    required this.email,
    required this.selectedTrackName,
    required this.levelLabel,
    required this.focusLabel,
    required this.notificationsLabel,
    required this.onEditAccount,
  });

  final String fullName;
  final String email;
  final String selectedTrackName;
  final String levelLabel;
  final String focusLabel;
  final String notificationsLabel;
  final VoidCallback onEditAccount;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 360;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flex(
                direction: compact ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          context.colorScheme.primary.withValues(alpha: 0.92),
                          context.colorScheme.secondary.withValues(alpha: 0.84),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        initialsFrom(fullName),
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF06110A),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: compact ? 0 : 14, height: compact ? 14 : 0),
                  if (compact)
                    _ProfileIntro(
                      fullName: fullName,
                      email: email,
                      onEditAccount: onEditAccount,
                    ),
                  if (!compact)
                    Expanded(
                      child: _ProfileIntro(
                        fullName: fullName,
                        email: email,
                        onEditAccount: onEditAccount,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFF0E121A),
                  border: Border.all(
                    color: context.colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workspace atual',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      selectedTrackName,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SettingsMetaChip(
                          icon: Icons.school_outlined,
                          label: levelLabel,
                        ),
                        SettingsMetaChip(
                          icon: Icons.flag_outlined,
                          label: focusLabel,
                        ),
                        SettingsMetaChip(
                          icon: Icons.notifications_none_rounded,
                          label: notificationsLabel,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileIntro extends StatelessWidget {
  const _ProfileIntro({
    required this.fullName,
    required this.email,
    required this.onEditAccount,
  });

  final String fullName;
  final String email;
  final VoidCallback onEditAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fullName,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1.04,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          email,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.68),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton.tonalIcon(
          onPressed: onEditAccount,
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const Text('Editar conta'),
        ),
      ],
    );
  }
}

class SettingsOverviewCard extends StatelessWidget {
  const SettingsOverviewCard({
    super.key,
    required this.goal,
    required this.settings,
    required this.onThemeTap,
  });

  final UserGoalEntity? goal;
  final AppSettingsEntity? settings;
  final VoidCallback onThemeTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo rápido',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Uma leitura rápida do ritmo atual antes de entrar nas subtelas.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.68),
            ),
          ),
          const SizedBox(height: 16),
          SettingsOverviewRow(
            label: 'Cadência',
            value: goal == null
                ? 'Ainda não definida'
                : '${goal!.hoursPerDay}h/dia • ${goal!.daysPerWeek} dias/sem',
          ),
          SettingsOverviewRow(
            label: 'Prazo alvo',
            value: goal == null ? 'Sem prazo' : formatDate(goal!.deadline),
          ),
          SettingsOverviewRow(
            label: 'Tema',
            value: themeLabel(
              settings?.themePreference ?? ThemePreference.dark,
            ),
          ),
          SettingsOverviewRow(
            label: 'Lembrete',
            value: notificationsSummary(settings),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onThemeTap,
            icon: const Icon(Icons.palette_outlined),
            label: const Text('Ajustar aparência'),
          ),
        ],
      ),
    );
  }
}

class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.68),
            ),
          ),
          const SizedBox(height: 16),
          ...buildSpacedChildren(children),
        ],
      ),
    );
  }
}

class SettingsActionTile extends StatelessWidget {
  const SettingsActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final accent = destructive
        ? context.colorScheme.error
        : context.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: context.colorScheme.outline),
            color: destructive
                ? accent.withValues(alpha: 0.08)
                : context.colorScheme.surface.withValues(alpha: 0.34),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.14),
                ),
                child: Icon(icon, size: 20, color: accent),
              ),
              const SizedBox(width: 14),
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
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withValues(
                          alpha: 0.72,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: accent.withValues(alpha: 0.9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsMetaChip extends StatelessWidget {
  const SettingsMetaChip({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsOverviewRow extends StatelessWidget {
  const SettingsOverviewRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 320;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.62),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 104,
                child: Text(
                  label,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.62),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

String initialsFrom(String? fullName) {
  final sanitized = (fullName ?? '').trim();
  if (sanitized.isEmpty) return 'CT';

  return sanitized
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part.substring(0, 1).toUpperCase())
      .join();
}

String formatDate(DateTime date) {
  final local = date.toLocal();
  return '${local.day.toString().padLeft(2, '0')}/${local.month.toString().padLeft(2, '0')}/${local.year}';
}

String notificationsSummary(AppSettingsEntity? settings) {
  final enabled = settings?.notificationsEnabled ?? true;
  if (!enabled) return 'Alertas desativados';
  final reminderHour = settings?.dailyReminderHour ?? 20;
  return 'Alertas ativos • lembrete às ${reminderHour.toString().padLeft(2, '0')}:00';
}

String themeLabel(ThemePreference preference) {
  switch (preference) {
    case ThemePreference.system:
      return 'Sistema';
    case ThemePreference.dark:
      return 'Escuro';
    case ThemePreference.light:
      return 'Claro';
  }
}

List<Widget> buildSpacedChildren(List<Widget> children) {
  if (children.isEmpty) return const [];

  final result = <Widget>[];
  for (var index = 0; index < children.length; index++) {
    result.add(children[index]);
    if (index < children.length - 1) {
      result.add(const SizedBox(height: 10));
    }
  }
  return result;
}
