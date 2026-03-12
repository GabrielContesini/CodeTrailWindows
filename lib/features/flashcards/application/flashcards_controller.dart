import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/models/app_enums.dart';
import '../../auth/application/auth_controller.dart';
import 'flashcard_scheduler.dart';

final flashcardsProvider = StreamProvider<List<FlashcardEntity>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const <FlashcardEntity>[]);
  return ref.watch(studyRepositoryProvider).watchFlashcards(userId);
});

final flashcardActionsProvider = Provider<FlashcardActions>((ref) {
  return FlashcardActions(ref);
});

class FlashcardActions {
  const FlashcardActions(this._ref);

  final Ref _ref;

  Future<void> save(FlashcardEntity flashcard) {
    return _ref.read(studyRepositoryProvider).saveFlashcard(flashcard);
  }

  Future<void> delete(String flashcardId) {
    return _ref.read(studyRepositoryProvider).deleteFlashcard(flashcardId);
  }

  Future<FlashcardEntity> review(
    FlashcardEntity flashcard,
    FlashcardReviewGrade grade,
  ) async {
    final updated = FlashcardScheduler.applyReview(
      flashcard: flashcard,
      grade: grade,
    );
    await save(updated);
    return updated;
  }
}
