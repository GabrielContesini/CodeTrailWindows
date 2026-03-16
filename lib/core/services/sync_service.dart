import 'package:rxdart/rxdart.dart';

import '../../data/local/app_database.dart';
import '../../data/remote/supabase_remote_data_source.dart';
import '../../shared/models/app_view_models.dart';
import '../utils/sync_retry_policy.dart';
import 'connectivity_service.dart';

class SyncFlushResult {
  const SyncFlushResult({
    required this.isOffline,
    required this.processedItems,
    required this.failedItems,
    required this.deferredItems,
    this.lastError,
    this.unavailableItems = 0,
    this.unavailableTables = const <String>{},
  });

  final bool isOffline;
  final int processedItems;
  final int failedItems;
  final int deferredItems;
  final String? lastError;
  final int unavailableItems;
  final Set<String> unavailableTables;

  bool get isSuccessful => !isOffline && failedItems == 0;
  bool get isCooldownOnly =>
      !isOffline &&
      processedItems == 0 &&
      failedItems == 0 &&
      deferredItems > 0 &&
      unavailableTables.isEmpty;
}

class SyncService {
  SyncService({
    required AppDatabase database,
    required SupabaseRemoteDataSource remoteDataSource,
    required ConnectivityService connectivityService,
  }) : _database = database,
       _remoteDataSource = remoteDataSource,
       _connectivityService = connectivityService;

  final AppDatabase _database;
  final SupabaseRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivityService;
  final BehaviorSubject<SyncRuntimeSnapshot> _runtimeState =
      BehaviorSubject<SyncRuntimeSnapshot>.seeded(const SyncRuntimeSnapshot());

  SyncRuntimeSnapshot get currentState => _runtimeState.value;

  Stream<SyncRuntimeSnapshot> watchRuntimeState() => _runtimeState.stream;

  void markSyncStarted() {
    final now = DateTime.now().toUtc();
    _runtimeState.add(
      SyncRuntimeSnapshot(
        phase: SyncActivityPhase.syncing,
        message: 'Sincronizando alteracoes locais com a nuvem.',
        lastAttemptAt: now,
        lastSuccessAt: currentState.lastSuccessAt,
        lastFailureAt: currentState.lastFailureAt,
      ),
    );
  }

  void markOffline() {
    final now = DateTime.now().toUtc();
    _runtimeState.add(
      SyncRuntimeSnapshot(
        phase: SyncActivityPhase.offline,
        message: 'Sem conexao. As alteracoes continuam salvas localmente.',
        lastAttemptAt: now,
        lastSuccessAt: currentState.lastSuccessAt,
        lastFailureAt: currentState.lastFailureAt,
      ),
    );
  }

  void markSyncSuccess(String message) {
    final now = DateTime.now().toUtc();
    _runtimeState.add(
      SyncRuntimeSnapshot(
        phase: SyncActivityPhase.success,
        message: message,
        lastAttemptAt: currentState.lastAttemptAt ?? now,
        lastSuccessAt: now,
        lastFailureAt: currentState.lastFailureAt,
      ),
    );
  }

  void markSyncFailure(String message) {
    final now = DateTime.now().toUtc();
    _runtimeState.add(
      SyncRuntimeSnapshot(
        phase: SyncActivityPhase.failed,
        message: message,
        lastAttemptAt: currentState.lastAttemptAt ?? now,
        lastSuccessAt: currentState.lastSuccessAt,
        lastFailureAt: now,
      ),
    );
  }

  void markSyncCooldown(String message) {
    final now = DateTime.now().toUtc();
    _runtimeState.add(
      SyncRuntimeSnapshot(
        phase: SyncActivityPhase.cooldown,
        message: message,
        lastAttemptAt: currentState.lastAttemptAt ?? now,
        lastSuccessAt: currentState.lastSuccessAt,
        lastFailureAt: currentState.lastFailureAt,
      ),
    );
  }

  Future<SyncFlushResult> flushPendingQueue({
    bool ignoreBackoff = false,
  }) async {
    if (!await _connectivityService.isConnected()) {
      return const SyncFlushResult(
        isOffline: true,
        processedItems: 0,
        failedItems: 0,
        deferredItems: 0,
      );
    }

    final entries = await _database.pendingQueueEntries();
    final now = DateTime.now().toUtc();
    final eligibleEntries = ignoreBackoff
        ? entries
        : entries
              .where(
                (entry) => SyncRetryPolicy.isReady(
                  attempts: entry.attempts,
                  updatedAt: entry.updatedAt,
                  lastError: entry.lastError,
                  now: now,
                ),
              )
              .toList();
    final deferredItems = entries.length - eligibleEntries.length;
    var processedItems = 0;
    var failedItems = 0;
    var unavailableItems = 0;
    String? lastError;
    final unavailableTables = <String>{};

    for (final entry in eligibleEntries) {
      try {
        if (entry.action == 'upsert') {
          await _remoteDataSource.upsertRow(entry.tableName, entry.payload);
        } else {
          await _remoteDataSource.deleteRow(entry.tableName, entry.recordId);
        }
        await _database.deleteSyncQueueItem(entry.id);
        processedItems += 1;
      } catch (error) {
        if (_remoteDataSource.isMissingTableError(
          error,
          table: entry.tableName,
        )) {
          unavailableItems += 1;
          unavailableTables.add(entry.tableName);
          lastError =
              'Tabela remota "${entry.tableName}" nao existe no Supabase.';
          await _database.markSyncQueueError(entry.id, lastError);
          continue;
        }

        failedItems += 1;
        lastError = error.toString();
        await _database.markSyncQueueError(entry.id, lastError);
      }
    }

    return SyncFlushResult(
      isOffline: false,
      processedItems: processedItems,
      failedItems: failedItems,
      deferredItems: deferredItems + unavailableItems,
      lastError: lastError,
      unavailableItems: unavailableItems,
      unavailableTables: unavailableTables,
    );
  }

  void dispose() {
    _runtimeState.close();
  }
}
