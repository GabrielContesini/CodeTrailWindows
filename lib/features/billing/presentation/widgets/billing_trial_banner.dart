import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/billing_entities.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_card.dart';
import 'billing_plan_badge.dart';

class BillingTrialBanner extends StatelessWidget {
  const BillingTrialBanner({
    super.key,
    required this.snapshot,
    required this.onPrimaryAction,
    required this.primaryLabel,
  });

  final BillingSnapshot snapshot;
  final VoidCallback onPrimaryAction;
  final String primaryLabel;

  @override
  Widget build(BuildContext context) {
    final subscription = snapshot.subscription;
    if (subscription == null &&
        snapshot.currentPlanCode == BillingPlanCode.free &&
        !snapshot.config.trialEnabled) {
      return const SizedBox.shrink();
    }

    final message = snapshot.isTrialing
        ? 'Trial Pro ativo até ${_formatDate(subscription?.trialEndsAt)}.'
        : snapshot.isFounding
        ? 'Você está no Founding com todos os recursos premium liberados.'
        : snapshot.currentPlanCode == BillingPlanCode.pro
        ? 'Plano Pro ativo para liberar recursos premium no workspace.'
        : 'Você está no plano Free. Faça upgrade para liberar recursos premium.';

    return AppCard(
      child: Row(
        children: [
          BillingPlanBadge(planCode: snapshot.currentPlanCode),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            onPressed: onPrimaryAction,
            child: Text(primaryLabel),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime? value) {
  if (value == null) return 'sem data definida';
  return DateFormat('dd/MM/yyyy').format(value);
}
