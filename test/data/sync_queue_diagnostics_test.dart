import 'package:code_trail_windows/data/local/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sync queue diagnostics', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    test('reports blocked items and next retry metadata', () async {
      final now = _truncatedUtcNow();

      await database.into(database.syncQueueTable).insert(
        SyncQueueTableCompanion.insert(
          id: 'sync-1',
          tableNameValue: 'tasks',
          recordId: 'task-1',
          action: 'upsert',
          payloadJson: '{}',
          attempts: const Value(2),
          lastError: const Value('timeout'),
          createdAt: now.subtract(const Duration(minutes: 1)),
          updatedAt: now,
        ),
      );

      await database.into(database.syncQueueTable).insert(
        SyncQueueTableCompanion.insert(
          id: 'sync-2',
          tableNameValue: 'reviews',
          recordId: 'review-1',
          action: 'upsert',
          payloadJson: '{}',
          createdAt: now.subtract(const Duration(minutes: 2)),
          updatedAt: now.subtract(const Duration(minutes: 2)),
        ),
      );

      final diagnostics = await database.watchSyncQueueDiagnostics().first;

      expect(diagnostics.pendingItems, 2);
      expect(diagnostics.failedItems, 1);
      expect(diagnostics.blockedItems, 1);
      expect(diagnostics.readyItems, 1);
      expect(diagnostics.lastError, 'timeout');
      expect(
        diagnostics.nextRetryAt!.difference(diagnostics.latestAttemptAt!),
        const Duration(minutes: 1),
      );
    });

    test('exposes retry data in queue items and pending entries', () async {
      final now = _truncatedUtcNow();

      await database.into(database.syncQueueTable).insert(
        SyncQueueTableCompanion.insert(
          id: 'sync-3',
          tableNameValue: 'projects',
          recordId: 'project-1',
          action: 'delete',
          payloadJson: '{}',
          attempts: const Value(1),
          lastError: const Value('network error'),
          createdAt: now,
          updatedAt: now,
        ),
      );

      final queueItems = await database.watchSyncQueueItems().first;
      final pendingEntries = await database.pendingQueueEntries();

      expect(queueItems, hasLength(1));
      expect(queueItems.single.hasError, isTrue);
      expect(queueItems.single.isBlockedUntilRetry, isTrue);
      expect(
        queueItems.single.nextRetryAt!.difference(queueItems.single.updatedAt),
        const Duration(seconds: 15),
      );

      expect(pendingEntries, hasLength(1));
      expect(pendingEntries.single.attempts, 1);
      expect(pendingEntries.single.lastError, 'network error');
    });
  });
}

DateTime _truncatedUtcNow() {
  final now = DateTime.now().toUtc();
  return DateTime.utc(
    now.year,
    now.month,
    now.day,
    now.hour,
    now.minute,
    now.second,
  );
}
