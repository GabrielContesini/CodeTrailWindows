import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/entities/app_entities.dart';
import '../../auth/application/auth_controller.dart';

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

  Future<void> save(MindMapEntity mindMap) {
    return _ref.read(studyRepositoryProvider).saveMindMap(mindMap);
  }

  Future<void> delete(String mindMapId) {
    return _ref.read(studyRepositoryProvider).deleteMindMap(mindMapId);
  }
}
