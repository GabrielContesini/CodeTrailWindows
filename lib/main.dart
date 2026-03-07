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

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = ref
        .read(connectivityProvider)
        .connectivityChanges()
        .listen((connected) {
          if (!connected) return;
          final userId = ref.read(currentUserIdProvider);
          if (userId == null || userId.isEmpty) return;
          unawaited(ref.read(studyRepositoryProvider).sync(userId));
        });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
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
