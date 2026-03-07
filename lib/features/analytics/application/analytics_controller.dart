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
      final dayBuckets = <String, double>{};
      final weekBuckets = <String, double>{};
      final byType = <SessionType, double>{};
      final bySkill = <String, double>{};

      for (final session in sessions) {
        final dayKey = DateFormat('dd/MM').format(session.startTime);
        final weekKey = 'S${weekOfYear(session.startTime)}';
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
      );
    },
  );
});

int weekOfYear(DateTime date) {
  final startOfYear = DateTime(date.year, 1, 1);
  return ((date.difference(startOfYear).inDays + startOfYear.weekday) / 7)
      .ceil();
}
