import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/entities/app_entities.dart';
import '../../auth/application/auth_controller.dart';

final studySessionsProvider = StreamProvider<List<StudySessionEntity>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const <StudySessionEntity>[]);
  return ref.watch(studyRepositoryProvider).watchSessions(userId);
});

final studySessionActionsProvider = Provider<StudySessionActions>((ref) {
  return StudySessionActions(ref);
});

class StudySessionActions {
  const StudySessionActions(this._ref);

  final Ref _ref;

  Future<void> save(StudySessionEntity session) {
    return _ref.read(studyRepositoryProvider).saveStudySession(session);
  }

  Future<void> delete(String sessionId) {
    return _ref.read(studyRepositoryProvider).deleteStudySession(sessionId);
  }
}
