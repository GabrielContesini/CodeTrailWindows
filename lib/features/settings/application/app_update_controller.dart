import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../shared/models/app_update_models.dart';

final appUpdateControllerProvider =
    AsyncNotifierProvider<AppUpdateController, AppUpdateState>(
      AppUpdateController.new,
    );

class AppUpdateController extends AsyncNotifier<AppUpdateState> {
  @override
  FutureOr<AppUpdateState> build() async {
    if (!Platform.isWindows) {
      return const AppUpdateState(currentVersion: 'desktop');
    }

    final service = ref.watch(appUpdateServiceProvider);
    final preferences = ref.watch(sessionPreferencesProvider);
    final currentVersion = await service.currentVersion();
    final dismissedVersion = await preferences.getDismissedUpdateVersion();

    return AppUpdateState(
      currentVersion: currentVersion,
      dismissedVersion: dismissedVersion,
    );
  }

  Future<void> checkForUpdates({bool force = false}) async {
    final current = await _ensureState();
    final service = ref.read(appUpdateServiceProvider);

    state = AsyncData(
      current.copyWith(isChecking: true, clearError: true),
    );

    try {
      final update = await service.fetchLatestUpdate(
        currentVersion: current.currentVersion,
      );
      final shouldResetDismissed =
          update != null && update.tagName != current.dismissedVersion;

      if (shouldResetDismissed) {
        await ref.read(sessionPreferencesProvider).clearDismissedUpdateVersion();
      }

      state = AsyncData(
        current.copyWith(
          availableUpdate: update,
          clearAvailableUpdate: update == null,
          isChecking: false,
          hasCheckedThisSession: true,
          hasPromptedThisSession: force
              ? false
              : current.hasPromptedThisSession,
          clearError: true,
          dismissedVersion: shouldResetDismissed
              ? null
              : current.dismissedVersion,
          clearDismissedVersion: shouldResetDismissed,
        ),
      );
    } catch (error) {
      state = AsyncData(
        current.copyWith(
          isChecking: false,
          hasCheckedThisSession: true,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<bool> downloadAndInstall() async {
    final current = await _ensureState();
    final update = current.availableUpdate;
    if (update == null) return false;

    state = AsyncData(
      current.copyWith(
        isDownloading: true,
        downloadProgress: 0,
        clearError: true,
      ),
    );

    try {
      await ref.read(appUpdateServiceProvider).downloadAndInstall(
        update,
        onProgress: (progress) {
          final snapshot = state.asData?.value ?? current;
          state = AsyncData(
            snapshot.copyWith(
              isDownloading: true,
              downloadProgress: progress,
            ),
          );
        },
      );

      state = AsyncData(
        (state.asData?.value ?? current).copyWith(
          isDownloading: false,
          clearDownloadProgress: true,
        ),
      );
      return true;
    } catch (error) {
      state = AsyncData(
        (state.asData?.value ?? current).copyWith(
          isDownloading: false,
          clearDownloadProgress: true,
          errorMessage: error.toString(),
        ),
      );
      return false;
    }
  }

  Future<void> dismissCurrentUpdate() async {
    final current = await _ensureState();
    final update = current.availableUpdate;
    if (update == null) return;

    await ref.read(sessionPreferencesProvider).dismissUpdateVersion(update.tagName);
    state = AsyncData(
      current.copyWith(
        dismissedVersion: update.tagName,
        hasPromptedThisSession: true,
      ),
    );
  }

  Future<void> markPromptShown() async {
    final current = await _ensureState();
    if (current.hasPromptedThisSession) return;
    state = AsyncData(current.copyWith(hasPromptedThisSession: true));
  }

  Future<void> clearError() async {
    final current = await _ensureState();
    if (current.errorMessage == null) return;
    state = AsyncData(current.copyWith(clearError: true));
  }

  Future<void> openReleaseNotes() async {
    final current = await _ensureState();
    final update = current.availableUpdate;
    if (update == null) return;

    try {
      await ref.read(appUpdateServiceProvider).openReleaseNotes(update);
    } catch (error) {
      state = AsyncData(
        current.copyWith(errorMessage: error.toString()),
      );
    }
  }

  Future<AppUpdateState> _ensureState() async {
    final current = state.asData?.value;
    if (current != null) {
      return current;
    }

    final next = await build();
    state = AsyncData(next);
    return next;
  }
}
