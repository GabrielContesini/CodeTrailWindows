import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/app_entities.dart';
import '../../shared/models/app_enums.dart';

part 'app_models.freezed.dart';
part 'app_models.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ProfileModel({
    required String id,
    required String fullName,
    String? email,
    required String desiredArea,
    required SkillLevel currentLevel,
    required bool onboardingCompleted,
    String? selectedTrackId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

@freezed
abstract class UserGoalModel with _$UserGoalModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserGoalModel({
    required String id,
    required String userId,
    required String primaryGoal,
    required String desiredArea,
    required FocusType focusType,
    required int hoursPerDay,
    required int daysPerWeek,
    required DateTime deadline,
    required SkillLevel currentLevel,
    required String generatedPlan,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserGoalModel;

  factory UserGoalModel.fromJson(Map<String, dynamic> json) =>
      _$UserGoalModelFromJson(json);
}

@freezed
abstract class StudyTrackModel with _$StudyTrackModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory StudyTrackModel({
    required String id,
    required String name,
    required String description,
    required String iconKey,
    required String colorHex,
    required String roadmapSummary,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudyTrackModel;

  factory StudyTrackModel.fromJson(Map<String, dynamic> json) =>
      _$StudyTrackModelFromJson(json);
}

@freezed
abstract class StudySkillModel with _$StudySkillModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory StudySkillModel({
    required String id,
    required String trackId,
    required String name,
    required String description,
    required SkillLevel targetLevel,
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudySkillModel;

  factory StudySkillModel.fromJson(Map<String, dynamic> json) =>
      _$StudySkillModelFromJson(json);
}

@freezed
abstract class UserSkillProgressModel with _$UserSkillProgressModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserSkillProgressModel({
    required String id,
    required String userId,
    required String skillId,
    required double progressPercent,
    DateTime? lastStudiedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserSkillProgressModel;

  factory UserSkillProgressModel.fromJson(Map<String, dynamic> json) =>
      _$UserSkillProgressModelFromJson(json);
}

@freezed
abstract class StudyModuleModel with _$StudyModuleModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory StudyModuleModel({
    required String id,
    required String trackId,
    required String title,
    required String summary,
    required int estimatedHours,
    required int sortOrder,
    required bool isCore,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudyModuleModel;

  factory StudyModuleModel.fromJson(Map<String, dynamic> json) =>
      _$StudyModuleModelFromJson(json);
}

@freezed
abstract class StudySessionModel with _$StudySessionModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory StudySessionModel({
    required String id,
    required String userId,
    String? trackId,
    String? skillId,
    String? moduleId,
    required SessionType type,
    required DateTime startTime,
    required DateTime endTime,
    required int durationMinutes,
    required String notes,
    required int productivityScore,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudySessionModel;

  factory StudySessionModel.fromJson(Map<String, dynamic> json) =>
      _$StudySessionModelFromJson(json);
}

@freezed
abstract class TaskModel with _$TaskModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TaskModel({
    required String id,
    required String userId,
    String? trackId,
    String? moduleId,
    required String title,
    required String description,
    required TaskPriority priority,
    required TaskStatus status,
    DateTime? dueDate,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}

@freezed
abstract class ReviewModel with _$ReviewModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ReviewModel({
    required String id,
    required String userId,
    String? sessionId,
    String? trackId,
    String? skillId,
    required String title,
    required DateTime scheduledFor,
    required ReviewStatus status,
    required String intervalLabel,
    String? notes,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}

@freezed
abstract class ProjectModel with _$ProjectModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ProjectModel({
    required String id,
    required String userId,
    String? trackId,
    required String title,
    required String scope,
    required String description,
    String? repositoryUrl,
    String? documentationUrl,
    String? videoUrl,
    required ProjectStatus status,
    required double progressPercent,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);
}

@freezed
abstract class ProjectStepModel with _$ProjectStepModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ProjectStepModel({
    required String id,
    required String projectId,
    required String title,
    required String description,
    required bool isDone,
    required int sortOrder,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProjectStepModel;

  factory ProjectStepModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectStepModelFromJson(json);
}

@freezed
abstract class StudyNoteModel with _$StudyNoteModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory StudyNoteModel({
    required String id,
    required String userId,
    required String folderName,
    required String title,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudyNoteModel;

  factory StudyNoteModel.fromJson(Map<String, dynamic> json) =>
      _$StudyNoteModelFromJson(json);
}

@freezed
abstract class FlashcardModel with _$FlashcardModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FlashcardModel({
    required String id,
    required String userId,
    required String deckName,
    required String question,
    required String answer,
    String? trackId,
    String? moduleId,
    String? projectId,
    required DateTime dueAt,
    DateTime? lastReviewedAt,
    required int reviewCount,
    required int correctStreak,
    required double easeFactor,
    required int intervalDays,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FlashcardModel;

  factory FlashcardModel.fromJson(Map<String, dynamic> json) =>
      _$FlashcardModelFromJson(json);
}

@freezed
abstract class MindMapModel with _$MindMapModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MindMapModel({
    required String id,
    required String userId,
    required String folderName,
    required String title,
    required String contentJson,
    String? trackId,
    String? moduleId,
    String? projectId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MindMapModel;

  factory MindMapModel.fromJson(Map<String, dynamic> json) =>
      _$MindMapModelFromJson(json);
}

@freezed
abstract class AppSettingsModel with _$AppSettingsModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AppSettingsModel({
    required String id,
    required String userId,
    required ThemePreference themePreference,
    required bool notificationsEnabled,
    int? dailyReminderHour,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppSettingsModel;

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);
}

extension ProfileModelMapper on ProfileModel {
  ProfileEntity toEntity() => ProfileEntity(
    id: id,
    fullName: fullName,
    email: email,
    desiredArea: desiredArea,
    currentLevel: currentLevel,
    onboardingCompleted: onboardingCompleted,
    selectedTrackId: selectedTrackId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static ProfileModel fromEntity(ProfileEntity entity) => ProfileModel(
    id: entity.id,
    fullName: entity.fullName,
    email: entity.email,
    desiredArea: entity.desiredArea,
    currentLevel: entity.currentLevel,
    onboardingCompleted: entity.onboardingCompleted,
    selectedTrackId: entity.selectedTrackId,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}

extension UserGoalModelMapper on UserGoalModel {
  UserGoalEntity toEntity() => UserGoalEntity(
    id: id,
    userId: userId,
    primaryGoal: primaryGoal,
    desiredArea: desiredArea,
    focusType: focusType,
    hoursPerDay: hoursPerDay,
    daysPerWeek: daysPerWeek,
    deadline: deadline,
    currentLevel: currentLevel,
    generatedPlan: generatedPlan,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static UserGoalModel fromEntity(UserGoalEntity entity) => UserGoalModel(
    id: entity.id,
    userId: entity.userId,
    primaryGoal: entity.primaryGoal,
    desiredArea: entity.desiredArea,
    focusType: entity.focusType,
    hoursPerDay: entity.hoursPerDay,
    daysPerWeek: entity.daysPerWeek,
    deadline: entity.deadline,
    currentLevel: entity.currentLevel,
    generatedPlan: entity.generatedPlan,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}

extension StudyTrackModelMapper on StudyTrackModel {
  StudyTrackEntity toEntity() => StudyTrackEntity(
    id: id,
    name: name,
    description: description,
    iconKey: iconKey,
    colorHex: colorHex,
    roadmapSummary: roadmapSummary,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static StudyTrackModel fromEntity(StudyTrackEntity entity) => StudyTrackModel(
    id: entity.id,
    name: entity.name,
    description: entity.description,
    iconKey: entity.iconKey,
    colorHex: entity.colorHex,
    roadmapSummary: entity.roadmapSummary,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}

extension StudySkillModelMapper on StudySkillModel {
  StudySkillEntity toEntity() => StudySkillEntity(
    id: id,
    trackId: trackId,
    name: name,
    description: description,
    targetLevel: targetLevel,
    sortOrder: sortOrder,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static StudySkillModel fromEntity(StudySkillEntity entity) => StudySkillModel(
    id: entity.id,
    trackId: entity.trackId,
    name: entity.name,
    description: entity.description,
    targetLevel: entity.targetLevel,
    sortOrder: entity.sortOrder,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}

extension UserSkillProgressModelMapper on UserSkillProgressModel {
  UserSkillProgressEntity toEntity() => UserSkillProgressEntity(
    id: id,
    userId: userId,
    skillId: skillId,
    progressPercent: progressPercent,
    lastStudiedAt: lastStudiedAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static UserSkillProgressModel fromEntity(UserSkillProgressEntity entity) =>
      UserSkillProgressModel(
        id: entity.id,
        userId: entity.userId,
        skillId: entity.skillId,
        progressPercent: entity.progressPercent,
        lastStudiedAt: entity.lastStudiedAt,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}

extension StudyModuleModelMapper on StudyModuleModel {
  StudyModuleEntity toEntity() => StudyModuleEntity(
    id: id,
    trackId: trackId,
    title: title,
    summary: summary,
    estimatedHours: estimatedHours,
    sortOrder: sortOrder,
    isCore: isCore,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static StudyModuleModel fromEntity(StudyModuleEntity entity) =>
      StudyModuleModel(
        id: entity.id,
        trackId: entity.trackId,
        title: entity.title,
        summary: entity.summary,
        estimatedHours: entity.estimatedHours,
        sortOrder: entity.sortOrder,
        isCore: entity.isCore,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}

extension StudySessionModelMapper on StudySessionModel {
  StudySessionEntity toEntity() => StudySessionEntity(
    id: id,
    userId: userId,
    trackId: trackId,
    skillId: skillId,
    moduleId: moduleId,
    type: type,
    startTime: startTime,
    endTime: endTime,
    durationMinutes: durationMinutes,
    notes: notes,
    productivityScore: productivityScore,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static StudySessionModel fromEntity(StudySessionEntity entity) =>
      StudySessionModel(
        id: entity.id,
        userId: entity.userId,
        trackId: entity.trackId,
        skillId: entity.skillId,
        moduleId: entity.moduleId,
        type: entity.type,
        startTime: entity.startTime,
        endTime: entity.endTime,
        durationMinutes: entity.durationMinutes,
        notes: entity.notes,
        productivityScore: entity.productivityScore,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}

extension TaskModelMapper on TaskModel {
  TaskEntity toEntity() => TaskEntity(
    id: id,
    userId: userId,
    trackId: trackId,
    moduleId: moduleId,
    title: title,
    description: description,
    priority: priority,
    status: status,
    dueDate: dueDate,
    completedAt: completedAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static TaskModel fromEntity(TaskEntity entity) => TaskModel(
    id: entity.id,
    userId: entity.userId,
    trackId: entity.trackId,
    moduleId: entity.moduleId,
    title: entity.title,
    description: entity.description,
    priority: entity.priority,
    status: entity.status,
    dueDate: entity.dueDate,
    completedAt: entity.completedAt,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}

extension ReviewModelMapper on ReviewModel {
  ReviewEntity toEntity() => ReviewEntity(
    id: id,
    userId: userId,
    sessionId: sessionId,
    trackId: trackId,
    skillId: skillId,
    title: title,
    scheduledFor: scheduledFor,
    status: status,
    intervalLabel: intervalLabel,
    notes: notes,
    completedAt: completedAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static ReviewModel fromEntity(ReviewEntity entity) => ReviewModel(
    id: entity.id,
    userId: entity.userId,
    sessionId: entity.sessionId,
    trackId: entity.trackId,
    skillId: entity.skillId,
    title: entity.title,
    scheduledFor: entity.scheduledFor,
    status: entity.status,
    intervalLabel: entity.intervalLabel,
    notes: entity.notes,
    completedAt: entity.completedAt,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}

extension ProjectModelMapper on ProjectModel {
  ProjectEntity toEntity() => ProjectEntity(
    id: id,
    userId: userId,
    trackId: trackId,
    title: title,
    scope: scope,
    description: description,
    repositoryUrl: repositoryUrl,
    documentationUrl: documentationUrl,
    videoUrl: videoUrl,
    status: status,
    progressPercent: progressPercent,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static ProjectModel fromEntity(ProjectEntity entity) => ProjectModel(
    id: entity.id,
    userId: entity.userId,
    trackId: entity.trackId,
    title: entity.title,
    scope: entity.scope,
    description: entity.description,
    repositoryUrl: entity.repositoryUrl,
    documentationUrl: entity.documentationUrl,
    videoUrl: entity.videoUrl,
    status: entity.status,
    progressPercent: entity.progressPercent,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}

extension ProjectStepModelMapper on ProjectStepModel {
  ProjectStepEntity toEntity() => ProjectStepEntity(
    id: id,
    projectId: projectId,
    title: title,
    description: description,
    isDone: isDone,
    sortOrder: sortOrder,
    completedAt: completedAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static ProjectStepModel fromEntity(ProjectStepEntity entity) =>
      ProjectStepModel(
        id: entity.id,
        projectId: entity.projectId,
        title: entity.title,
        description: entity.description,
        isDone: entity.isDone,
        sortOrder: entity.sortOrder,
        completedAt: entity.completedAt,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}

extension StudyNoteModelMapper on StudyNoteModel {
  StudyNoteEntity toEntity() => StudyNoteEntity(
    id: id,
    userId: userId,
    folderName: folderName,
    title: title,
    content: content,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static StudyNoteModel fromEntity(StudyNoteEntity entity) => StudyNoteModel(
    id: entity.id,
    userId: entity.userId,
    folderName: entity.folderName,
    title: entity.title,
    content: entity.content,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}

extension FlashcardModelMapper on FlashcardModel {
  FlashcardEntity toEntity() => FlashcardEntity(
    id: id,
    userId: userId,
    deckName: deckName,
    question: question,
    answer: answer,
    trackId: trackId,
    moduleId: moduleId,
    projectId: projectId,
    dueAt: dueAt,
    lastReviewedAt: lastReviewedAt,
    reviewCount: reviewCount,
    correctStreak: correctStreak,
    easeFactor: easeFactor,
    intervalDays: intervalDays,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static FlashcardModel fromEntity(FlashcardEntity entity) => FlashcardModel(
    id: entity.id,
    userId: entity.userId,
    deckName: entity.deckName,
    question: entity.question,
    answer: entity.answer,
    trackId: entity.trackId,
    moduleId: entity.moduleId,
    projectId: entity.projectId,
    dueAt: entity.dueAt,
    lastReviewedAt: entity.lastReviewedAt,
    reviewCount: entity.reviewCount,
    correctStreak: entity.correctStreak,
    easeFactor: entity.easeFactor,
    intervalDays: entity.intervalDays,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}

extension MindMapModelMapper on MindMapModel {
  MindMapEntity toEntity() => MindMapEntity(
    id: id,
    userId: userId,
    folderName: folderName,
    title: title,
    contentJson: contentJson,
    trackId: trackId,
    moduleId: moduleId,
    projectId: projectId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static MindMapModel fromEntity(MindMapEntity entity) => MindMapModel(
    id: entity.id,
    userId: entity.userId,
    folderName: entity.folderName,
    title: entity.title,
    contentJson: entity.contentJson,
    trackId: entity.trackId,
    moduleId: entity.moduleId,
    projectId: entity.projectId,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}

extension AppSettingsModelMapper on AppSettingsModel {
  AppSettingsEntity toEntity() => AppSettingsEntity(
    id: id,
    userId: userId,
    themePreference: themePreference,
    notificationsEnabled: notificationsEnabled,
    dailyReminderHour: dailyReminderHour,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static AppSettingsModel fromEntity(AppSettingsEntity entity) =>
      AppSettingsModel(
        id: entity.id,
        userId: entity.userId,
        themePreference: entity.themePreference,
        notificationsEnabled: entity.notificationsEnabled,
        dailyReminderHour: entity.dailyReminderHour,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}

class RemoteSyncBundle {
  const RemoteSyncBundle({
    required this.profiles,
    required this.goals,
    required this.tracks,
    required this.skills,
    required this.progress,
    required this.modules,
    required this.sessions,
    required this.tasks,
    required this.reviews,
    required this.projects,
    required this.projectSteps,
    required this.notes,
    required this.flashcards,
    required this.mindMaps,
    required this.settings,
    this.notesAvailable = true,
    this.flashcardsAvailable = true,
    this.mindMapsAvailable = true,
  });

  final List<ProfileModel> profiles;
  final List<UserGoalModel> goals;
  final List<StudyTrackModel> tracks;
  final List<StudySkillModel> skills;
  final List<UserSkillProgressModel> progress;
  final List<StudyModuleModel> modules;
  final List<StudySessionModel> sessions;
  final List<TaskModel> tasks;
  final List<ReviewModel> reviews;
  final List<ProjectModel> projects;
  final List<ProjectStepModel> projectSteps;
  final List<StudyNoteModel> notes;
  final List<FlashcardModel> flashcards;
  final List<MindMapModel> mindMaps;
  final List<AppSettingsModel> settings;
  final bool notesAvailable;
  final bool flashcardsAvailable;
  final bool mindMapsAvailable;
}
