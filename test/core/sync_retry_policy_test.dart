import 'package:code_trail_windows/core/utils/sync_retry_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SyncRetryPolicy', () {
    test('uses escalating retry delays', () {
      expect(SyncRetryPolicy.retryDelayForAttempts(0), Duration.zero);
      expect(
        SyncRetryPolicy.retryDelayForAttempts(1),
        const Duration(seconds: 15),
      );
      expect(
        SyncRetryPolicy.retryDelayForAttempts(2),
        const Duration(minutes: 1),
      );
      expect(
        SyncRetryPolicy.retryDelayForAttempts(3),
        const Duration(minutes: 5),
      );
      expect(
        SyncRetryPolicy.retryDelayForAttempts(4),
        const Duration(minutes: 15),
      );
      expect(
        SyncRetryPolicy.retryDelayForAttempts(7),
        const Duration(hours: 1),
      );
    });

    test('returns null next retry when there is no previous failure', () {
      final updatedAt = DateTime.utc(2026, 3, 7, 12, 0, 0);

      expect(
        SyncRetryPolicy.nextRetryAt(
          attempts: 0,
          updatedAt: updatedAt,
          lastError: null,
        ),
        isNull,
      );
      expect(
        SyncRetryPolicy.nextRetryAt(
          attempts: 2,
          updatedAt: updatedAt,
          lastError: '',
        ),
        isNull,
      );
    });

    test('blocks until the retry window expires', () {
      final updatedAt = DateTime.utc(2026, 3, 7, 12, 0, 0);

      expect(
        SyncRetryPolicy.isReady(
          attempts: 2,
          updatedAt: updatedAt,
          lastError: 'timeout',
          now: updatedAt.add(const Duration(seconds: 30)),
        ),
        isFalse,
      );

      expect(
        SyncRetryPolicy.isReady(
          attempts: 2,
          updatedAt: updatedAt,
          lastError: 'timeout',
          now: updatedAt.add(const Duration(minutes: 1)),
        ),
        isTrue,
      );
    });
  });
}
