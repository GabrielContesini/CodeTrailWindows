import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entities/billing_entities.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/billing_controller.dart';
import 'billing_plan_badge.dart';

Future<void> showBillingUpgradeModal(
  BuildContext context,
  WidgetRef ref, {
  FeatureAccessDecision? decision,
}) async {
  final snapshot = ref.read(currentBillingSnapshotProvider);
  final upgradePlans = snapshot.availablePlans
      .where((plan) => plan.code != BillingPlanCode.free)
      .where((plan) => plan.code != snapshot.currentPlanCode)
      .toList();

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      var loadingPlanCode = '';

      return StatefulBuilder(
        builder: (sheetContext, setState) {
          Future<void> startCheckout(BillingPlanEntity plan) async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            setState(() => loadingPlanCode = plan.code.name);
            try {
              final session = await ref
                  .read(billingControllerProvider.notifier)
                  .createCheckout(plan.code);
              if (sheetContext.mounted) {
                Navigator.of(sheetContext).pop();
              }
              final checkoutUrl = session.checkoutUrl;
              if (checkoutUrl == null || checkoutUrl.isEmpty) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Checkout criado, mas sem link retornado pelo Stripe.',
                    ),
                  ),
                );
                return;
              }
              await launchUrl(
                Uri.parse(checkoutUrl),
                mode: LaunchMode.externalApplication,
              );
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text(
                    'Finalize o checkout no Stripe e depois volte para sincronizar o status.',
                  ),
                ),
              );
            } catch (error) {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text(error.toString())),
              );
            } finally {
              if (sheetContext.mounted) {
                setState(() => loadingPlanCode = '');
              }
            }
          }

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
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: AppCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upgrade do plano',
                          style: sheetContext.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          decision?.message ??
                              'Escolha um plano pago para liberar recursos premium e aumentar os limites internos do app.',
                          style: sheetContext.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 18),
                        ...upgradePlans.map(
                          (plan) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Theme.of(
                                    sheetContext,
                                  ).colorScheme.outline,
                                ),
                              ),
                              child: Row(
                                children: [
                                  BillingPlanBadge(planCode: plan.code),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plan.name,
                                          style: sheetContext
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(plan.description),
                                        const SizedBox(height: 6),
                                        Text(
                                          _priceLabel(plan),
                                          style: sheetContext
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  FilledButton(
                                    onPressed: loadingPlanCode.isNotEmpty
                                        ? null
                                        : () => startCheckout(plan),
                                    child: Text(
                                      loadingPlanCode == plan.code.name
                                          ? 'Abrindo...'
                                          : 'Assinar',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (upgradePlans.isEmpty)
                          Text(
                            'Nenhum plano pago disponível para esta conta no momento.',
                            style: sheetContext.textTheme.bodyMedium,
                          ),
                      ],
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

String _priceLabel(BillingPlanEntity plan) {
  if (plan.priceCents <= 0) {
    return 'Grátis';
  }
  final amount = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  ).format(plan.priceCents / 100);
  return '$amount/${plan.interval == 'year' ? 'ano' : 'mês'}';
}
