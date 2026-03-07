import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/seed_service.dart';
import '../../core/services/study_plan_generator.dart';
import '../../core/services/sync_service.dart';
import '../../domain/entities/app_entities.dart';
import '../../domain/repositories/study_repository.dart';
import '../../shared/models/app_enums.dart';
import '../../shared/models/app_view_models.dart';
import '../local/app_database.dart';
import '../remote/app_models.dart';
import '../remote/supabase_remote_data_source.dart';

class StudyRepositoryImpl implements StudyRepository {
  StudyRepositoryImpl({
    required AppDatabase database,
    required SupabaseRemoteDataSource remoteDataSource,
    required SeedService seedService,
    required SyncService syncService,
  }) : _database = database,
       _remoteDataSource = remoteDataSource,
       _seedService = seedService,
       _syncService = syncService;

  final AppDatabase _database;
  final SupabaseRemoteDataSource _remoteDataSource;
  final SeedService _seedService;
  final SyncService _syncService;
  final Uuid _uuid = const Uuid();

  @override
  Future<void> ensureSeededCatalog() async {
    final existing = await _database.select(_database.studyTracksTable).get();
    if (existing.isNotEmpty) return;

    final seed = _seedService.catalog();
    final now = DateTime.now().toUtc();

    for (final track in seed.tracks) {
      await _database.upsertTrack(
        StudyTrackModel(
          id: track.id,
          name: track.name,
          description: track.description,
          iconKey: track.iconKey,
          colorHex: track.colorHex,
          roadmapSummary: track.roadmapSummary,
          createdAt: now,
          updatedAt: now,
        ),
      );

      for (final skill in track.skills) {
        await _database.upsertSkill(
          StudySkillModel(
            id: skill.id,
            trackId: track.id,
            name: skill.name,
            description: skill.description,
            targetLevel: skill.targetLevel,
            sortOrder: skill.sortOrder,
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      for (final module in track.modules) {
        await _database.upsertModule(
          StudyModuleModel(
            id: module.id,
            trackId: track.id,
            title: module.title,
            summary: module.summary,
            estimatedHours: module.estimatedHours,
            sortOrder: module.sortOrder,
            isCore: module.isCore,
            createdAt: now,
            updatedAt: now,
          ),
        );
      }
    }
  }

  @override
  Future<void> sync(String userId) async {
    await _runSync(userId);
  }

  @override
  Future<void> forceSync(String userId) async {
    await _runSync(userId, force: true);
  }

  Future<void> _runSync(String userId, {bool force = false}) async {
    _syncService.markSyncStarted();
    try {
      final flushed = await _syncService.flushPendingQueue(
        ignoreBackoff: force,
      );
      if (flushed.isOffline) {
        _syncService.markOffline();
        return;
      }
      if (flushed.isCooldownOnly) {
        _syncService.markSyncCooldown(
          '${flushed.deferredItems} alteracao(oes) aguardando a proxima janela de retry.',
        );
        return;
      }
      if (!flushed.isSuccessful) {
        _syncService.markSyncFailure(
          flushed.lastError ?? 'Falha ao processar a fila pendente.',
        );
        return;
      }

      final bundle = await _remoteDataSource.fetchAll(userId);
      await _database.replaceRemoteSnapshot(userId, bundle);
      final message = flushed.processedItems > 0
          ? '${flushed.processedItems} alteracao(oes) sincronizadas com a nuvem.'
          : flushed.deferredItems > 0
              ? '${flushed.deferredItems} alteracao(oes) ainda aguardam retry.'
              : 'Local e nuvem ja estavam em dia.';
      _syncService.markSyncSuccess(message);
    } catch (error) {
      _syncService.markSyncFailure(error.toString());
      // Offline-first: mantém operação local enquanto sync remoto falha.
    }
  }

  @override
  Future<ProfileEntity?> getProfile(String userId) async {
    final row = await _database.getProfile(userId);
    if (row == null) return null;
    return _profileFromRow(row);
  }

  @override
  Future<UserGoalEntity?> getGoal(String userId) async {
    final row = await _database.getGoal(userId);
    if (row == null) return null;
    return _goalFromRow(row);
  }

  @override
  Future<AppSettingsEntity?> getSettings(String userId) async {
    final row = await _database.getSettings(userId);
    if (row == null) return null;
    return _settingsFromRow(row);
  }

  @override
  Stream<List<StudySessionEntity>> watchSessions(String userId) {
    return _database
        .watchSessions(userId)
        .map((items) => items.map(_sessionFromRow).toList());
  }

  @override
  Stream<List<TaskEntity>> watchTasks(String userId) {
    return _database
        .watchTasks(userId)
        .map((items) => items.map(_taskFromRow).toList());
  }

  @override
  Stream<List<ReviewEntity>> watchReviews(String userId) {
    return _database
        .watchReviews(userId)
        .map((items) => items.map(_reviewFromRow).toList());
  }

  @override
  Stream<List<ProjectBundle>> watchProjects(String userId) {
    return _database.watchProjects(userId).switchMap((projects) {
      if (projects.isEmpty) return Stream.value(const <ProjectBundle>[]);

      final streams = projects.map((project) {
        return _database
            .watchProjectSteps(project.id)
            .map(
              (steps) => ProjectBundle(
                project: _projectFromRow(project),
                steps: steps.map(_projectStepFromRow).toList(),
              ),
            );
      }).toList();

      return Rx.combineLatestList<ProjectBundle>(streams);
    });
  }

  @override
  Stream<List<StudyNoteEntity>> watchNotes(String userId) {
    return _database.watchNotes(userId).map(
      (items) => items.map(_noteFromRow).toList(),
    );
  }

  @override
  Stream<List<TrackBlueprint>> watchTracks(String userId) {
    return Rx.combineLatest4(
      _database.watchTracks(),
      _database.watchSkills(),
      _database.watchModules(),
      _database.watchProgress(userId),
      (
        List<StudyTracksTableData> tracks,
        List<StudySkillsTableData> skills,
        List<StudyModulesTableData> modules,
        List<UserSkillProgressTableData> progress,
      ) {
        return _buildBlueprints(
          tracks: tracks,
          skills: skills,
          modules: modules,
          progress: progress,
        );
      },
    );
  }

  @override
  Future<List<TrackBlueprint>> getTracks(String userId) {
    return watchTracks(userId).first;
  }

  @override
  Future<TrackBlueprint?> getTrack(String userId, String trackId) async {
    final tracks = await getTracks(userId);
    for (final track in tracks) {
      if (track.track.id == trackId) return track;
    }
    return null;
  }

  @override
  Future<void> completeOnboarding(OnboardingInput input) async {
    final now = DateTime.now().toUtc();
    final plan = StudyPlanGenerator.buildSummary(input);

    final profile = ProfileEntity(
      id: input.userId,
      fullName: input.name,
      desiredArea: input.desiredArea,
      currentLevel: input.currentLevel,
      onboardingCompleted: true,
      selectedTrackId: input.trackId,
      createdAt: now,
      updatedAt: now,
    );

    final goal = UserGoalEntity(
      id: _uuid.v4(),
      userId: input.userId,
      primaryGoal: input.objective,
      desiredArea: input.desiredArea,
      focusType: input.focusType,
      hoursPerDay: input.hoursPerDay,
      daysPerWeek: input.daysPerWeek,
      deadline: input.deadline,
      currentLevel: input.currentLevel,
      generatedPlan: plan,
      createdAt: now,
      updatedAt: now,
    );

    final blueprint = await getTrack(input.userId, input.trackId);
    final progressItems =
        blueprint?.skills
            .map(
              (skill) => UserSkillProgressEntity(
                id: _uuid.v4(),
                userId: input.userId,
                skillId: skill.id,
                progressPercent: 0,
                createdAt: now,
                updatedAt: now,
              ),
            )
            .toList() ??
        const <UserSkillProgressEntity>[];

    final initialTasks =
        blueprint?.modules.take(3).map((module) {
          return TaskEntity(
            id: _uuid.v4(),
            userId: input.userId,
            trackId: input.trackId,
            moduleId: module.id,
            title: 'Iniciar ${module.title}',
            description: module.summary,
            priority: TaskPriority.high,
            status: TaskStatus.pending,
            dueDate: now.add(Duration(days: module.sortOrder * 4)),
            createdAt: now,
            updatedAt: now,
          );
        }).toList() ??
        const <TaskEntity>[];

    final settings = AppSettingsEntity(
      id: input.userId,
      userId: input.userId,
      themePreference: ThemePreference.dark,
      notificationsEnabled: true,
      dailyReminderHour: 20,
      createdAt: now,
      updatedAt: now,
    );

    final profileModel = ProfileModelMapper.fromEntity(profile);
    final goalModel = UserGoalModelMapper.fromEntity(goal);
    final settingsModel = AppSettingsModelMapper.fromEntity(settings);

    await _database.upsertProfile(profileModel, pending: true);
    await _database.queueUpsert(
      id: 'profiles-${profile.id}',
      tableName: 'profiles',
      recordId: profile.id,
      payload: profileModel.toJson(),
    );

    await _database.upsertGoal(goalModel, pending: true);
    await _database.queueUpsert(
      id: 'user_goals-${goal.id}',
      tableName: 'user_goals',
      recordId: goal.id,
      payload: goalModel.toJson(),
    );

    for (final item in progressItems) {
      final model = UserSkillProgressModelMapper.fromEntity(item);
      await _database.upsertProgress(model, pending: true);
      await _database.queueUpsert(
        id: 'user_skill_progress-${item.id}',
        tableName: 'user_skill_progress',
        recordId: item.id,
        payload: model.toJson(),
      );
    }

    for (final task in initialTasks) {
      final model = TaskModelMapper.fromEntity(task);
      await _database.upsertTask(model, pending: true);
      await _database.queueUpsert(
        id: 'tasks-${task.id}',
        tableName: 'tasks',
        recordId: task.id,
        payload: model.toJson(),
      );
    }

    await _database.upsertSettings(settingsModel, pending: true);
    await _database.queueUpsert(
      id: 'app_settings-${settings.id}',
      tableName: 'app_settings',
      recordId: settings.id,
      payload: settingsModel.toJson(),
    );

    await sync(input.userId);
  }

  @override
  Future<void> saveStudySession(StudySessionEntity session) async {
    final previous =
        await (_database.select(_database.studySessionsTable)
              ..where((tbl) => tbl.id.equals(session.id)))
            .getSingleOrNull();
    final model = StudySessionModelMapper.fromEntity(session);
    await _database.upsertSession(model, pending: true);
    await _database.queueUpsert(
      id: 'study_sessions-${session.id}',
      tableName: 'study_sessions',
      recordId: session.id,
      payload: model.toJson(),
    );

    await _refreshSkillProgressForSessionChange(
      userId: session.userId,
      previousSkillId: previous?.skillId,
      nextSkillId: session.skillId,
    );
    await sync(session.userId);
  }

  @override
  Future<void> deleteStudySession(String sessionId) async {
    final existing =
        await (_database.select(_database.studySessionsTable)
              ..where((tbl) => tbl.id.equals(sessionId)))
            .getSingleOrNull();
    if (existing == null) return;

    await _database.deleteSessionById(sessionId);
    await _database.queueDelete(
      id: 'study_sessions-$sessionId',
      tableName: 'study_sessions',
      recordId: sessionId,
    );
    await _refreshSkillProgressForSkill(
      userId: existing.userId,
      skillId: existing.skillId,
    );
    await sync(existing.userId);
  }

  @override
  Future<void> saveTask(TaskEntity task) async {
    final model = TaskModelMapper.fromEntity(task);
    await _database.upsertTask(model, pending: true);
    await _database.queueUpsert(
      id: 'tasks-${task.id}',
      tableName: 'tasks',
      recordId: task.id,
      payload: model.toJson(),
    );
    await sync(task.userId);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final existing =
        await (_database.select(_database.tasksTable)
              ..where((tbl) => tbl.id.equals(taskId)))
            .getSingleOrNull();
    await _database.deleteTaskById(taskId);
    await _database.queueDelete(
      id: 'tasks-$taskId',
      tableName: 'tasks',
      recordId: taskId,
    );
    await _syncIfPossible(existing?.userId);
  }

  @override
  Future<void> saveReview(ReviewEntity review) async {
    final model = ReviewModelMapper.fromEntity(review);
    await _database.upsertReview(model, pending: true);
    await _database.queueUpsert(
      id: 'reviews-${review.id}',
      tableName: 'reviews',
      recordId: review.id,
      payload: model.toJson(),
    );
    await sync(review.userId);
  }

  @override
  Future<void> saveReviews(List<ReviewEntity> reviews) async {
    for (final review in reviews) {
      final model = ReviewModelMapper.fromEntity(review);
      await _database.upsertReview(model, pending: true);
      await _database.queueUpsert(
        id: 'reviews-${review.id}',
        tableName: 'reviews',
        recordId: review.id,
        payload: model.toJson(),
      );
    }
    if (reviews.isNotEmpty) {
      await sync(reviews.first.userId);
    }
  }

  @override
  Future<void> completeReview(ReviewEntity review) async {
    await saveReview(
      review.copyWith(
        status: ReviewStatus.completed,
        completedAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    final existing =
        await (_database.select(_database.reviewsTable)
              ..where((tbl) => tbl.id.equals(reviewId)))
            .getSingleOrNull();
    await _database.deleteReviewById(reviewId);
    await _database.queueDelete(
      id: 'reviews-$reviewId',
      tableName: 'reviews',
      recordId: reviewId,
    );
    await _syncIfPossible(existing?.userId);
  }

  @override
  Future<void> saveProject(ProjectEntity project) async {
    final model = ProjectModelMapper.fromEntity(project);
    await _database.upsertProject(model, pending: true);
    await _database.queueUpsert(
      id: 'projects-${project.id}',
      tableName: 'projects',
      recordId: project.id,
      payload: model.toJson(),
    );
    await sync(project.userId);
  }

  @override
  Future<void> saveProjectStep(ProjectStepEntity step) async {
    final model = ProjectStepModelMapper.fromEntity(step);
    await _database.upsertProjectStep(model, pending: true);
    await _database.queueUpsert(
      id: 'project_steps-${step.id}',
      tableName: 'project_steps',
      recordId: step.id,
      payload: model.toJson(),
    );
    await _refreshProjectProgress(step.projectId);
  }

  @override
  Future<void> deleteProjectStep(String stepId) async {
    final existing =
        await (_database.select(_database.projectStepsTable)
              ..where((tbl) => tbl.id.equals(stepId)))
            .getSingleOrNull();
    if (existing == null) return;

    await _database.deleteProjectStepById(stepId);
    await _database.queueDelete(
      id: 'project_steps-$stepId',
      tableName: 'project_steps',
      recordId: stepId,
    );
    await _refreshProjectProgress(existing.projectId);
  }

  @override
  Future<void> deleteProject(String projectId) async {
    final existing =
        await (_database.select(_database.projectsTable)
              ..where((tbl) => tbl.id.equals(projectId)))
            .getSingleOrNull();
    final steps =
        await (_database.select(_database.projectStepsTable)
              ..where((tbl) => tbl.projectId.equals(projectId)))
            .get();
    await _database.deleteProjectById(projectId);
    for (final step in steps) {
      await _database.queueDelete(
        id: 'project_steps-${step.id}',
        tableName: 'project_steps',
        recordId: step.id,
      );
    }
    await _database.queueDelete(
      id: 'projects-$projectId',
      tableName: 'projects',
      recordId: projectId,
    );
    await _syncIfPossible(existing?.userId);
  }

  @override
  Future<void> saveNote(StudyNoteEntity note) async {
    final model = StudyNoteModelMapper.fromEntity(note);
    await _database.upsertNote(
      StudyNotesTableCompanion.insert(
        id: model.id,
        userId: model.userId,
        folderName: model.folderName,
        title: model.title,
        content: model.content,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      ),
      pending: true,
    );
    await _database.queueUpsert(
      id: 'study_notes-${note.id}',
      tableName: 'study_notes',
      recordId: note.id,
      payload: {
        'id': model.id,
        'user_id': model.userId,
        'folder_name': model.folderName,
        'title': model.title,
        'content': model.content,
        'created_at': model.createdAt.toIso8601String(),
        'updated_at': model.updatedAt.toIso8601String(),
      },
    );
    await sync(note.userId);
  }

  @override
  Future<void> deleteNote(String noteId) async {
    final existing =
        await (_database.select(_database.studyNotesTable)
              ..where((tbl) => tbl.id.equals(noteId)))
            .getSingleOrNull();
    await _database.deleteNoteById(noteId);
    await _database.queueDelete(
      id: 'study_notes-$noteId',
      tableName: 'study_notes',
      recordId: noteId,
    );
    await _syncIfPossible(existing?.userId);
  }

  @override
  Future<void> saveProfile(ProfileEntity profile) async {
    final model = ProfileModelMapper.fromEntity(profile);
    await _database.upsertProfile(model, pending: true);
    await _database.queueUpsert(
      id: 'profiles-${profile.id}',
      tableName: 'profiles',
      recordId: profile.id,
      payload: model.toJson(),
    );
    await sync(profile.id);
  }

  @override
  Future<void> saveGoal(UserGoalEntity goal) async {
    final model = UserGoalModelMapper.fromEntity(goal);
    await _database.upsertGoal(model, pending: true);
    await _database.queueUpsert(
      id: 'user_goals-${goal.id}',
      tableName: 'user_goals',
      recordId: goal.id,
      payload: model.toJson(),
    );
    await sync(goal.userId);
  }

  @override
  Future<void> saveSettings(AppSettingsEntity settings) async {
    final model = AppSettingsModelMapper.fromEntity(settings);
    await _database.upsertSettings(model, pending: true);
    await _database.queueUpsert(
      id: 'app_settings-${settings.userId}',
      tableName: 'app_settings',
      recordId: settings.id,
      payload: model.toJson(),
    );
    await sync(settings.userId);
  }

  Future<void> _refreshProjectProgress(String projectId) async {
    final projectRow = await (_database.select(
      _database.projectsTable,
    )..where((tbl) => tbl.id.equals(projectId))).getSingleOrNull();
    if (projectRow == null) return;

    final steps = await (_database.select(
      _database.projectStepsTable,
    )..where((tbl) => tbl.projectId.equals(projectId))).get();

    final doneCount = steps.where((step) => step.isDone).length;
    final progress = steps.isEmpty ? 0.0 : (doneCount / steps.length) * 100;

    final updatedProject = _projectFromRow(
      projectRow,
    ).copyWith(progressPercent: progress, updatedAt: DateTime.now().toUtc());

    await saveProject(updatedProject);
  }

  Future<void> _refreshSkillProgressForSessionChange({
    required String userId,
    required String? previousSkillId,
    required String? nextSkillId,
  }) async {
    if (previousSkillId != null) {
      await _refreshSkillProgressForSkill(
        userId: userId,
        skillId: previousSkillId,
      );
    }
    if (nextSkillId != null && nextSkillId != previousSkillId) {
      await _refreshSkillProgressForSkill(userId: userId, skillId: nextSkillId);
    }
  }

  Future<void> _refreshSkillProgressForSkill({
    required String userId,
    required String? skillId,
  }) async {
    if (skillId == null) return;

    final current =
        await (_database.select(_database.userSkillProgressTable)
              ..where((tbl) => tbl.skillId.equals(skillId))
              ..where((tbl) => tbl.userId.equals(userId)))
            .getSingleOrNull();

    final sessions =
        await (_database.select(_database.studySessionsTable)
              ..where((tbl) => tbl.userId.equals(userId))
              ..where((tbl) => tbl.skillId.equals(skillId)))
            .get();

    final now = DateTime.now().toUtc();
    final lastStudiedAt = sessions.isEmpty
        ? null
        : sessions
            .map((item) => item.endTime)
            .reduce((a, b) => a.isAfter(b) ? a : b);
    final progressPercent = (sessions.length * 8).clamp(0, 100).toDouble();
    final updated = UserSkillProgressEntity(
      id: current?.id ?? _uuid.v4(),
      userId: userId,
      skillId: skillId,
      progressPercent: progressPercent,
      lastStudiedAt: lastStudiedAt,
      createdAt: current?.createdAt ?? now,
      updatedAt: now,
    );

    final model = UserSkillProgressModelMapper.fromEntity(updated);
    await _database.upsertProgress(model, pending: true);
    await _database.queueUpsert(
      id: 'user_skill_progress-${updated.id}',
      tableName: 'user_skill_progress',
      recordId: updated.id,
      payload: model.toJson(),
    );
  }

  Future<void> _syncIfPossible(String? userId) async {
    if (userId == null || userId.isEmpty) return;
    await sync(userId);
  }

  List<TrackBlueprint> _buildBlueprints({
    required List<StudyTracksTableData> tracks,
    required List<StudySkillsTableData> skills,
    required List<StudyModulesTableData> modules,
    required List<UserSkillProgressTableData> progress,
  }) {
    final progressBySkill = {
      for (final item in progress) item.skillId: _progressFromRow(item),
    };

    return tracks.map((track) {
      final trackSkills = skills
          .where((skill) => skill.trackId == track.id)
          .map(_skillFromRow)
          .toList();
      final trackModules = modules
          .where((module) => module.trackId == track.id)
          .map(_moduleFromRow)
          .toList();

      return TrackBlueprint(
        track: _trackFromRow(track),
        skills: trackSkills,
        modules: trackModules,
        progressBySkill: {
          for (final skill in trackSkills)
            if (progressBySkill.containsKey(skill.id))
              skill.id: progressBySkill[skill.id]!,
        },
      );
    }).toList();
  }
}

ProfileEntity _profileFromRow(ProfilesTableData row) => ProfileEntity(
  id: row.id,
  fullName: row.fullName,
  email: row.email,
  desiredArea: row.desiredArea,
  currentLevel: SkillLevel.values.byName(row.currentLevel),
  onboardingCompleted: row.onboardingCompleted,
  selectedTrackId: row.selectedTrackId,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
);

UserGoalEntity _goalFromRow(UserGoalsTableData row) => UserGoalEntity(
  id: row.id,
  userId: row.userId,
  primaryGoal: row.primaryGoal,
  desiredArea: row.desiredArea,
  focusType: FocusType.values.byName(row.focusType),
  hoursPerDay: row.hoursPerDay,
  daysPerWeek: row.daysPerWeek,
  deadline: row.deadline,
  currentLevel: SkillLevel.values.byName(row.currentLevel),
  generatedPlan: row.generatedPlan,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
);

AppSettingsEntity _settingsFromRow(AppSettingsTableData row) =>
    AppSettingsEntity(
      id: row.id,
      userId: row.userId,
      themePreference: ThemePreference.values.byName(row.themePreference),
      notificationsEnabled: row.notificationsEnabled,
      dailyReminderHour: row.dailyReminderHour,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );

StudyTrackEntity _trackFromRow(StudyTracksTableData row) => StudyTrackEntity(
  id: row.id,
  name: row.name,
  description: row.description,
  iconKey: row.iconKey,
  colorHex: row.colorHex,
  roadmapSummary: row.roadmapSummary,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
);

StudySkillEntity _skillFromRow(StudySkillsTableData row) => StudySkillEntity(
  id: row.id,
  trackId: row.trackId,
  name: row.name,
  description: row.description,
  targetLevel: SkillLevel.values.byName(row.targetLevel),
  sortOrder: row.sortOrder,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
);

StudyModuleEntity _moduleFromRow(StudyModulesTableData row) =>
    StudyModuleEntity(
      id: row.id,
      trackId: row.trackId,
      title: row.title,
      summary: row.summary,
      estimatedHours: row.estimatedHours,
      sortOrder: row.sortOrder,
      isCore: row.isCore,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );

UserSkillProgressEntity _progressFromRow(UserSkillProgressTableData row) =>
    UserSkillProgressEntity(
      id: row.id,
      userId: row.userId,
      skillId: row.skillId,
      progressPercent: row.progressPercent,
      lastStudiedAt: row.lastStudiedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );

StudySessionEntity _sessionFromRow(StudySessionsTableData row) =>
    StudySessionEntity(
      id: row.id,
      userId: row.userId,
      trackId: row.trackId,
      skillId: row.skillId,
      moduleId: row.moduleId,
      type: SessionType.values.byName(row.type),
      startTime: row.startTime,
      endTime: row.endTime,
      durationMinutes: row.durationMinutes,
      notes: row.notes,
      productivityScore: row.productivityScore,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );

TaskEntity _taskFromRow(TasksTableData row) => TaskEntity(
  id: row.id,
  userId: row.userId,
  trackId: row.trackId,
  moduleId: row.moduleId,
  title: row.title,
  description: row.description,
  priority: TaskPriority.values.byName(row.priority),
  status: TaskStatus.values.byName(row.status),
  dueDate: row.dueDate,
  completedAt: row.completedAt,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
);

ReviewEntity _reviewFromRow(ReviewsTableData row) => ReviewEntity(
  id: row.id,
  userId: row.userId,
  sessionId: row.sessionId,
  trackId: row.trackId,
  skillId: row.skillId,
  title: row.title,
  scheduledFor: row.scheduledFor,
  status: ReviewStatus.values.byName(row.status),
  intervalLabel: row.intervalLabel,
  notes: row.notes,
  completedAt: row.completedAt,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
);

ProjectEntity _projectFromRow(ProjectsTableData row) => ProjectEntity(
  id: row.id,
  userId: row.userId,
  trackId: row.trackId,
  title: row.title,
  scope: row.scope,
  description: row.description,
  repositoryUrl: row.repositoryUrl,
  documentationUrl: row.documentationUrl,
  videoUrl: row.videoUrl,
  status: ProjectStatus.values.byName(row.status),
  progressPercent: row.progressPercent,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
);

ProjectStepEntity _projectStepFromRow(ProjectStepsTableData row) =>
    ProjectStepEntity(
      id: row.id,
      projectId: row.projectId,
      title: row.title,
      description: row.description,
      isDone: row.isDone,
      sortOrder: row.sortOrder,
      completedAt: row.completedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );

StudyNoteEntity _noteFromRow(StudyNotesTableData row) => StudyNoteEntity(
  id: row.id,
  userId: row.userId,
  folderName: row.folderName,
  title: row.title,
  content: row.content,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
);
