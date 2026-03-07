import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/models/app_enums.dart';
import '../../auth/application/auth_controller.dart';

final profileProvider = FutureProvider<ProfileEntity?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  return ref.watch(studyRepositoryProvider).getProfile(userId);
});

final userGoalProvider = FutureProvider<UserGoalEntity?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  return ref.watch(studyRepositoryProvider).getGoal(userId);
});

final appSettingsProvider =
    AsyncNotifierProvider<AppSettingsController, AppSettingsEntity?>(
      AppSettingsController.new,
    );

class AppSettingsController extends AsyncNotifier<AppSettingsEntity?> {
  @override
  FutureOr<AppSettingsEntity?> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return null;
    return ref.watch(studyRepositoryProvider).getSettings(userId);
  }

  Future<void> updateTheme(ThemePreference preference) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final current = state.asData?.value;
    final now = DateTime.now().toUtc();
    final next =
        current?.copyWith(themePreference: preference, updatedAt: now) ??
        AppSettingsEntity(
          id: userId,
          userId: userId,
          themePreference: preference,
          notificationsEnabled: true,
          createdAt: now,
          updatedAt: now,
        );

    state = await AsyncValue.guard(() async {
      await ref.read(studyRepositoryProvider).saveSettings(next);
      return next;
    });
  }

  Future<void> toggleNotifications(bool enabled) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final now = DateTime.now().toUtc();
    final current = state.asData?.value;
    final existing =
        current ??
        AppSettingsEntity(
          id: userId,
          userId: userId,
          themePreference: ThemePreference.dark,
          notificationsEnabled: enabled,
          dailyReminderHour: 20,
          createdAt: now,
          updatedAt: now,
        );

    final next = existing.copyWith(
      notificationsEnabled: enabled,
      updatedAt: now,
    );

    state = await AsyncValue.guard(() async {
      await ref.read(studyRepositoryProvider).saveSettings(next);
      final notificationService = ref.read(notificationServiceProvider);
      if (enabled) {
        await notificationService.requestPermissions();
      } else {
        await notificationService.cancelAll();
      }
      return next;
    });
  }

  Future<void> updateReminderHour(int hour) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final now = DateTime.now().toUtc();
    final current = state.asData?.value;
    final existing =
        current ??
        AppSettingsEntity(
          id: userId,
          userId: userId,
          themePreference: ThemePreference.dark,
          notificationsEnabled: true,
          dailyReminderHour: hour,
          createdAt: now,
          updatedAt: now,
        );

    final next = existing.copyWith(dailyReminderHour: hour, updatedAt: now);
    state = await AsyncValue.guard(() async {
      await ref.read(studyRepositoryProvider).saveSettings(next);
      return next;
    });
  }

  Future<void> saveProfile(ProfileEntity profile) async {
    await ref.read(studyRepositoryProvider).saveProfile(profile);
    ref.invalidate(profileProvider);
  }

  Future<void> saveGoal(UserGoalEntity goal) async {
    await ref.read(studyRepositoryProvider).saveGoal(goal);
    ref.invalidate(userGoalProvider);
  }
}
