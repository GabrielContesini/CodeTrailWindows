import '../entities/billing_entities.dart';

abstract class BillingRepository {
  Future<BillingSnapshot?> loadCachedSnapshot(String userId);
  Future<BillingSnapshot> refreshSnapshot(String userId);
  Future<BillingCheckoutSession> createCheckout({
    required String userId,
    required BillingPlanCode planCode,
  });
  Future<String> createPortalSession(String userId);
  Future<BillingSnapshot> cancelSubscription(String userId);
  Future<BillingSnapshot> syncSubscription(
    String userId, {
    String? gatewaySubscriptionId,
    String? paymentId,
  });
}
