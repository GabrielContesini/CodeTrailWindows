import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/services/service_providers.dart';
import '../../../shared/models/app_enums.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/gradient_scaffold.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_bootstrap);
  }

  Future<void> _bootstrap() async {
    try {
      final route = await ref
          .read(startupCoordinatorProvider)
          .resolveInitialRoute()
          .timeout(
            const Duration(seconds: 4),
            onTimeout: () => AppRoutes.login,
          );

      final session = ref.read(authRepositoryProvider).currentSession;
      if (session != null) {
        unawaited(_configureNotifications(session.user.id));
      }

      if (!mounted) {
        return;
      }
      context.go(route);
    } catch (_) {
      try {
        await ref.read(authRepositoryProvider).signOut();
      } catch (_) {}
      if (!mounted) {
        return;
      }
      context.go(AppRoutes.login);
    }
  }

  Future<void> _configureNotifications(String userId) async {
    try {
      final repository = ref.read(studyRepositoryProvider);
      final settings = await repository.getSettings(userId);
      final notificationService = ref.read(notificationServiceProvider);
      if (settings?.notificationsEnabled ?? true) {
        final reviews = await repository.watchReviews(userId).first;
        for (final review in reviews.where(
          (item) => item.status == ReviewStatus.pending,
        )) {
          await notificationService.scheduleReviewReminder(review);
        }
      } else {
        await notificationService.cancelAll();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLogo(size: 84),
                  const SizedBox(height: 28),
                  Text(
                    'CodeTrail Windows',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Inicializando workspace, banco local e autenticação.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
