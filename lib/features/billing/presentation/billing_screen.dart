import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/billing_entities.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/page_frame.dart';
import '../application/billing_controller.dart';
import 'widgets/billing_plan_badge.dart';
import 'widgets/billing_trial_banner.dart';
import 'widgets/billing_upgrade_modal.dart';

class BillingScreen extends ConsumerWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billingAsync = ref.watch(billingControllerProvider);

    return PageFrame(
      title: 'Assinatura',
      subtitle:
          'Plano atual, status do ciclo, histórico de pagamentos e ações de upgrade dentro do app.',
      actions: [
        OutlinedButton.icon(
          onPressed: billingAsync.isLoading
              ? null
              : () => ref.read(billingControllerProvider.notifier).refresh(),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Atualizar'),
        ),
      ],
      child: billingAsync.when(
        data: (snapshot) => _BillingContent(snapshot: snapshot),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Não foi possível carregar o billing',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.read(billingControllerProvider.notifier).refresh(),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BillingContent extends ConsumerWidget {
  const _BillingContent({required this.snapshot});

  final BillingSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = snapshot.subscription;
    final currentPlan = snapshot.currentPlan;
    final payments = snapshot.payments;
    final enabledFeatures = snapshot.features
        .where((item) => item.enabled)
        .toList();

    Future<void> launchIfAvailable(String? url, String fallback) async {
      if (url == null || url.isEmpty) {
        context.showAppSnackBar(fallback);
        return;
      }
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }

    return ListView(
      children: [
        BillingTrialBanner(
          snapshot: snapshot,
          onPrimaryAction: () => showBillingUpgradeModal(context, ref),
          primaryLabel: snapshot.currentPlanCode == BillingPlanCode.free
              ? 'Ver upgrade'
              : 'Revisar plano',
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            SizedBox(
              width: 420,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BillingPlanBadge(planCode: snapshot.currentPlanCode),
                        const SizedBox(width: 10),
                        if (snapshot.isFounding)
                          const BillingPlanBadge(
                            planCode: BillingPlanCode.founding,
                            label: 'Badge especial',
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      currentPlan?.name ?? 'Plano Free',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currentPlan?.description ?? 'Acesso básico ao produto.',
                    ),
                    const SizedBox(height: 14),
                    _MetricRow(
                      label: 'Status',
                      value: _statusLabel(subscription?.status),
                    ),
                    _MetricRow(
                      label: 'Ciclo',
                      value: subscription?.billingCycle == 'year'
                          ? 'Anual'
                          : 'Mensal',
                    ),
                    _MetricRow(
                      label: 'Início',
                      value: _formatDate(subscription?.startedAt),
                    ),
                    _MetricRow(
                      label: 'Fim do período',
                      value: _formatDate(subscription?.currentPeriodEnd),
                    ),
                    _MetricRow(
                      label: 'Fim do trial',
                      value: _formatDate(subscription?.trialEndsAt),
                    ),
                    if (subscription?.isInGracePeriod ?? false)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          'A assinatura está em grace period. Sincronize o status após regularizar o pagamento no Stripe.',
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 420,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ações',
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        if (snapshot.currentPlanCode == BillingPlanCode.free)
                          FilledButton.icon(
                            onPressed: () =>
                                showBillingUpgradeModal(context, ref),
                            icon: const Icon(Icons.workspace_premium_rounded),
                            label: const Text('Assinar Pro'),
                          ),
                        if (snapshot.currentPlanCode == BillingPlanCode.free &&
                            snapshot.foundingEligible)
                          FilledButton.tonalIcon(
                            onPressed: () => showBillingUpgradeModal(
                              context,
                              ref,
                              decision: const FeatureAccessDecision(
                                allowed: false,
                                featureKey: 'founding',
                                message:
                                    'Seu usuário está elegível ao plano Founding.',
                                ctaLabel: 'Migrar para Founding',
                                currentPlanCode: BillingPlanCode.free,
                                requiredPlanCode: BillingPlanCode.founding,
                              ),
                            ),
                            icon: const Icon(Icons.auto_awesome_rounded),
                            label: const Text('Migrar para Founding'),
                          ),
                        OutlinedButton.icon(
                          onPressed: () => ref
                              .read(billingControllerProvider.notifier)
                              .syncSubscription(),
                          icon: const Icon(Icons.sync_rounded),
                          label: const Text('Sincronizar status'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            try {
                              final url = await ref
                                  .read(billingControllerProvider.notifier)
                                  .createPortalSession();
                              if (!context.mounted) return;
                              await launchIfAvailable(
                                url,
                                'Nenhum link de gerenciamento disponível ainda.',
                              );
                            } catch (error) {
                              if (context.mounted) {
                                context.showAppSnackBar(error.toString());
                              }
                            }
                          },
                          icon: const Icon(Icons.open_in_new_rounded),
                          label: const Text('Gerenciar assinatura'),
                        ),
                        if (snapshot.currentPlanCode != BillingPlanCode.free)
                          FilledButton.tonalIcon(
                            onPressed: () async {
                              try {
                                await ref
                                    .read(billingControllerProvider.notifier)
                                    .cancelSubscription();
                                if (context.mounted) {
                                  context.showAppSnackBar(
                                    'Cancelamento solicitado. O acesso premium segue até o fim do período atual.',
                                  );
                                }
                              } catch (error) {
                                if (context.mounted) {
                                  context.showAppSnackBar(error.toString());
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.cancel_schedule_send_rounded,
                            ),
                            label: const Text('Cancelar renovação'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Provider ativo: ${snapshot.config.billingProvider}',
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recursos liberados',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: enabledFeatures
                    .map(
                      (item) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: context.colorScheme.outline,
                          ),
                        ),
                        child: Text(_featureLabel(item)),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Histórico de pagamentos',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              if (payments.isEmpty)
                const Text('Nenhum pagamento registrado ainda para esta conta.')
              else
                ...payments.take(8).map(
                  (payment) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: context.colorScheme.outline),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _paymentAmount(payment),
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${payment.status.toUpperCase()} • ${_formatDate(payment.paidAt ?? payment.createdAt)}',
                                  style: context.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => launchIfAvailable(
                              payment.invoiceUrl ?? payment.receiptUrl,
                              'Nenhum link de comprovante disponível para este pagamento.',
                            ),
                            child: const Text('Abrir'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label)),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

String _statusLabel(BillingSubscriptionStatus? status) {
  switch (status) {
    case BillingSubscriptionStatus.trialing:
      return 'Em trial';
    case BillingSubscriptionStatus.active:
      return 'Ativa';
    case BillingSubscriptionStatus.pastDue:
      return 'Pendente';
    case BillingSubscriptionStatus.unpaid:
      return 'Inadimplente';
    case BillingSubscriptionStatus.canceled:
      return 'Cancelada';
    case BillingSubscriptionStatus.expired:
      return 'Expirada';
    case BillingSubscriptionStatus.incomplete:
      return 'Checkout pendente';
    case null:
      return 'Free';
  }
}

String _formatDate(DateTime? value) {
  if (value == null) return 'Não informado';
  return DateFormat('dd/MM/yyyy').format(value);
}

String _featureLabel(BillingFeatureEntitlement item) {
  final labels = <String, String>{
    'notes_access': 'Notas',
    'flashcards_access': 'Flashcards',
    'mind_maps_access': 'Mind maps',
    'analytics_access': 'Analytics',
    'ai_generation': 'Geração assistida',
    'notes_limit': 'Limite de notas: ${item.limitValue ?? 'livre'}',
    'projects_limit': 'Limite de projetos: ${item.limitValue ?? 'livre'}',
    'flashcards_limit': 'Limite de flashcards: ${item.limitValue ?? 'livre'}',
    'mind_maps_limit': 'Limite de mind maps: ${item.limitValue ?? 'livre'}',
    'founding_badge': 'Badge Founding',
  };
  return labels[item.featureKey] ?? item.featureKey;
}

String _paymentAmount(BillingPaymentEntity payment) {
  return NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  ).format(payment.amountCents / 100);
}
