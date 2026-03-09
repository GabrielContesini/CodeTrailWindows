import 'package:flutter/material.dart';

import '../../../../shared/widgets/animated_reveal.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_logo.dart';

class AuthShowcasePanel extends StatelessWidget {
  const AuthShowcasePanel({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final highlights = const [
      'Trilhas por carreira com módulos, skills e progresso por etapa.',
      'Sessões offline-first com histórico e retomada do ritmo.',
      'Notas, tarefas, revisões e projetos no mesmo workspace.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AnimatedReveal(
          child: AppLogo(
            size: 72,
            showLabel: true,
            subtitle: 'Desktop workspace para evolução real em TI',
          ),
        ),
        const SizedBox(height: 18),
        AnimatedReveal(
          delay: const Duration(milliseconds: 60),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 14),
        AnimatedReveal(
          delay: const Duration(milliseconds: 120),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        ...highlights.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: AnimatedReveal(
              delay: Duration(milliseconds: 170 + (entry.key * 60)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.14),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.84),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 26),
        AnimatedReveal(
          delay: const Duration(milliseconds: 320),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 520;

              return AppCard(
                padding: const EdgeInsets.all(18),
                child: compact
                    ? const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _MiniMetric(
                            label: 'Sessões',
                            value: 'Foco + histórico',
                          ),
                          SizedBox(height: 14),
                          _MiniMetric(
                            label: 'Fluxo',
                            value: 'Estudo + execução',
                          ),
                          SizedBox(height: 14),
                          _MiniMetric(
                            label: 'Desktop',
                            value: 'Windows workspace',
                          ),
                        ],
                      )
                    : const Row(
                        children: [
                          Expanded(
                            child: _MiniMetric(
                              label: 'Sessões',
                              value: 'Foco + histórico',
                            ),
                          ),
                          SizedBox(width: 18),
                          Expanded(
                            child: _MiniMetric(
                              label: 'Fluxo',
                              value: 'Estudo + execução',
                            ),
                          ),
                          SizedBox(width: 18),
                          Expanded(
                            child: _MiniMetric(
                              label: 'Desktop',
                              value: 'Windows workspace',
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

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
            ).colorScheme.onSurface.withValues(alpha: 0.58),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
