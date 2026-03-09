import 'dart:convert';

import 'package:code_trail_windows/core/services/connectivity_service.dart';
import 'package:code_trail_windows/core/services/telemetry_heartbeat_service.dart';
import 'package:code_trail_windows/data/local/app_database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('TelemetryHeartbeatService', () {
    late AppDatabase database;
    late _CountingConnectivityService connectivityService;
    late _RecordingHttpClient client;
    late TelemetryHeartbeatService service;

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      connectivityService = _CountingConnectivityService();
      client = _RecordingHttpClient();
      service = TelemetryHeartbeatService(
        database: database,
        connectivityService: connectivityService,
        secureStorage: const FlutterSecureStorage(),
        client: client,
      );
    });

    tearDown(() async {
      service.dispose();
      await database.close();
    });

    test('stays inert when Command Center telemetry is not configured', () async {
      expect(service.isEnabled, isFalse);

      await service.initialize();
      await service.start(userId: 'user-1');
      await service.updateUser('user-2');
      await service.sendNow(force: true);

      expect(connectivityService.connectivityChecks, 0);
      expect(client.requestCount, 0);
    });
  });
}

class _CountingConnectivityService extends ConnectivityService {
  _CountingConnectivityService() : super(Connectivity());

  int connectivityChecks = 0;

  @override
  Stream<bool> connectivityChanges() => const Stream<bool>.empty();

  @override
  Future<bool> isConnected() async {
    connectivityChecks += 1;
    return true;
  }
}

class _RecordingHttpClient extends http.BaseClient {
  int requestCount = 0;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requestCount += 1;
    return http.StreamedResponse(
      Stream<List<int>>.value(utf8.encode('{}')),
      200,
    );
  }
}
