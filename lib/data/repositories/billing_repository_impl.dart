import '../../core/services/billing_snapshot_cache_service.dart';
import '../../domain/entities/billing_entities.dart';
import '../../domain/repositories/billing_repository.dart';
import '../remote/billing_remote_data_source.dart';

class BillingRepositoryImpl implements BillingRepository {
  const BillingRepositoryImpl({
    required BillingRemoteDataSource remoteDataSource,
    required BillingSnapshotCacheService cacheService,
  }) : _remoteDataSource = remoteDataSource,
       _cacheService = cacheService;

  final BillingRemoteDataSource _remoteDataSource;
  final BillingSnapshotCacheService _cacheService;

  @override
  Future<BillingSnapshot?> loadCachedSnapshot(String userId) {
    return _cacheService.read(userId);
  }

  @override
  Future<BillingSnapshot> refreshSnapshot(String userId) async {
    final snapshot = await _remoteDataSource.fetchSnapshot();
    await _cacheService.write(userId, snapshot);
    return snapshot;
  }

  @override
  Future<BillingCheckoutSession> createCheckout({
    required String userId,
    required BillingPlanCode planCode,
  }) async {
    final session = await _remoteDataSource.createCheckout(planCode);
    await _cacheService.write(userId, session.snapshot);
    return session;
  }

  @override
  Future<String> createPortalSession(String userId) {
    return _remoteDataSource.createPortalSession();
  }

  @override
  Future<BillingSnapshot> cancelSubscription(String userId) async {
    final snapshot = await _remoteDataSource.cancelSubscription();
    await _cacheService.write(userId, snapshot);
    return snapshot;
  }

  @override
  Future<BillingSnapshot> syncSubscription(
    String userId, {
    String? gatewaySubscriptionId,
    String? paymentId,
  }) async {
    final snapshot = await _remoteDataSource.syncSubscription(
      gatewaySubscriptionId: gatewaySubscriptionId,
      paymentId: paymentId,
    );
    await _cacheService.write(userId, snapshot);
    return snapshot;
  }
}
