import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/services/service_providers.dart';
import '../../../domain/entities/billing_entities.dart';
import '../../auth/application/auth_controller.dart';

final billingControllerProvider =
    AsyncNotifierProvider<BillingController, BillingSnapshot>(
      BillingController.new,
    );

final currentBillingSnapshotProvider = Provider<BillingSnapshot>((ref) {
  return ref.watch(billingControllerProvider).asData?.value ??
      BillingSnapshot.fallbackFree();
});

final billingFeatureAccessProvider =
    Provider.family<FeatureAccessDecision, BillingFeatureKey>((
      ref,
      featureKey,
    ) {
      final snapshot = ref.watch(currentBillingSnapshotProvider);
      final service = ref.watch(billingEntitlementServiceProvider);
      return service.checkFeatureAccess(
        snapshot,
        featureKey,
        resourceLabel: _resourceLabelFor(featureKey),
      );
    });

class BillingController extends AsyncNotifier<BillingSnapshot> {
  @override
  FutureOr<BillingSnapshot> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return BillingSnapshot.fallbackFree();

    final repository = ref.watch(billingRepositoryProvider);
    final cached = await repository.loadCachedSnapshot(userId);
    if (cached != null) {
      unawaited(refresh(silent: true));
      return cached;
    }

    return repository.refreshSnapshot(userId);
  }

  Future<BillingSnapshot> refresh({bool silent = false}) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return BillingSnapshot.fallbackFree();

    if (!silent) {
      state = const AsyncLoading();
    }

    final nextState = await AsyncValue.guard(
      () => ref.read(billingRepositoryProvider).refreshSnapshot(userId),
    );
    state = nextState;
    return nextState.requireValue;
  }

  Future<BillingCheckoutSession> createCheckout(
    BillingPlanCode planCode,
  ) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      throw const AppException('Faça login para iniciar a cobrança.');
    }

    final previous = state.asData?.value ?? BillingSnapshot.fallbackFree();
    state = AsyncValue.data(previous);

    final session = await ref
        .read(billingRepositoryProvider)
        .createCheckout(userId: userId, planCode: planCode);
    state = AsyncValue.data(session.snapshot);
    return session;
  }

  Future<String> createPortalSession() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      throw const AppException('Faça login para gerenciar a assinatura.');
    }

    return ref.read(billingRepositoryProvider).createPortalSession(userId);
  }

  Future<BillingSnapshot> cancelSubscription() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      throw const AppException('Faça login para gerenciar a assinatura.');
    }

    final next = await ref
        .read(billingRepositoryProvider)
        .cancelSubscription(userId);
    state = AsyncValue.data(next);
    return next;
  }

  Future<BillingSnapshot> syncSubscription({
    String? gatewaySubscriptionId,
    String? paymentId,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      throw const AppException('Faça login para sincronizar a assinatura.');
    }

    final next = await ref
        .read(billingRepositoryProvider)
        .syncSubscription(
          userId,
          gatewaySubscriptionId: gatewaySubscriptionId,
          paymentId: paymentId,
        );
    state = AsyncValue.data(next);
    return next;
  }
}

String _resourceLabelFor(BillingFeatureKey featureKey) {
  switch (featureKey) {
    case BillingFeatureKey.flashcardsAccess:
      return 'Flashcards';
    case BillingFeatureKey.mindMapsAccess:
      return 'Mind maps';
    case BillingFeatureKey.analyticsAccess:
      return 'Analytics';
    case BillingFeatureKey.aiGeneration:
      return 'Geração assistida';
    case BillingFeatureKey.notesAccess:
      return 'Notas';
    case BillingFeatureKey.notesLimit:
      return 'nota';
    case BillingFeatureKey.projectsLimit:
      return 'projeto';
    case BillingFeatureKey.flashcardsLimit:
      return 'flashcard';
    case BillingFeatureKey.mindMapsLimit:
      return 'mind map';
    case BillingFeatureKey.foundingBadge:
      return 'Badge Founding';
  }
}
