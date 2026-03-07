import 'package:flutter/material.dart';

import '../models/page_tutorial.dart';
import 'page_tutorial_banner.dart';

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.actions = const [],
    this.tutorial,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final List<Widget> actions;
  final PageTutorialData? tutorial;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compactHeader = constraints.maxWidth < 1240;

        return Container(
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.74),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: scheme.outline.withValues(alpha: 0.82)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 36,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: Stack(
              children: [
                Positioned(
                  top: -120,
                  right: -80,
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          scheme.primary.withValues(alpha: 0.14),
                          scheme.surface.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    compactHeader ? 20 : 26,
                    compactHeader ? 18 : 22,
                    compactHeader ? 20 : 26,
                    compactHeader ? 20 : 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PageHeader(
                        title: title,
                        subtitle: subtitle,
                        compact: compactHeader,
                        actions: actions,
                      ),
                      const SizedBox(height: 18),
                      Divider(color: scheme.outline.withValues(alpha: 0.62)),
                      if (tutorial != null) ...[
                        const SizedBox(height: 18),
                        PageTutorialBanner(tutorial: tutorial!),
                      ],
                      const SizedBox(height: 18),
                      Expanded(child: child),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    required this.subtitle,
    required this.compact,
    required this.actions,
  });

  final String title;
  final String subtitle;
  final bool compact;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: compact ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: compact
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        if (compact) _HeaderCopy(title: title, subtitle: subtitle),
        if (!compact)
          Expanded(child: _HeaderCopy(title: title, subtitle: subtitle)),
        if (actions.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
              top: compact ? 18 : 0,
              left: compact ? 0 : 18,
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.end,
              children: actions,
            ),
          ),
      ],
    );
  }
}

class _HeaderCopy extends StatelessWidget {
  const _HeaderCopy({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
          ),
          child: Text(
            'Workspace',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.02,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.74),
            ),
          ),
        ),
      ],
    );
  }
}
