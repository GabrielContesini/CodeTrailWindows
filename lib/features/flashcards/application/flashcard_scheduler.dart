import 'dart:math' as math;

import '../../../domain/entities/app_entities.dart';
import '../../../shared/models/app_enums.dart';

class FlashcardScheduler {
  const FlashcardScheduler._();

  static FlashcardEntity applyReview({
    required FlashcardEntity flashcard,
    required FlashcardReviewGrade grade,
    DateTime? reviewedAt,
  }) {
    final now = (reviewedAt ?? DateTime.now()).toUtc();
    final baseEase = math.max(1.3, flashcard.easeFactor);

    late final int nextIntervalDays;
    late final int nextStreak;
    late final double nextEaseFactor;
    late final DateTime nextDueAt;

    switch (grade) {
      case FlashcardReviewGrade.again:
        nextIntervalDays = 0;
        nextStreak = 0;
        nextEaseFactor = _roundEase(math.max(1.3, baseEase - 0.2));
        nextDueAt = now.add(const Duration(minutes: 10));
      case FlashcardReviewGrade.hard:
        final baseInterval = math.max(1, flashcard.intervalDays);
        nextIntervalDays = flashcard.reviewCount == 0
            ? 1
            : math.max(1, (baseInterval * 1.2).round());
        nextStreak = math.max(0, flashcard.correctStreak - 1);
        nextEaseFactor = _roundEase(math.max(1.3, baseEase - 0.1));
        nextDueAt = now.add(Duration(days: nextIntervalDays));
      case FlashcardReviewGrade.good:
        final baseInterval = math.max(1, flashcard.intervalDays);
        nextIntervalDays = flashcard.reviewCount == 0
            ? 1
            : math.max(baseInterval + 1, (baseInterval * baseEase).round());
        nextStreak = flashcard.correctStreak + 1;
        nextEaseFactor = _roundEase(baseEase);
        nextDueAt = now.add(Duration(days: nextIntervalDays));
      case FlashcardReviewGrade.easy:
        final baseInterval = math.max(2, flashcard.intervalDays);
        nextIntervalDays = flashcard.reviewCount == 0
            ? 3
            : math.max(
                baseInterval + 2,
                (baseInterval * (baseEase + 0.35)).round(),
              );
        nextStreak = flashcard.correctStreak + 1;
        nextEaseFactor = _roundEase(baseEase + 0.15);
        nextDueAt = now.add(Duration(days: nextIntervalDays));
    }

    return flashcard.copyWith(
      dueAt: nextDueAt,
      lastReviewedAt: now,
      reviewCount: flashcard.reviewCount + 1,
      correctStreak: nextStreak,
      easeFactor: nextEaseFactor,
      intervalDays: nextIntervalDays,
      updatedAt: now,
    );
  }

  static double _roundEase(double value) =>
      double.parse(value.toStringAsFixed(2));
}
