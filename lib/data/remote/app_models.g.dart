// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) =>
    _ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String?,
      desiredArea: json['desired_area'] as String,
      currentLevel: $enumDecode(_$SkillLevelEnumMap, json['current_level']),
      onboardingCompleted: json['onboarding_completed'] as bool,
      selectedTrackId: json['selected_track_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ProfileModelToJson(_ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'email': instance.email,
      'desired_area': instance.desiredArea,
      'current_level': _$SkillLevelEnumMap[instance.currentLevel]!,
      'onboarding_completed': instance.onboardingCompleted,
      'selected_track_id': instance.selectedTrackId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$SkillLevelEnumMap = {
  SkillLevel.beginner: 'beginner',
  SkillLevel.junior: 'junior',
  SkillLevel.midLevel: 'mid_level',
  SkillLevel.senior: 'senior',
};

_UserGoalModel _$UserGoalModelFromJson(Map<String, dynamic> json) =>
    _UserGoalModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      primaryGoal: json['primary_goal'] as String,
      desiredArea: json['desired_area'] as String,
      focusType: $enumDecode(_$FocusTypeEnumMap, json['focus_type']),
      hoursPerDay: (json['hours_per_day'] as num).toInt(),
      daysPerWeek: (json['days_per_week'] as num).toInt(),
      deadline: DateTime.parse(json['deadline'] as String),
      currentLevel: $enumDecode(_$SkillLevelEnumMap, json['current_level']),
      generatedPlan: json['generated_plan'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserGoalModelToJson(_UserGoalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'primary_goal': instance.primaryGoal,
      'desired_area': instance.desiredArea,
      'focus_type': _$FocusTypeEnumMap[instance.focusType]!,
      'hours_per_day': instance.hoursPerDay,
      'days_per_week': instance.daysPerWeek,
      'deadline': instance.deadline.toIso8601String(),
      'current_level': _$SkillLevelEnumMap[instance.currentLevel]!,
      'generated_plan': instance.generatedPlan,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$FocusTypeEnumMap = {
  FocusType.job: 'job',
  FocusType.promotion: 'promotion',
  FocusType.freelance: 'freelance',
  FocusType.solidFoundation: 'solid_foundation',
  FocusType.careerTransition: 'career_transition',
};

_StudyTrackModel _$StudyTrackModelFromJson(Map<String, dynamic> json) =>
    _StudyTrackModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconKey: json['icon_key'] as String,
      colorHex: json['color_hex'] as String,
      roadmapSummary: json['roadmap_summary'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$StudyTrackModelToJson(_StudyTrackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon_key': instance.iconKey,
      'color_hex': instance.colorHex,
      'roadmap_summary': instance.roadmapSummary,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_StudySkillModel _$StudySkillModelFromJson(Map<String, dynamic> json) =>
    _StudySkillModel(
      id: json['id'] as String,
      trackId: json['track_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      targetLevel: $enumDecode(_$SkillLevelEnumMap, json['target_level']),
      sortOrder: (json['sort_order'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$StudySkillModelToJson(_StudySkillModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'track_id': instance.trackId,
      'name': instance.name,
      'description': instance.description,
      'target_level': _$SkillLevelEnumMap[instance.targetLevel]!,
      'sort_order': instance.sortOrder,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_UserSkillProgressModel _$UserSkillProgressModelFromJson(
  Map<String, dynamic> json,
) => _UserSkillProgressModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  skillId: json['skill_id'] as String,
  progressPercent: (json['progress_percent'] as num).toDouble(),
  lastStudiedAt: json['last_studied_at'] == null
      ? null
      : DateTime.parse(json['last_studied_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserSkillProgressModelToJson(
  _UserSkillProgressModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'skill_id': instance.skillId,
  'progress_percent': instance.progressPercent,
  'last_studied_at': instance.lastStudiedAt?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_StudyModuleModel _$StudyModuleModelFromJson(Map<String, dynamic> json) =>
    _StudyModuleModel(
      id: json['id'] as String,
      trackId: json['track_id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      estimatedHours: (json['estimated_hours'] as num).toInt(),
      sortOrder: (json['sort_order'] as num).toInt(),
      isCore: json['is_core'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$StudyModuleModelToJson(_StudyModuleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'track_id': instance.trackId,
      'title': instance.title,
      'summary': instance.summary,
      'estimated_hours': instance.estimatedHours,
      'sort_order': instance.sortOrder,
      'is_core': instance.isCore,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_StudySessionModel _$StudySessionModelFromJson(Map<String, dynamic> json) =>
    _StudySessionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      trackId: json['track_id'] as String?,
      skillId: json['skill_id'] as String?,
      moduleId: json['module_id'] as String?,
      type: $enumDecode(_$SessionTypeEnumMap, json['type']),
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      notes: json['notes'] as String,
      productivityScore: (json['productivity_score'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$StudySessionModelToJson(_StudySessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'track_id': instance.trackId,
      'skill_id': instance.skillId,
      'module_id': instance.moduleId,
      'type': _$SessionTypeEnumMap[instance.type]!,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
      'duration_minutes': instance.durationMinutes,
      'notes': instance.notes,
      'productivity_score': instance.productivityScore,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$SessionTypeEnumMap = {
  SessionType.theory: 'theory',
  SessionType.practice: 'practice',
  SessionType.review: 'review',
  SessionType.project: 'project',
  SessionType.exercises: 'exercises',
};

_TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => _TaskModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  trackId: json['track_id'] as String?,
  moduleId: json['module_id'] as String?,
  title: json['title'] as String,
  description: json['description'] as String,
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  status: $enumDecode(_$TaskStatusEnumMap, json['status']),
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TaskModelToJson(_TaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'track_id': instance.trackId,
      'module_id': instance.moduleId,
      'title': instance.title,
      'description': instance.description,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'due_date': instance.dueDate?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
  TaskPriority.critical: 'critical',
};

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.inProgress: 'in_progress',
  TaskStatus.completed: 'completed',
};

_ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => _ReviewModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  sessionId: json['session_id'] as String?,
  trackId: json['track_id'] as String?,
  skillId: json['skill_id'] as String?,
  title: json['title'] as String,
  scheduledFor: DateTime.parse(json['scheduled_for'] as String),
  status: $enumDecode(_$ReviewStatusEnumMap, json['status']),
  intervalLabel: json['interval_label'] as String,
  notes: json['notes'] as String?,
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ReviewModelToJson(_ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'session_id': instance.sessionId,
      'track_id': instance.trackId,
      'skill_id': instance.skillId,
      'title': instance.title,
      'scheduled_for': instance.scheduledFor.toIso8601String(),
      'status': _$ReviewStatusEnumMap[instance.status]!,
      'interval_label': instance.intervalLabel,
      'notes': instance.notes,
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ReviewStatusEnumMap = {
  ReviewStatus.pending: 'pending',
  ReviewStatus.completed: 'completed',
  ReviewStatus.overdue: 'overdue',
};

_ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) =>
    _ProjectModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      trackId: json['track_id'] as String?,
      title: json['title'] as String,
      scope: json['scope'] as String,
      description: json['description'] as String,
      repositoryUrl: json['repository_url'] as String?,
      documentationUrl: json['documentation_url'] as String?,
      videoUrl: json['video_url'] as String?,
      status: $enumDecode(_$ProjectStatusEnumMap, json['status']),
      progressPercent: (json['progress_percent'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ProjectModelToJson(_ProjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'track_id': instance.trackId,
      'title': instance.title,
      'scope': instance.scope,
      'description': instance.description,
      'repository_url': instance.repositoryUrl,
      'documentation_url': instance.documentationUrl,
      'video_url': instance.videoUrl,
      'status': _$ProjectStatusEnumMap[instance.status]!,
      'progress_percent': instance.progressPercent,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ProjectStatusEnumMap = {
  ProjectStatus.planned: 'planned',
  ProjectStatus.active: 'active',
  ProjectStatus.blocked: 'blocked',
  ProjectStatus.completed: 'completed',
};

_ProjectStepModel _$ProjectStepModelFromJson(Map<String, dynamic> json) =>
    _ProjectStepModel(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isDone: json['is_done'] as bool,
      sortOrder: (json['sort_order'] as num).toInt(),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ProjectStepModelToJson(_ProjectStepModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'project_id': instance.projectId,
      'title': instance.title,
      'description': instance.description,
      'is_done': instance.isDone,
      'sort_order': instance.sortOrder,
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_StudyNoteModel _$StudyNoteModelFromJson(Map<String, dynamic> json) =>
    _StudyNoteModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      folderName: json['folder_name'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$StudyNoteModelToJson(_StudyNoteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'folder_name': instance.folderName,
      'title': instance.title,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_FlashcardModel _$FlashcardModelFromJson(Map<String, dynamic> json) =>
    _FlashcardModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      deckName: json['deck_name'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      trackId: json['track_id'] as String?,
      moduleId: json['module_id'] as String?,
      projectId: json['project_id'] as String?,
      dueAt: DateTime.parse(json['due_at'] as String),
      lastReviewedAt: json['last_reviewed_at'] == null
          ? null
          : DateTime.parse(json['last_reviewed_at'] as String),
      reviewCount: (json['review_count'] as num).toInt(),
      correctStreak: (json['correct_streak'] as num).toInt(),
      easeFactor: (json['ease_factor'] as num).toDouble(),
      intervalDays: (json['interval_days'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FlashcardModelToJson(_FlashcardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'deck_name': instance.deckName,
      'question': instance.question,
      'answer': instance.answer,
      'track_id': instance.trackId,
      'module_id': instance.moduleId,
      'project_id': instance.projectId,
      'due_at': instance.dueAt.toIso8601String(),
      'last_reviewed_at': instance.lastReviewedAt?.toIso8601String(),
      'review_count': instance.reviewCount,
      'correct_streak': instance.correctStreak,
      'ease_factor': instance.easeFactor,
      'interval_days': instance.intervalDays,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_AppSettingsModel _$AppSettingsModelFromJson(Map<String, dynamic> json) =>
    _AppSettingsModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      themePreference: $enumDecode(
        _$ThemePreferenceEnumMap,
        json['theme_preference'],
      ),
      notificationsEnabled: json['notifications_enabled'] as bool,
      dailyReminderHour: (json['daily_reminder_hour'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AppSettingsModelToJson(_AppSettingsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'theme_preference': _$ThemePreferenceEnumMap[instance.themePreference]!,
      'notifications_enabled': instance.notificationsEnabled,
      'daily_reminder_hour': instance.dailyReminderHour,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ThemePreferenceEnumMap = {
  ThemePreference.system: 'system',
  ThemePreference.dark: 'dark',
  ThemePreference.light: 'light',
};
