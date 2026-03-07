import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../shared/models/app_view_models.dart';
import '../../auth/application/auth_controller.dart';

final trackBlueprintsProvider = StreamProvider<List<TrackBlueprint>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const <TrackBlueprint>[]);
  return ref.watch(studyRepositoryProvider).watchTracks(userId);
});

final selectedTrackProvider = FutureProvider.family<TrackBlueprint?, String>((
  ref,
  trackId,
) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  return ref.watch(studyRepositoryProvider).getTrack(userId, trackId);
});
