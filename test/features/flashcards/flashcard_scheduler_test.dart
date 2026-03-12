import 'package:code_trail_windows/domain/entities/app_entities.dart';
import 'package:code_trail_windows/features/flashcards/application/flashcard_scheduler.dart';
import 'package:code_trail_windows/shared/models/app_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlashcardScheduler', () {
    test('good review schedules first successful review for next day', () {
      final reviewedAt = DateTime.utc(2026, 3, 12, 14);
      final flashcard = _flashcard();

      final updated = FlashcardScheduler.applyReview(
        flashcard: flashcard,
        grade: FlashcardReviewGrade.good,
        reviewedAt: reviewedAt,
      );

      expect(updated.reviewCount, 1);
      expect(updated.correctStreak, 1);
      expect(updated.intervalDays, 1);
      expect(updated.dueAt, reviewedAt.add(const Duration(days: 1)));
    });

    test('again review resets streak and brings card back in minutes', () {
      final reviewedAt = DateTime.utc(2026, 3, 12, 14);
      final flashcard = _flashcard().copyWith(
        reviewCount: 4,
        correctStreak: 3,
        intervalDays: 9,
        easeFactor: 2.6,
      );

      final updated = FlashcardScheduler.applyReview(
        flashcard: flashcard,
        grade: FlashcardReviewGrade.again,
        reviewedAt: reviewedAt,
      );

      expect(updated.reviewCount, 5);
      expect(updated.correctStreak, 0);
      expect(updated.intervalDays, 0);
      expect(updated.easeFactor, 2.4);
      expect(updated.dueAt, reviewedAt.add(const Duration(minutes: 10)));
    });
  });
}

FlashcardEntity _flashcard() {
  final now = DateTime.utc(2026, 3, 12, 13);
  return FlashcardEntity(
    id: 'fc-1',
    userId: 'user-1',
    deckName: 'Arquitetura',
    question: 'O que é eventual consistency?',
    answer: 'É quando o sistema converge para o mesmo estado com o tempo.',
    dueAt: now,
    reviewCount: 0,
    correctStreak: 0,
    easeFactor: 2.3,
    intervalDays: 0,
    createdAt: now,
    updatedAt: now,
  );
}
