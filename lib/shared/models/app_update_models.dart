class ReleaseAssetInfo {
  const ReleaseAssetInfo({
    required this.name,
    required this.downloadUrl,
    required this.sizeBytes,
  });

  final String name;
  final String downloadUrl;
  final int sizeBytes;
}

class AppUpdateInfo {
  const AppUpdateInfo({
    required this.version,
    required this.tagName,
    required this.releaseName,
    required this.notes,
    required this.htmlUrl,
    required this.publishedAt,
    required this.installerAsset,
  });

  final String version;
  final String tagName;
  final String releaseName;
  final String notes;
  final String htmlUrl;
  final DateTime publishedAt;
  final ReleaseAssetInfo installerAsset;
}

class AppUpdateState {
  const AppUpdateState({
    required this.currentVersion,
    this.availableUpdate,
    this.isChecking = false,
    this.isDownloading = false,
    this.hasCheckedThisSession = false,
    this.hasPromptedThisSession = false,
    this.downloadProgress,
    this.errorMessage,
    this.dismissedVersion,
  });

  final String currentVersion;
  final AppUpdateInfo? availableUpdate;
  final bool isChecking;
  final bool isDownloading;
  final bool hasCheckedThisSession;
  final bool hasPromptedThisSession;
  final double? downloadProgress;
  final String? errorMessage;
  final String? dismissedVersion;

  bool get hasUpdate => availableUpdate != null;

  bool get shouldPrompt =>
      availableUpdate != null &&
      availableUpdate!.tagName != dismissedVersion &&
      !hasPromptedThisSession;

  AppUpdateState copyWith({
    String? currentVersion,
    AppUpdateInfo? availableUpdate,
    bool clearAvailableUpdate = false,
    bool? isChecking,
    bool? isDownloading,
    bool? hasCheckedThisSession,
    bool? hasPromptedThisSession,
    double? downloadProgress,
    bool clearDownloadProgress = false,
    String? errorMessage,
    bool clearError = false,
    String? dismissedVersion,
    bool clearDismissedVersion = false,
  }) {
    return AppUpdateState(
      currentVersion: currentVersion ?? this.currentVersion,
      availableUpdate: clearAvailableUpdate
          ? null
          : availableUpdate ?? this.availableUpdate,
      isChecking: isChecking ?? this.isChecking,
      isDownloading: isDownloading ?? this.isDownloading,
      hasCheckedThisSession:
          hasCheckedThisSession ?? this.hasCheckedThisSession,
      hasPromptedThisSession:
          hasPromptedThisSession ?? this.hasPromptedThisSession,
      downloadProgress: clearDownloadProgress
          ? null
          : downloadProgress ?? this.downloadProgress,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      dismissedVersion: clearDismissedVersion
          ? null
          : dismissedVersion ?? this.dismissedVersion,
    );
  }
}
