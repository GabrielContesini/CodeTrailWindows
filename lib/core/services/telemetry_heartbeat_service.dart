import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';
import '../constants/app_env.dart';
import '../../data/local/app_database.dart';
import '../../shared/models/app_view_models.dart';
import 'connectivity_service.dart';

class TelemetryHeartbeatService {
  TelemetryHeartbeatService({
    required AppDatabase database,
    required ConnectivityService connectivityService,
    required FlutterSecureStorage secureStorage,
    http.Client? client,
  }) : _database = database,
       _connectivityService = connectivityService,
       _secureStorage = secureStorage,
       _client = client ?? http.Client();

  static const _instanceStorageKey = 'command_center.instance_id';
  static const _heartbeatInterval = Duration(minutes: 5);
  static const _minimumIntervalBetweenSends = Duration(seconds: 45);

  final AppDatabase _database;
  final ConnectivityService _connectivityService;
  final FlutterSecureStorage _secureStorage;
  final http.Client _client;
  final Stopwatch _appUptime = Stopwatch()..start();

  Timer? _timer;
  String? _instanceId;
  String? _currentUserId;
  PackageInfo? _packageInfo;
  DateTime? _lastSentAt;
  bool _sending = false;

  bool get isEnabled =>
      Platform.isWindows && AppEnv.isCommandCenterConfigured;

  Future<void> initialize() async {
    if (!isEnabled) {
      return;
    }

    _instanceId ??=
        await _secureStorage.read(key: _instanceStorageKey) ??
        const Uuid().v4();
    await _secureStorage.write(key: _instanceStorageKey, value: _instanceId);
    _packageInfo ??= await PackageInfo.fromPlatform();
  }

  Future<void> start({String? userId}) async {
    _currentUserId = userId;
    if (!isEnabled) {
      return;
    }

    await initialize();
    _timer ??= Timer.periodic(
      _heartbeatInterval,
      (_) => unawaited(sendNow()),
    );
    await sendNow(force: true);
  }

  Future<void> updateUser(String? userId) async {
    _currentUserId = userId;
    if (!isEnabled) {
      return;
    }

    await initialize();
    await sendNow(force: true);
  }

  Future<void> sendNow({bool force = false}) async {
    if (!isEnabled || _sending) {
      return;
    }

    final lastSentAt = _lastSentAt;
    final now = DateTime.now().toUtc();
    if (!force &&
        lastSentAt != null &&
        now.difference(lastSentAt) < _minimumIntervalBetweenSends) {
      return;
    }

    final isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      return;
    }

    _sending = true;
    try {
      final diagnostics = await _collectQueueDiagnostics();
      final packageInfo = _packageInfo ?? await PackageInfo.fromPlatform();
      final version = packageInfo.buildNumber.isEmpty
          ? packageInfo.version
          : '${packageInfo.version}+${packageInfo.buildNumber}';
      final status =
          diagnostics.failedItems > 0 || diagnostics.pendingItems > 10
              ? 'degraded'
              : 'up';

      final response = await _client.post(
        _heartbeatUri(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppEnv.commandCenterIngestToken}',
        },
        body: jsonEncode({
          'instanceId': _instanceId,
          'profileId': _currentUserId,
          'platform': 'windows',
          'appVersion': version,
          'environment': AppEnv.appEnvironment,
          'releaseChannel': AppEnv.releaseChannel,
          'deviceLabel': AppConstants.appName,
          'machineName': _safeMachineName(),
          'status': status,
          'syncBacklog': diagnostics.pendingItems,
          'openErrors': diagnostics.failedItems,
          'appUptimeSeconds': _appUptime.elapsed.inSeconds,
          'osUptimeSeconds': null,
          'networkStatus': 'online',
          'metadata': {
            'os': Platform.operatingSystem,
            'osVersion': Platform.operatingSystemVersion,
            'hostname': _safeMachineName(),
          },
          'payload': {
            'readyItems': diagnostics.readyItems,
            'blockedItems': diagnostics.blockedItems,
            'latestAttemptAt': diagnostics.latestAttemptAt?.toIso8601String(),
            'oldestPendingAt': diagnostics.oldestPendingAt?.toIso8601String(),
            'lastError': diagnostics.lastError,
          },
        }),
      );

      if (response.statusCode < 400) {
        _lastSentAt = now;
      }
    } catch (_) {
      // Heartbeat must not interfere with app startup or runtime behavior.
    } finally {
      _sending = false;
    }
  }

  void dispose() {
    _timer?.cancel();
    _client.close();
  }

  Uri _heartbeatUri() {
    final base = AppEnv.commandCenterUrl.trim();
    final normalized = base.endsWith('/')
        ? base.substring(0, base.length - 1)
        : base;
    return Uri.parse('$normalized/api/telemetry/heartbeat');
  }

  String _safeMachineName() {
    try {
      return Platform.localHostname;
    } catch (_) {
      return 'windows-host';
    }
  }

  Future<SyncQueueDiagnostics> _collectQueueDiagnostics() async {
    final rows = await _database.pendingQueueEntries();
    if (rows.isEmpty) {
      return const SyncQueueDiagnostics.empty();
    }

    final failedRows = rows
        .where((row) => row.lastError != null && row.lastError!.isNotEmpty)
        .toList();
    final oldestPendingAt = rows
        .map((row) => row.createdAt)
        .reduce((left, right) => left.isBefore(right) ? left : right);
    final latestAttemptAt = rows
        .map((row) => row.updatedAt)
        .reduce((left, right) => left.isAfter(right) ? left : right);

    return SyncQueueDiagnostics(
      pendingItems: rows.length,
      blockedItems: rows.where((row) => row.attempts > 0).length,
      failedItems: failedRows.length,
      lastError: failedRows.isEmpty ? null : failedRows.first.lastError,
      oldestPendingAt: oldestPendingAt,
      latestAttemptAt: latestAttemptAt,
      nextRetryAt: null,
    );
  }
}
