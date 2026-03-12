import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/models/app_enums.dart';

part 'app_entities.freezed.dart';

@freezed
abstract class ProfileEntity with _$ProfileEntity {
  const factory ProfileEntity({
    required String id,
    required String fullName,
    String? email,
    required String desiredArea,
    required SkillLevel currentLevel,
    required bool onboardingCompleted,
    String? selectedTrackId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProfileEntity;
}

@freezed
abstract class UserGoalEntity with _$UserGoalEntity {
  const factory UserGoalEntity({
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
  }) = _UserGoalEntity;
}

@freezed
abstract class StudyTrackEntity with _$StudyTrackEntity {
  const factory StudyTrackEntity({
    required String id,
    required String name,
    required String description,
    required String iconKey,
    required String colorHex,
    required String roadmapSummary,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudyTrackEntity;
}

@freezed
abstract class StudySkillEntity with _$StudySkillEntity {
  const factory StudySkillEntity({
    required String id,
    required String trackId,
    required String name,
    required String description,
    required SkillLevel targetLevel,
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudySkillEntity;
}

@freezed
abstract class UserSkillProgressEntity with _$UserSkillProgressEntity {
  const factory UserSkillProgressEntity({
    required String id,
    required String userId,
    required String skillId,
    required double progressPercent,
    DateTime? lastStudiedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserSkillProgressEntity;
}

@freezed
abstract class StudyModuleEntity with _$StudyModuleEntity {
  const factory StudyModuleEntity({
    required String id,
    required String trackId,
    required String title,
    required String summary,
    required int estimatedHours,
    required int sortOrder,
    required bool isCore,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudyModuleEntity;
}

@freezed
abstract class StudySessionEntity with _$StudySessionEntity {
  const factory StudySessionEntity({
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
  }) = _StudySessionEntity;
}

@freezed
abstract class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
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
  }) = _TaskEntity;
}

@freezed
abstract class ReviewEntity with _$ReviewEntity {
  const factory ReviewEntity({
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
  }) = _ReviewEntity;
}

@freezed
abstract class ProjectEntity with _$ProjectEntity {
  const factory ProjectEntity({
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
  }) = _ProjectEntity;
}

@freezed
abstract class ProjectStepEntity with _$ProjectStepEntity {
  const factory ProjectStepEntity({
    required String id,
    required String projectId,
    required String title,
    required String description,
    required bool isDone,
    required int sortOrder,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProjectStepEntity;
}

@freezed
abstract class StudyNoteEntity with _$StudyNoteEntity {
  const factory StudyNoteEntity({
    required String id,
    required String userId,
    required String folderName,
    required String title,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudyNoteEntity;
}

@freezed
abstract class FlashcardEntity with _$FlashcardEntity {
  const factory FlashcardEntity({
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
  }) = _FlashcardEntity;
}

@freezed
abstract class MindMapEntity with _$MindMapEntity {
  const factory MindMapEntity({
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
  }) = _MindMapEntity;
}

@freezed
abstract class AppSettingsEntity with _$AppSettingsEntity {
  const factory AppSettingsEntity({
    required String id,
    required String userId,
    required ThemePreference themePreference,
    required bool notificationsEnabled,
    int? dailyReminderHour,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppSettingsEntity;
}
