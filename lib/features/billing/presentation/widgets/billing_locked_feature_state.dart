import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/billing_entities.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/empty_state.dart';
import 'billing_upgrade_modal.dart';

class BillingLockedFeatureState extends ConsumerWidget {
  const BillingLockedFeatureState({
    super.key,
    required this.decision,
    required this.title,
    required this.subtitle,
  });

  final FeatureAccessDecision decision;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: EmptyState(
        title: title,
        subtitle: subtitle,
        action: FilledButton(
          onPressed: () =>
              showBillingUpgradeModal(context, ref, decision: decision),
          child: Text(
            decision.ctaLabel.isEmpty ? 'Ver planos' : decision.ctaLabel,
          ),
        ),
      ),
    );
  }
}
