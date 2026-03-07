import '../../data/local/app_database.dart';
import '../../data/remote/supabase_remote_data_source.dart';
import 'connectivity_service.dart';

class SyncService {
  const SyncService({
    required AppDatabase database,
    required SupabaseRemoteDataSource remoteDataSource,
    required ConnectivityService connectivityService,
  }) : _database = database,
       _remoteDataSource = remoteDataSource,
       _connectivityService = connectivityService;

  final AppDatabase _database;
  final SupabaseRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivityService;

  Future<bool> flushPendingQueue() async {
    if (!await _connectivityService.isConnected()) {
      return false;
    }

    final entries = await _database.pendingQueueEntries();
    var hadError = false;

    for (final entry in entries) {
      try {
        if (entry.action == 'upsert') {
          await _remoteDataSource.upsertRow(entry.tableName, entry.payload);
        } else {
          await _remoteDataSource.deleteRow(entry.tableName, entry.recordId);
        }
        await _database.deleteSyncQueueItem(entry.id);
      } catch (error) {
        hadError = true;
        await _database.markSyncQueueError(entry.id, error.toString());
      }
    }

    return !hadError;
  }
}
