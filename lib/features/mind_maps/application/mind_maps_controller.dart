import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/entities/billing_entities.dart';
import '../../../domain/entities/app_entities.dart';
import '../../auth/application/auth_controller.dart';
import '../../billing/application/billing_access_exception.dart';
import '../../billing/application/billing_controller.dart';

final mindMapsProvider = StreamProvider<List<MindMapEntity>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const <MindMapEntity>[]);
  return ref.watch(studyRepositoryProvider).watchMindMaps(userId);
});

final mindMapActionsProvider = Provider<MindMapActions>((ref) {
  return MindMapActions(ref);
});

class MindMapActions {
  const MindMapActions(this._ref);

  final Ref _ref;

  Future<void> save(MindMapEntity mindMap) async {
    final mindMaps = await _ref.read(mindMapsProvider.future);
    final isEditingExisting = mindMaps.any((item) => item.id == mindMap.id);
    final decision = _ref
        .read(billingEntitlementServiceProvider)
        .checkCreationAccess(
          _ref.read(currentBillingSnapshotProvider),
          accessFeatureKey: BillingFeatureKey.mindMapsAccess,
          limitFeatureKey: BillingFeatureKey.mindMapsLimit,
          usedCount: mindMaps.length,
          isEditingExisting: isEditingExisting,
          resourceLabel: 'mind map',
        );
    if (!decision.allowed) {
      throw BillingAccessException(decision);
    }

    return _ref.read(studyRepositoryProvider).saveMindMap(mindMap);
  }

  Future<void> delete(String mindMapId) {
    return _ref.read(studyRepositoryProvider).deleteMindMap(mindMapId);
  }
}
