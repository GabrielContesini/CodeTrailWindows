import '../../domain/entities/billing_entities.dart';

class BillingEntitlementService {
  const BillingEntitlementService();

  FeatureAccessDecision checkFeatureAccess(
    BillingSnapshot? snapshot,
    BillingFeatureKey featureKey, {
    required String resourceLabel,
  }) {
    final billing = snapshot ?? BillingSnapshot.fallbackFree();
    final entitlement = billing.entitlementFor(featureKey.key);
    if (entitlement.enabled) {
      return FeatureAccessDecision(
        allowed: true,
        featureKey: featureKey.key,
        message: '$resourceLabel liberado no seu plano atual.',
        ctaLabel: '',
        currentPlanCode: billing.currentPlanCode,
        requiredPlanCode: billing.currentPlanCode,
      );
    }

    final requiredPlan = _requiredPlanFor(featureKey);
    return FeatureAccessDecision(
      allowed: false,
      featureKey: featureKey.key,
      message: _lockedMessage(
        billing,
        featureKey,
        resourceLabel: resourceLabel,
      ),
      ctaLabel: 'Fazer upgrade',
      currentPlanCode: billing.currentPlanCode,
      requiredPlanCode: requiredPlan,
    );
  }

  FeatureAccessDecision checkCreationAccess(
    BillingSnapshot? snapshot, {
    BillingFeatureKey? accessFeatureKey,
    BillingFeatureKey? limitFeatureKey,
    required int usedCount,
    required bool isEditingExisting,
    required String resourceLabel,
  }) {
    final billing = snapshot ?? BillingSnapshot.fallbackFree();

    if (accessFeatureKey != null) {
      final featureDecision = checkFeatureAccess(
        billing,
        accessFeatureKey,
        resourceLabel: resourceLabel,
      );
      if (!featureDecision.allowed) {
        return featureDecision;
      }
    }

    if (isEditingExisting || limitFeatureKey == null) {
      return FeatureAccessDecision(
        allowed: true,
        featureKey: limitFeatureKey?.key ?? accessFeatureKey?.key ?? '',
        message: '$resourceLabel permitido.',
        ctaLabel: '',
        currentPlanCode: billing.currentPlanCode,
        requiredPlanCode: billing.currentPlanCode,
      );
    }

    final limit = billing.limitFor(limitFeatureKey);
    if (limit != null && usedCount >= limit) {
      return FeatureAccessDecision(
        allowed: false,
        featureKey: limitFeatureKey.key,
        message:
            'Você atingiu o limite de $limit ${_pluralize(resourceLabel, limit)} do plano ${_planLabel(billing.currentPlanCode)}.',
        ctaLabel: 'Ver planos',
        currentPlanCode: billing.currentPlanCode,
        requiredPlanCode: BillingPlanCode.pro,
        limitValue: limit,
        usedCount: usedCount,
      );
    }

    return FeatureAccessDecision(
      allowed: true,
      featureKey: limitFeatureKey.key,
      message: '$resourceLabel permitido.',
      ctaLabel: '',
      currentPlanCode: billing.currentPlanCode,
      requiredPlanCode: billing.currentPlanCode,
      limitValue: limit,
      usedCount: usedCount,
    );
  }

  BillingPlanCode upgradeTarget(BillingSnapshot snapshot) {
    if (snapshot.foundingEligible && snapshot.foundingPlan != null) {
      return BillingPlanCode.founding;
    }
    return BillingPlanCode.pro;
  }
}

BillingPlanCode _requiredPlanFor(BillingFeatureKey featureKey) {
  if (featureKey == BillingFeatureKey.foundingBadge) {
    return BillingPlanCode.founding;
  }
  return BillingPlanCode.pro;
}

String _lockedMessage(
  BillingSnapshot snapshot,
  BillingFeatureKey featureKey, {
  required String resourceLabel,
}) {
  if (featureKey == BillingFeatureKey.analyticsAccess) {
    return 'Analytics avançado exige upgrade para o Pro.';
  }
  if (featureKey == BillingFeatureKey.flashcardsAccess) {
    return 'Flashcards completos estão disponíveis no Pro e no Founding.';
  }
  if (featureKey == BillingFeatureKey.mindMapsAccess) {
    return 'Mind maps completos estão disponíveis no Pro e no Founding.';
  }
  if (featureKey == BillingFeatureKey.aiGeneration) {
    return 'Automação por IA local exige upgrade para liberar este fluxo.';
  }
  return '$resourceLabel exige upgrade a partir do plano ${_planLabel(_requiredPlanFor(featureKey))}.';
}

String _planLabel(BillingPlanCode planCode) {
  switch (planCode) {
    case BillingPlanCode.pro:
      return 'Pro';
    case BillingPlanCode.founding:
      return 'Founding';
    case BillingPlanCode.free:
      return 'Free';
  }
}

String _pluralize(String resourceLabel, int count) {
  if (count == 1) return resourceLabel;
  return '$resourceLabel${resourceLabel.endsWith('s') ? '' : 's'}';
}
