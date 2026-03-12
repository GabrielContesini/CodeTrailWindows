import 'package:code_trail_windows/core/services/connectivity_service.dart';
import 'package:code_trail_windows/core/services/seed_service.dart';
import 'package:code_trail_windows/core/services/sync_service.dart';
import 'package:code_trail_windows/data/local/app_database.dart';
import 'package:code_trail_windows/data/remote/app_models.dart';
import 'package:code_trail_windows/data/remote/supabase_remote_data_source.dart';
import 'package:code_trail_windows/data/repositories/study_repository_impl.dart';
import 'package:code_trail_windows/domain/entities/app_entities.dart';
import 'package:code_trail_windows/shared/models/app_enums.dart';
import 'package:code_trail_windows/shared/models/app_view_models.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StudyRepositoryImpl sync flow', () {
    late AppDatabase database;
    late _FakeConnectivityService connectivityService;
    late _InMemoryRemoteDataSource remoteDataSource;
    late SyncService syncService;
    late StudyRepositoryImpl repository;

    const userId = 'user-1';

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      connectivityService = _FakeConnectivityService(connected: false);
      remoteDataSource = _InMemoryRemoteDataSource();
      syncService = SyncService(
        database: database,
        remoteDataSource: remoteDataSource,
        connectivityService: connectivityService,
      );
      repository = StudyRepositoryImpl(
        database: database,
        remoteDataSource: remoteDataSource,
        seedService: const SeedService(),
        syncService: syncService,
      );
    });

    tearDown(() async {
      syncService.dispose();
      await database.close();
    });

    test('saveTask offline keeps local row and enqueues upsert', () async {
      final task = _buildTask();

      await repository.saveTask(task);

      final pending = await database.pendingQueueEntries();
      final localTasks = await database.watchTasks(userId).first;

      expect(pending, hasLength(1));
      expect(pending.single.tableName, 'tasks');
      expect(pending.single.action, 'upsert');
      expect(localTasks, hasLength(1));
      expect(localTasks.single.id, task.id);
      expect(syncService.currentState.phase, SyncActivityPhase.offline);
    });

    test('forceSync pushes task to remote and clears queue', () async {
      final task = _buildTask();
      await repository.saveTask(task);

      connectivityService.connected = true;
      await repository.forceSync(userId);

      final pending = await database.pendingQueueEntries();
      final localRow = await (database.select(
        database.tasksTable,
      )..where((tbl) => tbl.id.equals(task.id))).getSingleOrNull();

      expect(pending, isEmpty);
      expect(remoteDataSource.rowsFor('tasks'), hasLength(1));
      expect(remoteDataSource.rowsFor('tasks').single['id'], task.id);
      expect(localRow, isNotNull);
      expect(localRow!.pendingSync, isFalse);
      expect(syncService.currentState.phase, SyncActivityPhase.success);
    });

    test(
      'deleteTask creates delete queue entry and removes remote row after sync',
      () async {
        final task = _buildTask();
        await repository.saveTask(task);

        connectivityService.connected = true;
        await repository.forceSync(userId);

        connectivityService.connected = false;
        await repository.deleteTask(task.id);

        var pending = await database.pendingQueueEntries();
        var localTasks = await database.watchTasks(userId).first;

        expect(localTasks, isEmpty);
        expect(pending, hasLength(1));
        expect(pending.single.action, 'delete');
        expect(pending.single.recordId, task.id);

        connectivityService.connected = true;
        await repository.forceSync(userId);

        pending = await database.pendingQueueEntries();

        expect(pending, isEmpty);
        expect(remoteDataSource.rowsFor('tasks'), isEmpty);
      },
    );

    test('saveNote uses custom payload path and syncs successfully', () async {
      final note = StudyNoteEntity(
        id: 'note-1',
        userId: userId,
        folderName: 'Arquitetura',
        title: 'Pontos de sync',
        content: 'Fila local, retry e flush remoto.',
        createdAt: DateTime.utc(2026, 3, 7, 12, 0, 0),
        updatedAt: DateTime.utc(2026, 3, 7, 12, 0, 0),
      );

      await repository.saveNote(note);
      expect(
        (await database.pendingQueueEntries()).single.tableName,
        'study_notes',
      );

      connectivityService.connected = true;
      await repository.forceSync(userId);

      expect(await database.pendingQueueEntries(), isEmpty);
      expect(remoteDataSource.rowsFor('study_notes'), hasLength(1));
      expect(
        remoteDataSource.rowsFor('study_notes').single['title'],
        note.title,
      );
    });
  });
}

TaskEntity _buildTask() {
  final now = DateTime.utc(2026, 3, 7, 12, 0, 0);
  return TaskEntity(
    id: 'task-1',
    userId: 'user-1',
    title: 'Fechar fluxo offline-first',
    description: 'Salvar local, enfileirar e sincronizar com Supabase.',
    priority: TaskPriority.high,
    status: TaskStatus.pending,
    createdAt: now,
    updatedAt: now,
  );
}

class _FakeConnectivityService extends ConnectivityService {
  _FakeConnectivityService({required bool connected})
    : _connected = connected,
      super(Connectivity());

  bool _connected;

  set connected(bool value) => _connected = value;

  @override
  Stream<bool> connectivityChanges() => Stream<bool>.value(_connected);

  @override
  Future<bool> isConnected() async => _connected;
}

class _InMemoryRemoteDataSource extends SupabaseRemoteDataSource {
  final Map<String, Map<String, Map<String, dynamic>>> _tables = {};

  List<Map<String, dynamic>> rowsFor(String table) {
    final rows = _tables[table]?.values.toList() ?? const [];
    return rows.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  @override
  Future<void> upsertRow(String table, Map<String, dynamic> payload) async {
    final row = Map<String, dynamic>.from(payload);
    final id = row['id'] as String;
    _tables.putIfAbsent(table, () => <String, Map<String, dynamic>>{})[id] =
        row;
  }

  @override
  Future<void> deleteRow(String table, String id) async {
    _tables[table]?.remove(id);
  }

  @override
  Future<RemoteSyncBundle> fetchAll(String userId) async {
    List<Map<String, dynamic>> table(String name) => rowsFor(name);

    return RemoteSyncBundle(
      profiles: table(
        'profiles',
      ).where((row) => row['id'] == userId).map(ProfileModel.fromJson).toList(),
      goals: table('user_goals')
          .where((row) => row['user_id'] == userId)
          .map(UserGoalModel.fromJson)
          .toList(),
      tracks: table('study_tracks').map(StudyTrackModel.fromJson).toList(),
      skills: table('study_skills').map(StudySkillModel.fromJson).toList(),
      progress: table('user_skill_progress')
          .where((row) => row['user_id'] == userId)
          .map(UserSkillProgressModel.fromJson)
          .toList(),
      modules: table('study_modules').map(StudyModuleModel.fromJson).toList(),
      sessions: table('study_sessions')
          .where((row) => row['user_id'] == userId)
          .map(StudySessionModel.fromJson)
          .toList(),
      tasks: table('tasks')
          .where((row) => row['user_id'] == userId)
          .map(TaskModel.fromJson)
          .toList(),
      reviews: table('reviews')
          .where((row) => row['user_id'] == userId)
          .map(ReviewModel.fromJson)
          .toList(),
      projects: table('projects')
          .where((row) => row['user_id'] == userId)
          .map(ProjectModel.fromJson)
          .toList(),
      projectSteps: table(
        'project_steps',
      ).map(ProjectStepModel.fromJson).toList(),
      notes: table('study_notes')
          .where((row) => row['user_id'] == userId)
          .map(StudyNoteModel.fromJson)
          .toList(),
      flashcards: table('flashcards')
          .where((row) => row['user_id'] == userId)
          .map(FlashcardModel.fromJson)
          .toList(),
      settings: table('app_settings')
          .where((row) => row['user_id'] == userId)
          .map(AppSettingsModel.fromJson)
          .toList(),
    );
  }
}
