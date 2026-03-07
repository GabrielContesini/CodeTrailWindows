import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/router/app_router.dart';
import 'core/services/bootstrap_service.dart';
import 'core/services/service_providers.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/application/auth_controller.dart';
import 'features/settings/application/settings_controller.dart';
import 'shared/models/app_enums.dart';
import 'shared/models/app_view_models.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;

  if (!Platform.isWindows) {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  await BootstrapService.ensureInitialized();

  runApp(const ProviderScope(child: CodeTrailApp()));
}

class CodeTrailApp extends ConsumerStatefulWidget {
  const CodeTrailApp({super.key});

  @override
  ConsumerState<CodeTrailApp> createState() => _CodeTrailAppState();
}

class _CodeTrailAppState extends ConsumerState<CodeTrailApp> {
  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<SyncQueueDiagnostics>? _syncDiagnosticsSubscription;
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = ref
        .read(connectivityProvider)
        .connectivityChanges()
        .listen((connected) {
          if (!connected) return;
          unawaited(_triggerSync());
        });
    _syncDiagnosticsSubscription = ref
        .read(appDatabaseProvider)
        .watchSyncQueueDiagnostics()
        .listen(_handleSyncDiagnostics);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncDiagnosticsSubscription?.cancel();
    _retryTimer?.cancel();
    super.dispose();
  }

  void _handleSyncDiagnostics(SyncQueueDiagnostics diagnostics) {
    _retryTimer?.cancel();

    final nextRetryAt = diagnostics.nextRetryAt;
    if (diagnostics.blockedItems == 0 || nextRetryAt == null) {
      return;
    }

    final delay = nextRetryAt.difference(DateTime.now().toUtc());
    if (delay <= Duration.zero) {
      unawaited(_triggerSync());
      return;
    }

    _retryTimer = Timer(delay, () => unawaited(_triggerSync()));
  }

  Future<void> _triggerSync() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null || userId.isEmpty) return;
    await ref.read(studyRepositoryProvider).sync(userId);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themePreference =
        ref.watch(appSettingsProvider).asData?.value?.themePreference ??
        ThemePreference.dark;

    return MaterialApp.router(
      title: 'CodeTrail Windows',
      debugShowCheckedModeBanner: false,
      themeMode: themePreference.themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
