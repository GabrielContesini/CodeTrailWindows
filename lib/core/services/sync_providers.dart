import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../shared/models/app_view_models.dart';
import 'service_providers.dart';

final syncOverviewProvider = StreamProvider<SyncOverview>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final connectivity = ref.watch(connectivityProvider);
  final syncService = ref.watch(syncServiceProvider);

  Stream<bool> onlineStream() async* {
    yield await connectivity.isConnected();
    yield* connectivity.connectivityChanges();
  }

  return Rx.combineLatest3<SyncQueueDiagnostics, bool, SyncRuntimeSnapshot,
      SyncOverview>(
    database.watchSyncQueueDiagnostics(),
    onlineStream(),
    syncService.watchRuntimeState(),
    (queue, isOnline, runtime) => SyncOverview(
      isOnline: isOnline,
      queue: queue,
      runtime: runtime,
    ),
  );
});

final syncQueueItemsProvider = StreamProvider<List<SyncQueueItemViewModel>>((
  ref,
) {
  return ref.watch(appDatabaseProvider).watchSyncQueueItems();
});
