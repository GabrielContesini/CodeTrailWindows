import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/router/app_router.dart';
import '../../core/utils/icon_mapper.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/settings/application/settings_controller.dart';
import '../models/app_enums.dart';
import '../models/app_view_models.dart';
import 'app_logo.dart';
import 'gradient_scaffold.dart';

class NavigationShellScaffold extends ConsumerStatefulWidget {
  const NavigationShellScaffold({
    super.key,
    required this.child,
    required this.location,
  });

  final Widget child;
  final String location;

  @override
  ConsumerState<NavigationShellScaffold> createState() =>
      _NavigationShellScaffoldState();
}

class _NavigationShellScaffoldState
    extends ConsumerState<NavigationShellScaffold> {
  bool _sidebarCollapsed = false;
  bool _railVisible = true;

  @override
  Widget build(BuildContext context) {
    final items = buildNavigationItems();
    final primaryItems = items
        .where(
          (item) =>
              item.route == AppRoutes.dashboard ||
              item.route == AppRoutes.tracks ||
              item.route == AppRoutes.sessions ||
              item.route == AppRoutes.tasks ||
              item.route == AppRoutes.projects ||
              item.route == AppRoutes.notes,
        )
        .toList();
    final secondaryItems = items
        .where(
          (item) =>
              item.route == AppRoutes.reviews ||
              item.route == AppRoutes.analytics ||
              item.route == AppRoutes.settings,
        )
        .toList();
    final routeMeta = _routeMeta(widget.location);

    return GradientScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final showRailZone = constraints.maxWidth >= 1540;
              final showRail = showRailZone && _railVisible;
              final pagePadding = constraints.maxWidth >= 1700 ? 26.0 : 20.0;

              return Padding(
                padding: EdgeInsets.all(pagePadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: _sidebarCollapsed ? 92 : 286,
                      child: _DesktopSidebar(
                        collapsed: _sidebarCollapsed,
                        location: widget.location,
                        primaryItems: primaryItems,
                        secondaryItems: secondaryItems,
                        onToggleCollapse: () {
                          setState(() {
                            _sidebarCollapsed = !_sidebarCollapsed;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _WorkspaceTopBar(
                            meta: routeMeta,
                            showRailControl: showRailZone,
                            railVisible: _railVisible,
                            onToggleRail: () {
                              setState(() {
                                _railVisible = !_railVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 18),
                          Expanded(child: widget.child),
                        ],
                      ),
                    ),
                    if (showRail) ...[
                      const SizedBox(width: 18),
                      SizedBox(
                        width: 320,
                        child: _WorkspaceRail(
                          location: widget.location,
                          onClose: () {
                            setState(() {
                              _railVisible = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DesktopSidebar extends ConsumerWidget {
  const _DesktopSidebar({
    required this.collapsed,
    required this.location,
    required this.primaryItems,
    required this.secondaryItems,
    required this.onToggleCollapse,
  });

  final bool collapsed;
  final String location;
  final List<AppNavigationItem> primaryItems;
  final List<AppNavigationItem> secondaryItems;
  final VoidCallback onToggleCollapse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        collapsed ? 10 : 16,
        16,
        collapsed ? 10 : 16,
        16,
      ),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.82)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: collapsed
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (collapsed) ...[
            const AppLogo(size: 40),
            const SizedBox(height: 12),
            _CompactSidebarButton(
              tooltip: 'Expandir menu',
              onPressed: onToggleCollapse,
              icon: Icons.keyboard_double_arrow_right_rounded,
            ),
          ] else ...[
            Row(
              children: [
                const Expanded(
                  child: AppLogo(
                    size: 52,
                    showLabel: true,
                    subtitle: 'Workspace desktop',
                  ),
                ),
                const SizedBox(width: 10),
                Tooltip(
                  message: 'Recolher menu',
                  child: IconButton(
                    onPressed: onToggleCollapse,
                    icon: const Icon(Icons.keyboard_double_arrow_left_rounded),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          _SidebarPrimaryAction(collapsed: collapsed),
          const SizedBox(height: 18),
          if (collapsed)
            Container(
              width: 30,
              height: 1,
              margin: const EdgeInsets.only(bottom: 14),
              color: scheme.outline.withValues(alpha: 0.6),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: collapsed
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  if (!collapsed) const _SidebarSectionLabel('Workspace'),
                  ...primaryItems.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: collapsed ? 10 : 8),
                      child: _SidebarNavItem(
                        item: item,
                        collapsed: collapsed,
                        selected: _matchesLocation(item.route, location),
                      ),
                    ),
                  ),
                  SizedBox(height: collapsed ? 12 : 16),
                  if (!collapsed) const _SidebarSectionLabel('Controle'),
                  ...secondaryItems.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: collapsed ? 10 : 8),
                      child: _SidebarNavItem(
                        item: item,
                        collapsed: collapsed,
                        selected: _matchesLocation(item.route, location),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _SidebarProfileCard(collapsed: collapsed),
        ],
      ),
    );
  }
}

class _SidebarPrimaryAction extends StatelessWidget {
  const _SidebarPrimaryAction({required this.collapsed});

  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    if (collapsed) {
      return Tooltip(
        message: 'Nova sessão de foco',
        child: FilledButton(
          onPressed: () => context.go(AppRoutes.newSession),
          style: FilledButton.styleFrom(
            minimumSize: const Size(54, 54),
            maximumSize: const Size(54, 54),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: const Icon(Icons.play_arrow_rounded, size: 24),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: () => context.go(AppRoutes.newSession),
      icon: const Icon(Icons.play_arrow_rounded),
      label: const Text('Iniciar foco'),
    );
  }
}

class _SidebarSectionLabel extends StatelessWidget {
  const _SidebarSectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.54),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  const _SidebarNavItem({
    required this.item,
    required this.collapsed,
    required this.selected,
  });

  final AppNavigationItem item;
  final bool collapsed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = selected
        ? scheme.onPrimary
        : scheme.onSurface.withValues(alpha: 0.82);

    final content = collapsed
        ? AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: selected
                  ? scheme.primary.withValues(alpha: 0.88)
                  : scheme.surface.withValues(alpha: 0.26),
              border: Border.all(
                color: selected
                    ? scheme.primary.withValues(alpha: 0.12)
                    : scheme.outline.withValues(alpha: 0.55),
              ),
            ),
            child: Icon(
              IconMapper.fromKey(item.iconKey),
              color: foreground,
              size: 20,
            ),
          )
        : AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selected
                  ? scheme.primary.withValues(alpha: 0.88)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Icon(
                  IconMapper.fromKey(item.iconKey),
                  color: foreground,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );

    return Tooltip(
      message: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => context.go(item.route),
          child: content,
        ),
      ),
    );
  }
}

class _SidebarProfileCard extends ConsumerWidget {
  const _SidebarProfileCard({required this.collapsed});

  final bool collapsed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).asData?.value;
    final goal = ref.watch(userGoalProvider).asData?.value;
    final session = ref.watch(authSessionProvider).asData?.value;
    final displayName = profile?.fullName ?? 'Seu workspace';
    final email = session?.user.email ?? profile?.email ?? 'Sem e-mail';
    final initials = _initials(displayName);

    if (collapsed) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.72),
          ),
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AvatarBadge(initials: initials, size: 42),
            const SizedBox(height: 10),
            _CompactSidebarButton(
              tooltip: 'Configurações',
              onPressed: () => context.go(AppRoutes.settings),
              icon: Icons.settings_outlined,
            ),
            const SizedBox(height: 8),
            _CompactSidebarButton(
              tooltip: 'Encerrar sessão',
              onPressed: () => _signOut(context, ref),
              icon: Icons.logout_rounded,
            ),
          ],
        ),
      );
    }

    final goalLabel = goal?.primaryGoal.trim().isNotEmpty == true
        ? goal!.primaryGoal
        : 'Defina uma meta principal para orientar o próximo ciclo.';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outline.withValues(alpha: 0.82),
        ),
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AvatarBadge(initials: initials, size: 46),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            goalLabel,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.settings),
                  icon: const Icon(Icons.settings_outlined, size: 18),
                  label: const Text('Conta'),
                ),
              ),
              const SizedBox(width: 10),
              Tooltip(
                message: 'Encerrar sessão',
                child: IconButton(
                  onPressed: () => _signOut(context, ref),
                  icon: const Icon(Icons.logout_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }
}

class _CompactSidebarButton extends StatelessWidget {
  const _CompactSidebarButton({
    required this.tooltip,
    required this.onPressed,
    required this.icon,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 42,
        height: 42,
        child: IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: scheme.surface.withValues(alpha: 0.28),
            side: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
          ),
          icon: Icon(icon, size: 20),
        ),
      ),
    );
  }
}

class _WorkspaceTopBar extends StatelessWidget {
  const _WorkspaceTopBar({
    required this.meta,
    required this.showRailControl,
    required this.railVisible,
    required this.onToggleRail,
  });

  final _RouteMeta meta;
  final bool showRailControl;
  final bool railVisible;
  final VoidCallback onToggleRail;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dateLabel = DateFormat('EEE, dd MMM • HH:mm').format(DateTime.now());

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 980;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: scheme.outline.withValues(alpha: 0.82)),
          ),
          child: Flex(
            direction: compact ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: compact
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (compact)
                _TopBarCopy(
                  dateLabel: dateLabel,
                  title: meta.title,
                  subtitle: meta.subtitle,
                ),
              if (!compact)
                Expanded(
                  child: _TopBarCopy(
                    dateLabel: dateLabel,
                    title: meta.title,
                    subtitle: meta.subtitle,
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(
                  top: compact ? 16 : 0,
                  left: compact ? 0 : 16,
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (showRailControl)
                      Tooltip(
                        message: railVisible
                            ? 'Ocultar painel lateral'
                            : 'Mostrar painel lateral',
                        child: IconButton(
                          onPressed: onToggleRail,
                          icon: Icon(
                            railVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                    OutlinedButton.icon(
                      onPressed: () => context.go(AppRoutes.notes),
                      icon: const Icon(Icons.note_alt_outlined, size: 18),
                      label: const Text('Notas'),
                    ),
                    FilledButton.icon(
                      onPressed: () => context.go(AppRoutes.newSession),
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: const Text('Nova sessão'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBarCopy extends StatelessWidget {
  const _TopBarCopy({
    required this.dateLabel,
    required this.title,
    required this.subtitle,
  });

  final String dateLabel;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateLabel,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: scheme.onSurface.withValues(alpha: 0.54),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _WorkspaceRail extends ConsumerWidget {
  const _WorkspaceRail({
    required this.location,
    required this.onClose,
  });

  final String location;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).asData?.value;
    final goal = ref.watch(userGoalProvider).asData?.value;
    final settings = ref.watch(appSettingsProvider).asData?.value;
    final session = ref.watch(authSessionProvider).asData?.value;
    final scheme = Theme.of(context).colorScheme;
    final meta = _routeMeta(location);
    final displayName = profile?.fullName ?? 'CodeTrail';
    final email = session?.user.email ?? profile?.email ?? 'Sem e-mail';
    final initials = _initials(displayName);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.82)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Painel lateral',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _RailBlock(
              title: 'Conta conectada',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _AvatarBadge(initials: initials, size: 50),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoPill(
                        label:
                            'Tema ${_themePreferenceLabel(settings?.themePreference ?? ThemePreference.dark)}',
                        icon: Icons.palette_outlined,
                      ),
                      _InfoPill(
                        label: (settings?.notificationsEnabled ?? true)
                            ? 'Alertas ativos'
                            : 'Alertas pausados',
                        icon: Icons.notifications_active_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _RailBlock(
              title: 'Ritmo atual',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MetricLine(
                    label: 'Foco principal',
                    value: goal?.focusType.label ?? 'Ainda não definido',
                  ),
                  const SizedBox(height: 10),
                  _MetricLine(
                    label: 'Meta',
                    value: goal?.primaryGoal ??
                        'Conclua o onboarding para definir.',
                  ),
                  const SizedBox(height: 10),
                  _MetricLine(
                    label: 'Cadência semanal',
                    value: goal == null
                        ? 'Sem rotina definida'
                        : '${goal.hoursPerDay}h por dia • ${goal.daysPerWeek} dias/semana',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _RailBlock(
              title: 'Contexto da página',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meta.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    meta.subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _RailBlock(
              title: 'Atalhos',
              child: Column(
                children: [
                  _ShortcutTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Conta',
                    subtitle: 'Ajustar perfil, trilha e preferências.',
                    onTap: () => context.go(AppRoutes.settingsAccount),
                  ),
                  const SizedBox(height: 8),
                  _ShortcutTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Ajuda',
                    subtitle: 'Revisar FAQs e tutoriais do workspace.',
                    onTap: () => context.go(AppRoutes.settingsHelp),
                  ),
                  const SizedBox(height: 8),
                  _ShortcutTile(
                    icon: Icons.add_task_rounded,
                    title: 'Nova tarefa',
                    subtitle: 'Registrar o próximo passo da sua trilha.',
                    onTap: () => context.go(AppRoutes.tasks),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RailBlock extends StatelessWidget {
  const _RailBlock({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outline.withValues(alpha: 0.82),
        ),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.38),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.56),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.82),
          ),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.82),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.52),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({required this.initials, required this.size});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.92),
            scheme.secondary.withValues(alpha: 0.90),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.black.withValues(alpha: 0.74),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _RouteMeta {
  const _RouteMeta({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

_RouteMeta _routeMeta(String location) {
  if (location == AppRoutes.dashboard) {
    return const _RouteMeta(
      title: 'Dashboard',
      subtitle:
          'Resumo executivo do estudo, da execução e das próximas ações.',
    );
  }
  if (location == AppRoutes.tracks ||
      location.startsWith(AppRoutes.trackDetails)) {
    return const _RouteMeta(
      title: 'Trilhas',
      subtitle: 'Roadmaps, skills e módulos para orientar sua evolução.',
    );
  }
  if (location == AppRoutes.sessions || location == AppRoutes.newSession) {
    return const _RouteMeta(
      title: 'Sessões',
      subtitle: 'Cronômetro, histórico e blocos de foco com contexto real.',
    );
  }
  if (location == AppRoutes.tasks) {
    return const _RouteMeta(
      title: 'Tarefas',
      subtitle:
          'Transforme planejamento em execução com prazos e prioridade.',
    );
  }
  if (location == AppRoutes.reviews) {
    return const _RouteMeta(
      title: 'Revisões',
      subtitle: 'Retenção do conteúdo com ciclos D+1, D+7, D+15 e D+30.',
    );
  }
  if (location == AppRoutes.projects ||
      location.startsWith(AppRoutes.projectDetails)) {
    return const _RouteMeta(
      title: 'Projetos',
      subtitle: 'Portfólio prático com etapas, links e ritmo de entrega.',
    );
  }
  if (location == AppRoutes.notes) {
    return const _RouteMeta(
      title: 'Notas',
      subtitle: 'Base viva de resumos, comandos, snippets e checkpoints.',
    );
  }
  if (location == AppRoutes.analytics) {
    return const _RouteMeta(
      title: 'Analytics',
      subtitle: 'Consistência, volume e evolução da trilha em números.',
    );
  }
  if (location == AppRoutes.settings ||
      location.startsWith('${AppRoutes.settings}/')) {
    return const _RouteMeta(
      title: 'Configurações',
      subtitle: 'Conta, preferências e manutenção do workspace desktop.',
    );
  }

  return const _RouteMeta(
    title: 'CodeTrail',
    subtitle: 'Workspace para organizar estudos, prática e evolução em TI.',
  );
}

bool _matchesLocation(String route, String location) {
  if (route == AppRoutes.dashboard) {
    return location == route;
  }
  if (route == AppRoutes.tracks) {
    return location == route || location.startsWith(AppRoutes.trackDetails);
  }
  if (route == AppRoutes.projects) {
    return location == route || location.startsWith(AppRoutes.projectDetails);
  }
  if (route == AppRoutes.settings) {
    return location == route || location.startsWith('${AppRoutes.settings}/');
  }
  return location == route;
}

String _initials(String value) {
  final parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return 'CT';
  if (parts.length == 1) {
    return parts.first
        .substring(0, parts.first.length.clamp(1, 2))
        .toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

String _themePreferenceLabel(ThemePreference preference) {
  return switch (preference) {
    ThemePreference.dark => 'escuro',
    ThemePreference.light => 'claro',
    ThemePreference.system => 'do sistema',
  };
}
