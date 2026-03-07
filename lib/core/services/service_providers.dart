import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';
import '../../data/remote/supabase_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/study_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/study_repository.dart';
import 'connectivity_service.dart';
import 'github_service.dart';
import 'notification_service.dart';
import 'seed_service.dart';
import 'session_preferences_service.dart';
import 'startup_coordinator.dart';
import 'sync_service.dart';
import 'tutorial_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

final sessionPreferencesProvider = Provider<SessionPreferencesService>((ref) {
  return SessionPreferencesService(ref.watch(secureStorageProvider));
});

final tutorialServiceProvider = Provider<TutorialService>((ref) {
  return TutorialService(ref.watch(secureStorageProvider));
});

final githubServiceProvider = Provider<GitHubService>((ref) {
  return GitHubService(ref.watch(secureStorageProvider));
});

final notificationServiceProvider = Provider<NotificationService>((_) {
  return NotificationService();
});

final connectivityProvider = Provider<ConnectivityService>(
  (_) => ConnectivityService(Connectivity()),
);

final remoteDataSourceProvider = Provider<SupabaseRemoteDataSource>(
  (_) => const SupabaseRemoteDataSource(),
);

final seedServiceProvider = Provider<SeedService>((_) => const SeedService());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    database: ref.watch(appDatabaseProvider),
    remoteDataSource: ref.watch(remoteDataSourceProvider),
    connectivityService: ref.watch(connectivityProvider),
  );
});

final studyRepositoryProvider = Provider<StudyRepository>((ref) {
  return StudyRepositoryImpl(
    database: ref.watch(appDatabaseProvider),
    remoteDataSource: ref.watch(remoteDataSourceProvider),
    seedService: ref.watch(seedServiceProvider),
    syncService: ref.watch(syncServiceProvider),
  );
});

final startupCoordinatorProvider = Provider<StartupCoordinator>((ref) {
  return StartupCoordinator(
    authRepository: ref.watch(authRepositoryProvider),
    studyRepository: ref.watch(studyRepositoryProvider),
  );
});
