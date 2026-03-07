import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/services/service_providers.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/page_frame.dart';
import 'widgets/settings_common.dart';

class SettingsHelpScreen extends ConsumerWidget {
  const SettingsHelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageFrame(
      title: 'Ajuda',
      subtitle: 'Suporte rápido para tutoriais, integrações e dúvidas comuns.',
      actions: [
        FilledButton.tonalIcon(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
          label: const Text('Voltar'),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1120;

          final supportCard = AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ações rápidas',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Atalhos úteis para restaurar a experiência do app.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.68),
                  ),
                ),
                const SizedBox(height: 16),
                ...buildSpacedChildren([
                  SettingsActionTile(
                    icon: Icons.lightbulb_outline_rounded,
                    title: 'Reexibir tutoriais',
                    subtitle: 'Mostra novamente os guias contextuais das telas.',
                    onTap: () async {
                      await ref.read(tutorialServiceProvider).resetTutorials();
                      if (context.mounted) {
                        context.showAppSnackBar('Tutoriais redefinidos.');
                      }
                    },
                  ),
                  SettingsActionTile(
                    icon: Icons.key_off_rounded,
                    title: 'Limpar token do GitHub',
                    subtitle: 'Remove o token salvo localmente no tablet.',
                    onTap: () async {
                      await ref.read(githubServiceProvider).clearToken();
                      if (context.mounted) {
                        context.showAppSnackBar('Token do GitHub removido.');
                      }
                    },
                  ),
                  SettingsActionTile(
                    icon: Icons.sync_problem_rounded,
                    title: 'Estado da sincronização',
                    subtitle:
                        'O app usa fila local e sincroniza quando houver conexão.',
                    onTap: () => context.push(AppRoutes.settingsSync),
                  ),
                ]),
              ],
            ),
          );

          final faqCard = AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perguntas frequentes',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Respostas rápidas para os pontos mais comuns do fluxo.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.68),
                  ),
                ),
                const SizedBox(height: 16),
                const _FaqTile(
                  question: 'Como o app funciona sem internet?',
                  answer:
                      'Alterações são gravadas primeiro no banco local Drift. Quando a conexão volta, o repositório envia a fila pendente para o Supabase.',
                ),
                const SizedBox(height: 10),
                const _FaqTile(
                  question: 'Como importar projetos do GitHub?',
                  answer:
                      'Na tela de Projetos, escolha importar via GitHub, informe o token pessoal e selecione os repositórios que deseja trazer para o app.',
                ),
                const SizedBox(height: 10),
                const _FaqTile(
                  question: 'Por que recebo alertas de revisão?',
                  answer:
                      'O sistema agenda revisões em D+1, D+7, D+15 e D+30 para reforçar a retenção dos conteúdos estudados.',
                ),
              ],
            ),
          );

          final feedbackCard = AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Canal de feedback',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'O suporte dedicado entra em uma próxima build. Por enquanto, use este centro para manutenção local.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.68),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: const Color(0xFF0E121A),
                    border: Border.all(
                      color: context.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Próximo passo sugerido',
                        style: context.textTheme.labelLarge?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Se algo travar, gere uma nova build e valide o comportamento com o fluxo de login e sincronização.',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

          return ListView(
            children: [
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: supportCard),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        children: [
                          faqCard,
                          const SizedBox(height: 14),
                          feedbackCard,
                        ],
                      ),
                    ),
                  ],
                )
              else ...[
                supportCard,
                const SizedBox(height: 14),
                faqCard,
                const SizedBox(height: 14),
                feedbackCard,
              ],
            ],
          );
        },
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(answer, style: context.textTheme.bodySmall),
        ],
      ),
    );
  }
}
