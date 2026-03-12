import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/service_providers.dart';
import '../../features/analytics/presentation/analytics_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/flashcards/presentation/flashcards_screen.dart';
import '../../features/mind_maps/presentation/mind_maps_screen.dart';
import '../../features/notes/presentation/notes_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/projects/presentation/projects_screen.dart';
import '../../features/reviews/presentation/reviews_screen.dart';
import '../../features/settings/presentation/settings_account_screen.dart';
import '../../features/settings/presentation/settings_help_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/settings_sync_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/study_plans/presentation/study_plan_screen.dart';
import '../../features/study_sessions/presentation/new_session_screen.dart';
import '../../features/study_sessions/presentation/study_sessions_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../features/tracks/presentation/track_details_screen.dart';
import '../../features/tracks/presentation/tracks_screen.dart';
import '../../shared/models/app_view_models.dart';
import '../../shared/widgets/navigation_shell_scaffold.dart';

class AppRoutes {
  const AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const onboarding = '/onboarding';
  static const dashboard = '/dashboard';
  static const tracks = '/tracks';
  static const trackDetails = '/tracks/details';
  static const plans = '/plans';
  static const sessions = '/sessions';
  static const newSession = '/sessions/new';
  static const tasks = '/tasks';
  static const reviews = '/reviews';
  static const projects = '/projects';
  static const projectDetails = '/projects/details';
  static const notes = '/notes';
  static const flashcards = '/flashcards';
  static const mindMaps = '/mind-maps';
  static const mindMapEditor = '/mind-maps/editor';
  static const mindMapNew = '/mind-maps/editor/new';
  static const analytics = '/analytics';
  static const settings = '/settings';
  static const settingsAccount = '/settings/account';
  static const settingsHelp = '/settings/help';
  static const settingsSync = '/settings/sync';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final refreshListenable = _RouterRefreshListenable(
    authRepository.sessionChanges(),
  );
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return NavigationShellScaffold(
            location: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.tracks,
            builder: (context, state) => const TracksScreen(),
          ),
          GoRoute(
            path: '${AppRoutes.trackDetails}/:trackId',
            builder: (context, state) {
              return TrackDetailsScreen(
                trackId: state.pathParameters['trackId'] ?? '',
              );
            },
          ),
          GoRoute(
            path: AppRoutes.plans,
            builder: (context, state) => const StudyPlanScreen(),
          ),
          GoRoute(
            path: AppRoutes.sessions,
            builder: (context, state) => const StudySessionsScreen(),
          ),
          GoRoute(
            path: AppRoutes.newSession,
            builder: (context, state) => const NewSessionScreen(),
          ),
          GoRoute(
            path: AppRoutes.tasks,
            builder: (context, state) => const TasksScreen(),
          ),
          GoRoute(
            path: AppRoutes.reviews,
            builder: (context, state) => const ReviewsScreen(),
          ),
          GoRoute(
            path: AppRoutes.projects,
            builder: (context, state) => const ProjectsScreen(),
          ),
          GoRoute(
            path: '${AppRoutes.projectDetails}/:projectId',
            builder: (context, state) {
              return ProjectDetailsScreen(
                projectId: state.pathParameters['projectId'] ?? '',
              );
            },
          ),
          GoRoute(
            path: AppRoutes.notes,
            builder: (context, state) => const NotesScreen(),
          ),
          GoRoute(
            path: AppRoutes.flashcards,
            builder: (context, state) => const FlashcardsScreen(),
          ),
          GoRoute(
            path: AppRoutes.mindMaps,
            builder: (context, state) => const MindMapsScreen(),
          ),
          GoRoute(
            path: AppRoutes.mindMapNew,
            builder: (context, state) =>
                const MindMapsScreen(immersive: true, createOnOpen: true),
          ),
          GoRoute(
            path: '${AppRoutes.mindMapEditor}/:mindMapId',
            builder: (context, state) => MindMapsScreen(
              immersive: true,
              initialMindMapId: state.pathParameters['mindMapId'],
            ),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.settingsAccount,
            builder: (context, state) => const SettingsAccountScreen(),
          ),
          GoRoute(
            path: AppRoutes.settingsHelp,
            builder: (context, state) => const SettingsHelpScreen(),
          ),
          GoRoute(
            path: AppRoutes.settingsSync,
            builder: (context, state) => const SettingsSyncScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final session = authRepository.currentSession;
      final path = state.uri.path;
      final isPublicRoute =
          path == AppRoutes.login ||
          path == AppRoutes.signup ||
          path == AppRoutes.splash;

      if (session == null && !isPublicRoute) {
        return AppRoutes.login;
      }

      return null;
    },
  );
});

List<AppNavigationItem> buildNavigationItems() {
  return const [
    AppNavigationItem(
      label: 'Dashboard',
      route: AppRoutes.dashboard,
      iconKey: 'chart',
    ),
    AppNavigationItem(
      label: 'Trilhas',
      route: AppRoutes.tracks,
      iconKey: 'layers',
    ),
    AppNavigationItem(
      label: 'Sessões',
      route: AppRoutes.sessions,
      iconKey: 'book',
    ),
    AppNavigationItem(
      label: 'Tarefas',
      route: AppRoutes.tasks,
      iconKey: 'code',
    ),
    AppNavigationItem(
      label: 'Revisões',
      route: AppRoutes.reviews,
      iconKey: 'rocket',
    ),
    AppNavigationItem(
      label: 'Projetos',
      route: AppRoutes.projects,
      iconKey: 'server',
    ),
    AppNavigationItem(label: 'Notas', route: AppRoutes.notes, iconKey: 'notes'),
    AppNavigationItem(
      label: 'Flashcards',
      route: AppRoutes.flashcards,
      iconKey: 'cards',
    ),
    AppNavigationItem(
      label: 'Mind Maps',
      route: AppRoutes.mindMaps,
      iconKey: 'mindmap',
    ),
    AppNavigationItem(
      label: 'Analytics',
      route: AppRoutes.analytics,
      iconKey: 'database',
    ),
    AppNavigationItem(
      label: 'Config.',
      route: AppRoutes.settings,
      iconKey: 'cloud',
    ),
  ];
}

class _RouterRefreshListenable extends ChangeNotifier {
  _RouterRefreshListenable(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
