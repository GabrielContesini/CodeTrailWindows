class SyncRetryPolicy {
  const SyncRetryPolicy._();

  static Duration retryDelayForAttempts(int attempts) {
    if (attempts <= 0) return Duration.zero;
    if (attempts == 1) return const Duration(seconds: 15);
    if (attempts == 2) return const Duration(minutes: 1);
    if (attempts == 3) return const Duration(minutes: 5);
    if (attempts == 4) return const Duration(minutes: 15);
    return const Duration(hours: 1);
  }

  static DateTime? nextRetryAt({
    required int attempts,
    required DateTime updatedAt,
    String? lastError,
  }) {
    if (lastError == null || lastError.isEmpty || attempts <= 0) {
      return null;
    }

    return updatedAt.add(retryDelayForAttempts(attempts));
  }

  static bool isReady({
    required int attempts,
    required DateTime updatedAt,
    String? lastError,
    DateTime? now,
  }) {
    final nextRetry = nextRetryAt(
      attempts: attempts,
      updatedAt: updatedAt,
      lastError: lastError,
    );
    if (nextRetry == null) return true;
    return !nextRetry.isAfter(now ?? DateTime.now().toUtc());
  }
}
