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
  });

  final List<ChartDatum> hoursPerDay;
  final List<ChartDatum> hoursPerWeek;
  final Map<SessionType, double> byType;
  final Map<String, double> skillStudyMap;
  final double completedTaskRate;
  final int completedReviews;
  final int completedProjects;
  final int consistencyDays;
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
