import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/models/app_enums.dart';
import '../../auth/application/auth_controller.dart';

final reviewsProvider = StreamProvider<List<ReviewEntity>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const <ReviewEntity>[]);
  return ref.watch(studyRepositoryProvider).watchReviews(userId);
});

final reviewActionsProvider = Provider<ReviewActions>((ref) {
  return ReviewActions(ref);
});

class ReviewActions {
  const ReviewActions(this._ref);

  final Ref _ref;

  Future<void> save(ReviewEntity review) async {
    await _ref.read(studyRepositoryProvider).saveReview(review);
    if (review.status == ReviewStatus.completed) {
      await _ref
          .read(notificationServiceProvider)
          .cancelReviewReminder(review.id);
    } else {
      await _ref
          .read(notificationServiceProvider)
          .scheduleReviewReminder(review);
    }
  }

  Future<void> saveBatch(List<ReviewEntity> reviews) async {
    await _ref.read(studyRepositoryProvider).saveReviews(reviews);
    for (final review in reviews) {
      await _ref
          .read(notificationServiceProvider)
          .scheduleReviewReminder(review);
    }
  }

  Future<void> complete(ReviewEntity review) async {
    await _ref.read(studyRepositoryProvider).completeReview(review);
    await _ref
        .read(notificationServiceProvider)
        .cancelReviewReminder(review.id);
  }

  Future<void> delete(ReviewEntity review) async {
    await _ref.read(studyRepositoryProvider).deleteReview(review.id);
    await _ref
        .read(notificationServiceProvider)
        .cancelReviewReminder(review.id);
  }
}
