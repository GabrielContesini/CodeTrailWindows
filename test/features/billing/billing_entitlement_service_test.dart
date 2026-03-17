import 'package:flutter_test/flutter_test.dart';

import 'package:code_trail_windows/core/services/billing_entitlement_service.dart';
import 'package:code_trail_windows/domain/entities/billing_entities.dart';

void main() {
  const service = BillingEntitlementService();

  test('free blocks premium analytics access', () {
    final snapshot = BillingSnapshot.fallbackFree();

    final decision = service.checkFeatureAccess(
      snapshot,
      BillingFeatureKey.analyticsAccess,
      resourceLabel: 'Analytics',
    );

    expect(decision.allowed, isFalse);
    expect(decision.requiredPlanCode, BillingPlanCode.pro);
  });

  test('free respects project limit', () {
    final snapshot = BillingSnapshot.fallbackFree();

    final decision = service.checkCreationAccess(
      snapshot,
      limitFeatureKey: BillingFeatureKey.projectsLimit,
      usedCount: 3,
      isEditingExisting: false,
      resourceLabel: 'projeto',
    );

    expect(decision.allowed, isFalse);
    expect(decision.limitValue, 3);
  });

  test('founding becomes preferred upgrade target when eligible', () {
    final fallback = BillingSnapshot.fallbackFree();
    final snapshot = BillingSnapshot(
      customer: null,
      subscription: null,
      currentPlan: fallback.currentPlan,
      availablePlans: [
        fallback.currentPlan!,
        const BillingPlanEntity(
          id: 'pro',
          code: BillingPlanCode.pro,
          name: 'Pro',
          description: '',
          priceCents: 2990,
          currency: 'BRL',
          interval: 'month',
          isActive: true,
          isPublic: true,
          trialDays: 7,
          metadata: {},
          createdAt: null,
          updatedAt: null,
        ),
        const BillingPlanEntity(
          id: 'founding',
          code: BillingPlanCode.founding,
          name: 'Founding',
          description: '',
          priceCents: 1990,
          currency: 'BRL',
          interval: 'month',
          isActive: true,
          isPublic: false,
          trialDays: 7,
          metadata: {},
          createdAt: null,
          updatedAt: null,
        ),
      ],
      features: fallback.features,
      payments: const [],
      foundingEligible: true,
      config: const BillingConfigEntity(
        billingProvider: 'stripe',
        trialEnabled: true,
        trialDaysDefault: 7,
        foundingPlanEnabled: true,
      ),
    );

    expect(service.upgradeTarget(snapshot), BillingPlanCode.founding);
  });
}
