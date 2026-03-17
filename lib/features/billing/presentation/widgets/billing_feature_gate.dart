import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/billing_entities.dart';
import '../../application/billing_controller.dart';
import 'billing_locked_feature_state.dart';

class BillingFeatureGate extends ConsumerWidget {
  const BillingFeatureGate({
    super.key,
    required this.featureKey,
    required this.lockedTitle,
    required this.lockedSubtitle,
    required this.child,
  });

  final BillingFeatureKey featureKey;
  final String lockedTitle;
  final String lockedSubtitle;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billingAsync = ref.watch(billingControllerProvider);
    if (billingAsync.isLoading && !billingAsync.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }

    final decision = ref.watch(billingFeatureAccessProvider(featureKey));
    if (decision.allowed) {
      return child;
    }

    return BillingLockedFeatureState(
      decision: decision,
      title: lockedTitle,
      subtitle: lockedSubtitle,
    );
  }
}
