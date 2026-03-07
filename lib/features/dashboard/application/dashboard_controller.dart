import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/app_view_models.dart';
import '../../auth/application/auth_controller.dart';

final dashboardSummaryProvider = StreamProvider<DashboardSummary>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return Stream.value(
      const DashboardSummary(
        hoursThisWeek: 0,
        streakDays: 0,
        pendingTasks: 0,
        overdueReviews: 0,
        activeProjects: 0,
        trackProgress: 0,
        nextSession: null,
        totalSessions: 0,
      ),
    );
  }

  final repository = ref.watch(studyRepositoryProvider);

  return Rx.combineLatest5(
    repository.watchSessions(userId),
    repository.watchTasks(userId),
    repository.watchReviews(userId),
    repository.watchProjects(userId),
    repository.watchTracks(userId),
    (
      List<StudySessionEntity> sessions,
      List<TaskEntity> tasks,
      List<ReviewEntity> reviews,
      List<ProjectBundle> projects,
      List<TrackBlueprint> tracks,
    ) {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekMinutes = sessions
          .where((item) => item.startTime.isAfter(weekStart))
          .fold<int>(0, (sum, item) => sum + item.durationMinutes);

      final completedDays = sessions
          .map(
            (item) => DateTime(
              item.startTime.year,
              item.startTime.month,
              item.startTime.day,
            ),
          )
          .toSet()
          .length;

      final nextSession = sessions.isEmpty ? null : sessions.first;

      final pendingTasks = tasks
          .where((item) => item.status != TaskStatus.completed)
          .length;

      final overdueReviews = reviews
          .where(
            (item) =>
                item.status != ReviewStatus.completed &&
                item.scheduledFor.isBefore(now),
          )
          .length;

      final activeProjects = projects
          .where((item) => item.project.status != ProjectStatus.completed)
          .length;

      final trackProgress = tracks.isEmpty
          ? 0.0
          : tracks.fold<double>(0, (sum, item) => sum + item.progressPercent) /
                tracks.length;

      return DashboardSummary(
        hoursThisWeek: weekMinutes / 60,
        streakDays: completedDays,
        pendingTasks: pendingTasks,
        overdueReviews: overdueReviews,
        activeProjects: activeProjects,
        trackProgress: trackProgress,
        nextSession: nextSession,
        totalSessions: sessions.length,
      );
    },
  );
});
