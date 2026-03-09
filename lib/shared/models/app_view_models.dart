import '../../domain/entities/app_entities.dart';
import 'app_enums.dart';

class AppNavigationItem {
  const AppNavigationItem({
    required this.label,
    required this.route,
    required this.iconKey,
  });

  final String label;
  final String route;
  final String iconKey;
}

class TrackBlueprint {
  const TrackBlueprint({
    required this.track,
    required this.skills,
    required this.modules,
    required this.progressBySkill,
  });

  final StudyTrackEntity track;
  final List<StudySkillEntity> skills;
  final List<StudyModuleEntity> modules;
  final Map<String, UserSkillProgressEntity> progressBySkill;

  double get progressPercent {
    if (skills.isEmpty) return 0;
    final total = progressBySkill.values.fold<double>(
      0,
      (sum, item) => sum + item.progressPercent,
    );
    return total / skills.length;
  }
}

class ProjectBundle {
  const ProjectBundle({required this.project, required this.steps});

  final ProjectEntity project;
  final List<ProjectStepEntity> steps;
}

class ChartDatum {
  const ChartDatum({required this.label, required this.value});

  final String label;
  final double value;
}

class DashboardSummary {
  const DashboardSummary({
    required this.hoursThisWeek,
    required this.streakDays,
    required this.pendingTasks,
    required this.overdueReviews,
    required this.activeProjects,
    required this.trackProgress,
    required this.nextSession,
    required this.totalSessions,
  });

  final double hoursThisWeek;
  final int streakDays;
  final int pendingTasks;
  final int overdueReviews;
  final int activeProjects;
  final double trackProgress;
  final StudySessionEntity? nextSession;
  final int totalSessions;
}

enum SyncActivityPhase { idle, syncing, success, failed, offline, cooldown }

class SyncQueueDiagnostics {
  const SyncQueueDiagnostics({
    required this.pendingItems,
    required this.blockedItems,
    required this.failedItems,
    this.lastError,
    this.oldestPendingAt,
    this.latestAttemptAt,
    this.nextRetryAt,
  });

  const SyncQueueDiagnostics.empty()
    : pendingItems = 0,
      blockedItems = 0,
      failedItems = 0,
      lastError = null,
      oldestPendingAt = null,
      latestAttemptAt = null,
      nextRetryAt = null;

  final int pendingItems;
  final int blockedItems;
  final int failedItems;
  final String? lastError;
  final DateTime? oldestPendingAt;
  final DateTime? latestAttemptAt;
  final DateTime? nextRetryAt;

  bool get hasPendingItems => pendingItems > 0;
  bool get hasFailures => failedItems > 0;
  int get readyItems => pendingItems - blockedItems;
}

class SyncRuntimeSnapshot {
  const SyncRuntimeSnapshot({
    this.phase = SyncActivityPhase.idle,
    this.message,
    this.lastAttemptAt,
    this.lastSuccessAt,
    this.lastFailureAt,
  });

  final SyncActivityPhase phase;
  final String? message;
  final DateTime? lastAttemptAt;
  final DateTime? lastSuccessAt;
  final DateTime? lastFailureAt;
}

class SyncOverview {
  const SyncOverview({
    required this.isOnline,
    required this.queue,
    required this.runtime,
  });

  const SyncOverview.empty()
    : isOnline = false,
      queue = const SyncQueueDiagnostics.empty(),
      runtime = const SyncRuntimeSnapshot();

  final bool isOnline;
  final SyncQueueDiagnostics queue;
  final SyncRuntimeSnapshot runtime;
}

class SyncQueueItemViewModel {
  const SyncQueueItemViewModel({
    required this.id,
    required this.tableName,
    required this.recordId,
    required this.action,
    required this.attempts,
    required this.createdAt,
    required this.updatedAt,
    this.lastError,
    this.nextRetryAt,
  });

  final String id;
  final String tableName;
  final String recordId;
  final String action;
  final int attempts;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? lastError;
  final DateTime? nextRetryAt;

  bool get hasError => lastError != null && lastError!.isNotEmpty;
  bool get isBlockedUntilRetry => nextRetryAt != null;
}

class AnalyticsSummary {
  const AnalyticsSummary({
    required this.hoursPerDay,
    required this.hoursPerWeek,
    required this.byType,
    required this.skillStudyMap,
    required this.completedTaskRate,
    required this.completedReviews,
    required this.completedProjects,
    required this.consistencyDays,
    required this.currentWeekHours,
    required this.previousWeekHours,
    required this.averageSessionMinutes,
    required this.averageProductivityScore,
    required this.focusBalancePercent,
    this.dominantStudyType,
  });

  final List<ChartDatum> hoursPerDay;
  final List<ChartDatum> hoursPerWeek;
  final Map<SessionType, double> byType;
  final Map<String, double> skillStudyMap;
  final double completedTaskRate;
  final int completedReviews;
  final int completedProjects;
  final int consistencyDays;
  final double currentWeekHours;
  final double previousWeekHours;
  final double averageSessionMinutes;
  final double averageProductivityScore;
  final double focusBalancePercent;
  final SessionType? dominantStudyType;
}

class StudyPlanPreview {
  const StudyPlanPreview({
    required this.headline,
    required this.confidenceLabel,
    required this.weeklyHours,
    required this.horizonWeeks,
    required this.trackEffortHours,
    required this.milestones,
    required this.weeklyPlaybook,
  });

  final String headline;
  final String confidenceLabel;
  final int weeklyHours;
  final int horizonWeeks;
  final int trackEffortHours;
  final List<String> milestones;
  final List<String> weeklyPlaybook;
}

class OnboardingInput {
  const OnboardingInput({
    required this.userId,
    required this.name,
    required this.objective,
    required this.desiredArea,
    required this.trackId,
    required this.selectedTrackName,
    required this.currentLevel,
    required this.hoursPerDay,
    required this.daysPerWeek,
    required this.deadline,
    required this.focusType,
  });

  final String userId;
  final String name;
  final String objective;
  final String desiredArea;
  final String trackId;
  final String selectedTrackName;
  final SkillLevel currentLevel;
  final int hoursPerDay;
  final int daysPerWeek;
  final DateTime deadline;
  final FocusType focusType;

  String get targetDateLabel =>
      '${deadline.day}/${deadline.month}/${deadline.year}';
}
