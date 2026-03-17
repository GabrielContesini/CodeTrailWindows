import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/entities/billing_entities.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/models/app_enums.dart';
import '../../auth/application/auth_controller.dart';
import '../../billing/application/billing_access_exception.dart';
import '../../billing/application/billing_controller.dart';
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

  Future<void> save(FlashcardEntity flashcard) async {
    final flashcards = await _ref.read(flashcardsProvider.future);
    final isEditingExisting = flashcards.any((item) => item.id == flashcard.id);
    final decision = _ref
        .read(billingEntitlementServiceProvider)
        .checkCreationAccess(
          _ref.read(currentBillingSnapshotProvider),
          accessFeatureKey: BillingFeatureKey.flashcardsAccess,
          limitFeatureKey: BillingFeatureKey.flashcardsLimit,
          usedCount: flashcards.length,
          isEditingExisting: isEditingExisting,
          resourceLabel: 'flashcard',
        );
    if (!decision.allowed) {
      throw BillingAccessException(decision);
    }

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
