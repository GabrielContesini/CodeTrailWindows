import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/models/app_view_models.dart';
import '../../auth/application/auth_controller.dart';

final analyticsSummaryProvider = StreamProvider<AnalyticsSummary>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return Stream.value(
      const AnalyticsSummary(
        hoursPerDay: [],
        hoursPerWeek: [],
        byType: {},
        skillStudyMap: {},
        completedTaskRate: 0,
        completedReviews: 0,
        completedProjects: 0,
        consistencyDays: 0,
        currentWeekHours: 0,
        previousWeekHours: 0,
        averageSessionMinutes: 0,
        averageProductivityScore: 0,
        focusBalancePercent: 0,
      ),
    );
  }

  final repository = ref.watch(studyRepositoryProvider);

  return Rx.combineLatest4(
    repository.watchSessions(userId),
    repository.watchTasks(userId),
    repository.watchReviews(userId),
    repository.watchProjects(userId),
    (
      List<StudySessionEntity> sessions,
      List<TaskEntity> tasks,
      List<ReviewEntity> reviews,
      List<ProjectBundle> projects,
    ) {
      final now = DateTime.now();
      final startOfCurrentWeek = _startOfWeek(now);
      final startOfPreviousWeek = startOfCurrentWeek.subtract(
        const Duration(days: 7),
      );
      final dayBuckets = <String, double>{};
      final weekBuckets = <String, double>{};
      final byType = <SessionType, double>{};
      final bySkill = <String, double>{};
      var totalMinutes = 0;
      var totalProductivityScore = 0;

      for (final session in sessions) {
        final dayKey = DateFormat('dd/MM').format(session.startTime);
        final weekKey = 'S${weekOfYear(session.startTime)}';
        totalMinutes += session.durationMinutes;
        totalProductivityScore += session.productivityScore;
        dayBuckets.update(
          dayKey,
          (value) => value + session.durationMinutes / 60,
          ifAbsent: () => session.durationMinutes / 60,
        );
        weekBuckets.update(
          weekKey,
          (value) => value + session.durationMinutes / 60,
          ifAbsent: () => session.durationMinutes / 60,
        );
        byType.update(
          session.type,
          (value) => value + session.durationMinutes / 60,
          ifAbsent: () => session.durationMinutes / 60,
        );
        if (session.skillId != null) {
          bySkill.update(
            session.skillId!,
            (value) => value + session.durationMinutes / 60,
            ifAbsent: () => session.durationMinutes / 60,
          );
        }
      }

      final currentWeekHours = sessions
          .where((session) => !session.startTime.isBefore(startOfCurrentWeek))
          .fold<double>(
            0,
            (sum, session) => sum + session.durationMinutes / 60,
          );
      final previousWeekHours = sessions
          .where(
            (session) =>
                !session.startTime.isBefore(startOfPreviousWeek) &&
                session.startTime.isBefore(startOfCurrentWeek),
          )
          .fold<double>(
            0,
            (sum, session) => sum + session.durationMinutes / 60,
          );
      final averageSessionMinutes = sessions.isEmpty
          ? 0.0
          : totalMinutes / sessions.length;
      final averageProductivityScore = sessions.isEmpty
          ? 0.0
          : totalProductivityScore / sessions.length;
      final handsOnHours =
          (byType[SessionType.practice] ?? 0) +
          (byType[SessionType.project] ?? 0) +
          (byType[SessionType.exercises] ?? 0);
      final totalHours = byType.values.fold<double>(0, (sum, value) => sum + value);
      final focusBalancePercent = totalHours == 0
          ? 0.0
          : (handsOnHours / totalHours) * 100;
      SessionType? dominantStudyType;
      double dominantStudyHours = -1;
      byType.forEach((type, hours) {
        if (hours > dominantStudyHours) {
          dominantStudyHours = hours;
          dominantStudyType = type;
        }
      });

      final taskCompletionRate = tasks.isEmpty
          ? 0.0
          : tasks.where((task) => task.status == TaskStatus.completed).length /
                tasks.length;

      final completedReviews = reviews
          .where((review) => review.status == ReviewStatus.completed)
          .length;
      final completedProjects = projects
          .where((project) => project.project.status == ProjectStatus.completed)
          .length;
      final consistencyDays = sessions
          .where(
            (session) => session.startTime.isAfter(
              now.subtract(const Duration(days: 30)),
            ),
          )
          .map(
            (session) => DateTime(
              session.startTime.year,
              session.startTime.month,
              session.startTime.day,
            ),
          )
          .toSet()
          .length;

      return AnalyticsSummary(
        hoursPerDay: dayBuckets.entries
            .map((item) => ChartDatum(label: item.key, value: item.value))
            .toList(),
        hoursPerWeek: weekBuckets.entries
            .map((item) => ChartDatum(label: item.key, value: item.value))
            .toList(),
        byType: byType,
        skillStudyMap: bySkill,
        completedTaskRate: taskCompletionRate,
        completedReviews: completedReviews,
        completedProjects: completedProjects,
        consistencyDays: consistencyDays,
        currentWeekHours: currentWeekHours,
        previousWeekHours: previousWeekHours,
        averageSessionMinutes: averageSessionMinutes,
        averageProductivityScore: averageProductivityScore,
        focusBalancePercent: focusBalancePercent,
        dominantStudyType: dominantStudyType,
      );
    },
  );
});

DateTime _startOfWeek(DateTime value) {
  final local = DateTime(value.year, value.month, value.day);
  return local.subtract(Duration(days: local.weekday - 1));
}

int weekOfYear(DateTime date) {
  final startOfYear = DateTime(date.year, 1, 1);
  return ((date.difference(startOfYear).inDays + startOfYear.weekday) / 7)
      .ceil();
}
