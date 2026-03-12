import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/sync_retry_policy.dart';
import '../../shared/models/app_view_models.dart';
import '../remote/app_models.dart';

part 'app_database.g.dart';

mixin AuditColumns on Table {
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get pendingSync => boolean().withDefault(const Constant(false))();
}

class ProfilesTable extends Table with AuditColumns {
  @override
  String get tableName => 'profiles';

  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get email => text().nullable()();
  TextColumn get desiredArea => text()();
  TextColumn get currentLevel => text()();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
  TextColumn get selectedTrackId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class UserGoalsTable extends Table with AuditColumns {
  @override
  String get tableName => 'user_goals';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get primaryGoal => text()();
  TextColumn get desiredArea => text()();
  TextColumn get focusType => text()();
  IntColumn get hoursPerDay => integer()();
  IntColumn get daysPerWeek => integer()();
  DateTimeColumn get deadline => dateTime()();
  TextColumn get currentLevel => text()();
  TextColumn get generatedPlan => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class StudyTracksTable extends Table with AuditColumns {
  @override
  String get tableName => 'study_tracks';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get iconKey => text()();
  TextColumn get colorHex => text()();
  TextColumn get roadmapSummary => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class StudySkillsTable extends Table with AuditColumns {
  @override
  String get tableName => 'study_skills';

  TextColumn get id => text()();
  TextColumn get trackId => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get targetLevel => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class UserSkillProgressTable extends Table with AuditColumns {
  @override
  String get tableName => 'user_skill_progress';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get skillId => text()();
  RealColumn get progressPercent => real()();
  DateTimeColumn get lastStudiedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class StudyModulesTable extends Table with AuditColumns {
  @override
  String get tableName => 'study_modules';

  TextColumn get id => text()();
  TextColumn get trackId => text()();
  TextColumn get title => text()();
  TextColumn get summary => text()();
  IntColumn get estimatedHours => integer()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isCore => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class StudySessionsTable extends Table with AuditColumns {
  @override
  String get tableName => 'study_sessions';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get trackId => text().nullable()();
  TextColumn get skillId => text().nullable()();
  TextColumn get moduleId => text().nullable()();
  TextColumn get type => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get durationMinutes => integer()();
  TextColumn get notes => text()();
  IntColumn get productivityScore => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TasksTable extends Table with AuditColumns {
  @override
  String get tableName => 'tasks';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get trackId => text().nullable()();
  TextColumn get moduleId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get priority => text()();
  TextColumn get status => text()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ReviewsTable extends Table with AuditColumns {
  @override
  String get tableName => 'reviews';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sessionId => text().nullable()();
  TextColumn get trackId => text().nullable()();
  TextColumn get skillId => text().nullable()();
  TextColumn get title => text()();
  DateTimeColumn get scheduledFor => dateTime()();
  TextColumn get status => text()();
  TextColumn get intervalLabel => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ProjectsTable extends Table with AuditColumns {
  @override
  String get tableName => 'projects';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get trackId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get scope => text()();
  TextColumn get description => text()();
  TextColumn get repositoryUrl => text().nullable()();
  TextColumn get documentationUrl => text().nullable()();
  TextColumn get videoUrl => text().nullable()();
  TextColumn get status => text()();
  RealColumn get progressPercent => real()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ProjectStepsTable extends Table with AuditColumns {
  @override
  String get tableName => 'project_steps';

  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  BoolColumn get isDone => boolean()();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SyncQueueTable extends Table {
  @override
  String get tableName => 'sync_queue';

  TextColumn get id => text()();
  TextColumn get tableNameValue => text().named('table_name')();
  TextColumn get recordId => text().named('record_id')();
  TextColumn get action => text()();
  TextColumn get payloadJson => text().named('payload_json')();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppSettingsTable extends Table with AuditColumns {
  @override
  String get tableName => 'app_settings';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get themePreference => text()();
  BoolColumn get notificationsEnabled => boolean()();
  IntColumn get dailyReminderHour => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class StudyNotesTable extends Table with AuditColumns {
  @override
  String get tableName => 'study_notes';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get folderName => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class FlashcardsTable extends Table with AuditColumns {
  @override
  String get tableName => 'flashcards';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get deckName => text()();
  TextColumn get question => text()();
  TextColumn get answer => text()();
  TextColumn get trackId => text().nullable()();
  TextColumn get moduleId => text().nullable()();
  TextColumn get projectId => text().nullable()();
  DateTimeColumn get dueAt => dateTime()();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();
  IntColumn get correctStreak => integer().withDefault(const Constant(0))();
  RealColumn get easeFactor => real().withDefault(const Constant(2.3))();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class MindMapsTable extends Table with AuditColumns {
  @override
  String get tableName => 'mind_maps';

  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get folderName => text()();
  TextColumn get title => text()();
  TextColumn get contentJson => text()();
  TextColumn get trackId => text().nullable()();
  TextColumn get moduleId => text().nullable()();
  TextColumn get projectId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PendingSyncQueueRecord {
  const PendingSyncQueueRecord({
    required this.id,
    required this.tableName,
    required this.recordId,
    required this.action,
    required this.payload,
    required this.attempts,
    required this.createdAt,
    required this.updatedAt,
    this.lastError,
  });

  final String id;
  final String tableName;
  final String recordId;
  final String action;
  final Map<String, dynamic> payload;
  final int attempts;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastError;
}

@DriftDatabase(
  tables: [
    ProfilesTable,
    UserGoalsTable,
    StudyTracksTable,
    StudySkillsTable,
    UserSkillProgressTable,
    StudyModulesTable,
    StudySessionsTable,
    TasksTable,
    ReviewsTable,
    ProjectsTable,
    ProjectStepsTable,
    SyncQueueTable,
    AppSettingsTable,
    StudyNotesTable,
    FlashcardsTable,
    MindMapsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(studyNotesTable);
      }
      if (from < 3) {
        await m.createTable(flashcardsTable);
      }
      if (from < 4) {
        await m.createTable(mindMapsTable);
      }
    },
  );

  Future<ProfilesTableData?> getProfile(String userId) {
    return (select(
      profilesTable,
    )..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
  }

  Future<UserGoalsTableData?> getGoal(String userId) {
    return (select(userGoalsTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get()
        .then((rows) => rows.isEmpty ? null : rows.first);
  }

  Future<AppSettingsTableData?> getSettings(String userId) {
    return (select(appSettingsTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get()
        .then((rows) => rows.isEmpty ? null : rows.first);
  }

  Stream<List<StudyNotesTableData>> watchNotes(String userId) {
    return (select(studyNotesTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.folderName),
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ]))
        .watch();
  }

  Stream<List<FlashcardsTableData>> watchFlashcards(String userId) {
    return (select(flashcardsTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.dueAt),
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ]))
        .watch();
  }

  Stream<List<MindMapsTableData>> watchMindMaps(String userId) {
    return (select(mindMapsTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.folderName),
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ]))
        .watch();
  }

  Stream<List<StudyTracksTableData>> watchTracks() {
    return (select(
      studyTracksTable,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.name)])).watch();
  }

  Stream<List<StudySkillsTableData>> watchSkills() {
    return (select(
      studySkillsTable,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)])).watch();
  }

  Stream<List<StudyModulesTableData>> watchModules() {
    return (select(
      studyModulesTable,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)])).watch();
  }

  Stream<List<UserSkillProgressTableData>> watchProgress(String userId) {
    return (select(
      userSkillProgressTable,
    )..where((tbl) => tbl.userId.equals(userId))).watch();
  }

  Stream<List<StudySessionsTableData>> watchSessions(String userId) {
    return (select(studySessionsTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startTime)]))
        .watch();
  }

  Stream<List<TasksTableData>> watchTasks(String userId) {
    return (select(tasksTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.dueDate),
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ]))
        .watch();
  }

  Stream<List<ReviewsTableData>> watchReviews(String userId) {
    return (select(reviewsTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.scheduledFor)]))
        .watch();
  }

  Stream<List<ProjectsTableData>> watchProjects(String userId) {
    return (select(projectsTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .watch();
  }

  Stream<List<ProjectStepsTableData>> watchProjectSteps(String projectId) {
    return (select(projectStepsTable)
          ..where((tbl) => tbl.projectId.equals(projectId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]))
        .watch();
  }

  Stream<SyncQueueDiagnostics> watchSyncQueueDiagnostics() {
    return (select(
      syncQueueTable,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)])).watch().map((
      rows,
    ) {
      if (rows.isEmpty) {
        return const SyncQueueDiagnostics.empty();
      }

      final failedRows = rows
          .where((row) => row.lastError != null && row.lastError!.isNotEmpty)
          .toList();
      final oldestPendingAt = rows
          .map((row) => row.createdAt)
          .reduce((left, right) => left.isBefore(right) ? left : right);
      final latestAttemptAt = rows
          .map((row) => row.updatedAt)
          .reduce((left, right) => left.isAfter(right) ? left : right);

      return SyncQueueDiagnostics(
        pendingItems: rows.length,
        blockedItems: rows
            .where(
              (row) => !SyncRetryPolicy.isReady(
                attempts: row.attempts,
                updatedAt: row.updatedAt,
                lastError: row.lastError,
              ),
            )
            .length,
        failedItems: failedRows.length,
        lastError: failedRows.isEmpty ? null : failedRows.first.lastError,
        oldestPendingAt: oldestPendingAt,
        latestAttemptAt: latestAttemptAt,
        nextRetryAt: rows
            .map(
              (row) => SyncRetryPolicy.nextRetryAt(
                attempts: row.attempts,
                updatedAt: row.updatedAt,
                lastError: row.lastError,
              ),
            )
            .whereType<DateTime>()
            .fold<DateTime?>(
              null,
              (current, candidate) =>
                  current == null || candidate.isBefore(current)
                  ? candidate
                  : current,
            ),
      );
    });
  }

  Stream<List<SyncQueueItemViewModel>> watchSyncQueueItems() {
    return (select(syncQueueTable)..orderBy([
          (tbl) => OrderingTerm.desc(tbl.updatedAt),
          (tbl) => OrderingTerm.desc(tbl.createdAt),
        ]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => SyncQueueItemViewModel(
                  id: row.id,
                  tableName: row.tableNameValue,
                  recordId: row.recordId,
                  action: row.action,
                  attempts: row.attempts,
                  createdAt: row.createdAt,
                  updatedAt: row.updatedAt,
                  lastError: row.lastError,
                  nextRetryAt: SyncRetryPolicy.nextRetryAt(
                    attempts: row.attempts,
                    updatedAt: row.updatedAt,
                    lastError: row.lastError,
                  ),
                ),
              )
              .toList(),
        );
  }

  Future<void> clearCatalog() => transaction(() async {
    await delete(studySkillsTable).go();
    await delete(studyModulesTable).go();
    await delete(studyTracksTable).go();
  });

  Future<void> replaceRemoteSnapshot(
    String userId,
    RemoteSyncBundle bundle,
  ) async {
    await transaction(() async {
      await clearCatalog();

      await batch((batch) {
        batch.insertAllOnConflictUpdate(
          studyTracksTable,
          bundle.tracks
              .map((item) => item.toCompanion(pending: false))
              .toList(),
        );
        batch.insertAllOnConflictUpdate(
          studySkillsTable,
          bundle.skills
              .map((item) => item.toCompanion(pending: false))
              .toList(),
        );
        batch.insertAllOnConflictUpdate(
          studyModulesTable,
          bundle.modules
              .map((item) => item.toCompanion(pending: false))
              .toList(),
        );
      });

      final localProjects = await (select(
        projectsTable,
      )..where((tbl) => tbl.userId.equals(userId))).get();
      final localProjectIds = localProjects.map((item) => item.id).toList();

      if (localProjectIds.isNotEmpty) {
        await (delete(
          projectStepsTable,
        )..where((tbl) => tbl.projectId.isIn(localProjectIds))).go();
      }

      await (delete(
        appSettingsTable,
      )..where((tbl) => tbl.userId.equals(userId))).go();
      await (delete(
        userGoalsTable,
      )..where((tbl) => tbl.userId.equals(userId))).go();
      await (delete(
        userSkillProgressTable,
      )..where((tbl) => tbl.userId.equals(userId))).go();
      await (delete(
        studySessionsTable,
      )..where((tbl) => tbl.userId.equals(userId))).go();
      await (delete(
        tasksTable,
      )..where((tbl) => tbl.userId.equals(userId))).go();
      await (delete(
        reviewsTable,
      )..where((tbl) => tbl.userId.equals(userId))).go();
      await (delete(
        projectsTable,
      )..where((tbl) => tbl.userId.equals(userId))).go();
      await (delete(
        studyNotesTable,
      )..where((tbl) => tbl.userId.equals(userId))).go();
      if (bundle.flashcardsAvailable) {
        await (delete(
          flashcardsTable,
        )..where((tbl) => tbl.userId.equals(userId))).go();
      }
      if (bundle.mindMapsAvailable) {
        await (delete(
          mindMapsTable,
        )..where((tbl) => tbl.userId.equals(userId))).go();
      }
      await (delete(profilesTable)..where((tbl) => tbl.id.equals(userId))).go();

      await batch((batch) {
        batch.insertAllOnConflictUpdate(
          profilesTable,
          bundle.profiles
              .map((item) => item.toCompanion(pending: false))
              .toList(),
        );
        batch.insertAllOnConflictUpdate(
          userGoalsTable,
          bundle.goals.map((item) => item.toCompanion(pending: false)).toList(),
        );
        batch.insertAllOnConflictUpdate(
          userSkillProgressTable,
          bundle.progress
              .map((item) => item.toCompanion(pending: false))
              .toList(),
        );
        batch.insertAllOnConflictUpdate(
          studySessionsTable,
          bundle.sessions
              .map((item) => item.toCompanion(pending: false))
              .toList(),
        );
        batch.insertAllOnConflictUpdate(
          tasksTable,
          bundle.tasks.map((item) => item.toCompanion(pending: false)).toList(),
        );
        batch.insertAllOnConflictUpdate(
          reviewsTable,
          bundle.reviews
              .map((item) => item.toCompanion(pending: false))
              .toList(),
        );
        batch.insertAllOnConflictUpdate(
          projectsTable,
          bundle.projects
              .map((item) => item.toCompanion(pending: false))
              .toList(),
        );
        batch.insertAllOnConflictUpdate(
          projectStepsTable,
          bundle.projectSteps
              .map((item) => item.toCompanion(pending: false))
              .toList(),
        );
        batch.insertAllOnConflictUpdate(
          studyNotesTable,
          bundle.notes.map((item) => item.toCompanion(pending: false)).toList(),
        );
        if (bundle.flashcardsAvailable) {
          batch.insertAllOnConflictUpdate(
            flashcardsTable,
            bundle.flashcards
                .map((item) => item.toCompanion(pending: false))
                .toList(),
          );
        }
        if (bundle.mindMapsAvailable) {
          batch.insertAllOnConflictUpdate(
            mindMapsTable,
            bundle.mindMaps
                .map((item) => item.toCompanion(pending: false))
                .toList(),
          );
        }
        batch.insertAllOnConflictUpdate(
          appSettingsTable,
          bundle.settings
              .map((item) => item.toCompanion(pending: false))
              .toList(),
        );
      });
    });
  }

  Future<void> upsertProfile(ProfileModel model, {bool pending = false}) {
    return into(
      profilesTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> upsertGoal(UserGoalModel model, {bool pending = false}) {
    return into(
      userGoalsTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> upsertTrack(StudyTrackModel model, {bool pending = false}) {
    return into(
      studyTracksTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> upsertSkill(StudySkillModel model, {bool pending = false}) {
    return into(
      studySkillsTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> upsertProgress(
    UserSkillProgressModel model, {
    bool pending = false,
  }) {
    return into(
      userSkillProgressTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> upsertModule(StudyModuleModel model, {bool pending = false}) {
    return into(
      studyModulesTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> upsertSession(StudySessionModel model, {bool pending = false}) {
    return into(
      studySessionsTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> deleteSessionById(String sessionId) {
    return (delete(
      studySessionsTable,
    )..where((tbl) => tbl.id.equals(sessionId))).go();
  }

  Future<void> upsertTask(TaskModel model, {bool pending = false}) {
    return into(
      tasksTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> deleteTaskById(String taskId) {
    return (delete(tasksTable)..where((tbl) => tbl.id.equals(taskId))).go();
  }

  Future<void> upsertReview(ReviewModel model, {bool pending = false}) {
    return into(
      reviewsTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> deleteReviewById(String reviewId) {
    return (delete(reviewsTable)..where((tbl) => tbl.id.equals(reviewId))).go();
  }

  Future<void> upsertProject(ProjectModel model, {bool pending = false}) {
    return into(
      projectsTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> deleteProjectById(String projectId) async {
    await (delete(
      projectStepsTable,
    )..where((tbl) => tbl.projectId.equals(projectId))).go();
    await (delete(
      projectsTable,
    )..where((tbl) => tbl.id.equals(projectId))).go();
  }

  Future<void> upsertProjectStep(
    ProjectStepModel model, {
    bool pending = false,
  }) {
    return into(
      projectStepsTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> deleteProjectStepById(String stepId) {
    return (delete(
      projectStepsTable,
    )..where((tbl) => tbl.id.equals(stepId))).go();
  }

  Future<void> upsertSettings(
    AppSettingsModel model, {
    bool pending = false,
  }) async {
    final duplicates = await (select(
      appSettingsTable,
    )..where((tbl) => tbl.userId.equals(model.userId))).get();

    for (final row in duplicates.where((row) => row.id != model.id)) {
      await (delete(
        appSettingsTable,
      )..where((tbl) => tbl.id.equals(row.id))).go();
    }

    await into(
      appSettingsTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> upsertNote(
    StudyNotesTableCompanion companion, {
    bool pending = false,
  }) {
    return into(
      studyNotesTable,
    ).insertOnConflictUpdate(companion.copyWith(pendingSync: Value(pending)));
  }

  Future<void> deleteNoteById(String noteId) {
    return (delete(
      studyNotesTable,
    )..where((tbl) => tbl.id.equals(noteId))).go();
  }

  Future<void> upsertFlashcard(FlashcardModel model, {bool pending = false}) {
    return into(
      flashcardsTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> deleteFlashcardById(String flashcardId) {
    return (delete(
      flashcardsTable,
    )..where((tbl) => tbl.id.equals(flashcardId))).go();
  }

  Future<void> upsertMindMap(MindMapModel model, {bool pending = false}) {
    return into(
      mindMapsTable,
    ).insertOnConflictUpdate(model.toCompanion(pending: pending));
  }

  Future<void> deleteMindMapById(String mindMapId) {
    return (delete(
      mindMapsTable,
    )..where((tbl) => tbl.id.equals(mindMapId))).go();
  }

  Future<void> queueUpsert({
    required String id,
    required String tableName,
    required String recordId,
    required Map<String, dynamic> payload,
  }) {
    final now = DateTime.now().toUtc();
    return into(syncQueueTable).insertOnConflictUpdate(
      SyncQueueTableCompanion.insert(
        id: id,
        tableNameValue: tableName,
        recordId: recordId,
        action: 'upsert',
        payloadJson: jsonEncode(payload),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> queueDelete({
    required String id,
    required String tableName,
    required String recordId,
  }) {
    final now = DateTime.now().toUtc();
    return into(syncQueueTable).insertOnConflictUpdate(
      SyncQueueTableCompanion.insert(
        id: id,
        tableNameValue: tableName,
        recordId: recordId,
        action: 'delete',
        payloadJson: '{}',
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<List<PendingSyncQueueRecord>> pendingQueueEntries() async {
    final rows = await (select(
      syncQueueTable,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)])).get();

    return rows
        .map(
          (item) => PendingSyncQueueRecord(
            id: item.id,
            tableName: item.tableNameValue,
            recordId: item.recordId,
            action: item.action,
            payload: jsonDecode(item.payloadJson) as Map<String, dynamic>,
            attempts: item.attempts,
            createdAt: item.createdAt,
            updatedAt: item.updatedAt,
            lastError: item.lastError,
          ),
        )
        .toList();
  }

  Future<void> deleteSyncQueueItem(String id) {
    return (delete(syncQueueTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> markSyncQueueError(String id, String error) async {
    final item = await (select(
      syncQueueTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (item == null) return;

    await update(syncQueueTable).replace(
      item.copyWith(
        attempts: item.attempts + 1,
        lastError: Value(error),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}

extension on ProfileModel {
  ProfilesTableCompanion toCompanion({bool pending = false}) {
    return ProfilesTableCompanion.insert(
      id: id,
      fullName: fullName,
      email: Value(email),
      desiredArea: desiredArea,
      currentLevel: currentLevel.name,
      onboardingCompleted: Value(onboardingCompleted),
      selectedTrackId: Value(selectedTrackId),
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on UserGoalModel {
  UserGoalsTableCompanion toCompanion({bool pending = false}) {
    return UserGoalsTableCompanion.insert(
      id: id,
      userId: userId,
      primaryGoal: primaryGoal,
      desiredArea: desiredArea,
      focusType: focusType.name,
      hoursPerDay: hoursPerDay,
      daysPerWeek: daysPerWeek,
      deadline: deadline,
      currentLevel: currentLevel.name,
      generatedPlan: generatedPlan,
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on StudyTrackModel {
  StudyTracksTableCompanion toCompanion({bool pending = false}) {
    return StudyTracksTableCompanion.insert(
      id: id,
      name: name,
      description: description,
      iconKey: iconKey,
      colorHex: colorHex,
      roadmapSummary: roadmapSummary,
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on StudySkillModel {
  StudySkillsTableCompanion toCompanion({bool pending = false}) {
    return StudySkillsTableCompanion.insert(
      id: id,
      trackId: trackId,
      name: name,
      description: description,
      targetLevel: targetLevel.name,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on UserSkillProgressModel {
  UserSkillProgressTableCompanion toCompanion({bool pending = false}) {
    return UserSkillProgressTableCompanion.insert(
      id: id,
      userId: userId,
      skillId: skillId,
      progressPercent: progressPercent,
      lastStudiedAt: Value(lastStudiedAt),
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on StudyModuleModel {
  StudyModulesTableCompanion toCompanion({bool pending = false}) {
    return StudyModulesTableCompanion.insert(
      id: id,
      trackId: trackId,
      title: title,
      summary: summary,
      estimatedHours: estimatedHours,
      sortOrder: sortOrder,
      isCore: isCore,
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on StudySessionModel {
  StudySessionsTableCompanion toCompanion({bool pending = false}) {
    return StudySessionsTableCompanion.insert(
      id: id,
      userId: userId,
      trackId: Value(trackId),
      skillId: Value(skillId),
      moduleId: Value(moduleId),
      type: type.name,
      startTime: startTime,
      endTime: endTime,
      durationMinutes: durationMinutes,
      notes: notes,
      productivityScore: productivityScore,
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on TaskModel {
  TasksTableCompanion toCompanion({bool pending = false}) {
    return TasksTableCompanion.insert(
      id: id,
      userId: userId,
      trackId: Value(trackId),
      moduleId: Value(moduleId),
      title: title,
      description: description,
      priority: priority.name,
      status: status.name,
      dueDate: Value(dueDate),
      completedAt: Value(completedAt),
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on ReviewModel {
  ReviewsTableCompanion toCompanion({bool pending = false}) {
    return ReviewsTableCompanion.insert(
      id: id,
      userId: userId,
      sessionId: Value(sessionId),
      trackId: Value(trackId),
      skillId: Value(skillId),
      title: title,
      scheduledFor: scheduledFor,
      status: status.name,
      intervalLabel: intervalLabel,
      notes: Value(notes),
      completedAt: Value(completedAt),
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on ProjectModel {
  ProjectsTableCompanion toCompanion({bool pending = false}) {
    return ProjectsTableCompanion.insert(
      id: id,
      userId: userId,
      trackId: Value(trackId),
      title: title,
      scope: scope,
      description: description,
      repositoryUrl: Value(repositoryUrl),
      documentationUrl: Value(documentationUrl),
      videoUrl: Value(videoUrl),
      status: status.name,
      progressPercent: progressPercent,
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on ProjectStepModel {
  ProjectStepsTableCompanion toCompanion({bool pending = false}) {
    return ProjectStepsTableCompanion.insert(
      id: id,
      projectId: projectId,
      title: title,
      description: description,
      isDone: isDone,
      sortOrder: sortOrder,
      completedAt: Value(completedAt),
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on AppSettingsModel {
  AppSettingsTableCompanion toCompanion({bool pending = false}) {
    return AppSettingsTableCompanion.insert(
      id: id,
      userId: userId,
      themePreference: themePreference.name,
      notificationsEnabled: notificationsEnabled,
      dailyReminderHour: Value(dailyReminderHour),
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on StudyNoteModel {
  StudyNotesTableCompanion toCompanion({bool pending = false}) {
    return StudyNotesTableCompanion.insert(
      id: id,
      userId: userId,
      folderName: folderName,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on FlashcardModel {
  FlashcardsTableCompanion toCompanion({bool pending = false}) {
    return FlashcardsTableCompanion.insert(
      id: id,
      userId: userId,
      deckName: deckName,
      question: question,
      answer: answer,
      trackId: Value(trackId),
      moduleId: Value(moduleId),
      projectId: Value(projectId),
      dueAt: dueAt,
      lastReviewedAt: Value(lastReviewedAt),
      reviewCount: Value(reviewCount),
      correctStreak: Value(correctStreak),
      easeFactor: Value(easeFactor),
      intervalDays: Value(intervalDays),
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}

extension on MindMapModel {
  MindMapsTableCompanion toCompanion({bool pending = false}) {
    return MindMapsTableCompanion.insert(
      id: id,
      userId: userId,
      folderName: folderName,
      title: title,
      contentJson: contentJson,
      trackId: Value(trackId),
      moduleId: Value(moduleId),
      projectId: Value(projectId),
      createdAt: createdAt,
      updatedAt: updatedAt,
      pendingSync: Value(pending),
    );
  }
}
