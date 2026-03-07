import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/gradient_scaffold.dart';
import 'auth_showcase_panel.dart';

class AuthWorkspaceShell extends StatelessWidget {
  const AuthWorkspaceShell({
    super.key,
    required this.showcaseTitle,
    required this.showcaseSubtitle,
    required this.form,
  });

  final String showcaseTitle;
  final String showcaseSubtitle;
  final Widget form;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1260;
              final shellPadding = constraints.maxWidth >= 1400 ? 32.0 : 24.0;
              final formWidth = constraints.maxWidth >= 1500 ? 500.0 : 460.0;

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(shellPadding),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1520),
                    child: wide
                        ? IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    padding: EdgeInsets.all(shellPadding),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(34),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.outline.withValues(alpha: 0.82),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(
                                            context,
                                          ).colorScheme.primary.withValues(alpha: 0.12),
                                          Theme.of(
                                            context,
                                          ).colorScheme.surface.withValues(alpha: 0.64),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: AuthShowcasePanel(
                                      title: showcaseTitle,
                                      subtitle: showcaseSubtitle,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                SizedBox(width: formWidth, child: form),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline.withValues(alpha: 0.82),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(
                                        context,
                                      ).colorScheme.primary.withValues(alpha: 0.12),
                                      Theme.of(
                                        context,
                                      ).colorScheme.surface.withValues(alpha: 0.64),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: AuthShowcasePanel(
                                  title: showcaseTitle,
                                  subtitle: showcaseSubtitle,
                                ),
                              ),
                              const SizedBox(height: 18),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 560),
                                child: form,
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AuthFormCard extends StatelessWidget {
  const AuthFormCard({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.12),
            ),
            child: Text(
              eyebrow,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 22),
          child,
        ],
      ),
    );
  }
}
