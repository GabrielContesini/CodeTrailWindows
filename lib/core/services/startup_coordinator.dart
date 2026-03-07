import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/study_repository.dart';
import '../router/app_router.dart';

class StartupCoordinator {
  StartupCoordinator({
    required AuthRepository authRepository,
    required StudyRepository studyRepository,
  }) : _authRepository = authRepository,
       _studyRepository = studyRepository;

  final AuthRepository _authRepository;
  final StudyRepository _studyRepository;

  Future<String> resolveInitialRoute() async {
    await _studyRepository.ensureSeededCatalog();

    final session = _authRepository.currentSession;
    if (session != null) {
      await _authRepository.signOut();
    }

    return AppRoutes.login;
  }

  Future<String> resolveAuthenticatedRoute() async {
    await _studyRepository.ensureSeededCatalog();

    final hasValidSession = await _authRepository.restoreSessionOrSignOut();
    if (!hasValidSession) {
      return AppRoutes.login;
    }

    final activeSession = _authRepository.currentSession;
    if (activeSession == null) {
      return AppRoutes.login;
    }

    await _studyRepository.sync(activeSession.user.id);
    final profile = await _studyRepository.getProfile(activeSession.user.id);

    if (profile == null || !profile.onboardingCompleted) {
      return AppRoutes.onboarding;
    }

    return AppRoutes.dashboard;
  }

  Future<String> resolvePostLoginRoute() async {
    await _studyRepository.ensureSeededCatalog();

    var activeSession = _authRepository.currentSession;
    if (activeSession == null) {
      for (var attempt = 0; attempt < 10; attempt++) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        activeSession = _authRepository.currentSession;
        if (activeSession != null) {
          break;
        }
      }
    }

    if (activeSession == null) {
      throw StateError(
        'Login concluído, mas a sessão não ficou disponível no app.',
      );
    }

    await _studyRepository.sync(activeSession.user.id);
    final profile = await _studyRepository.getProfile(activeSession.user.id);

    if (profile == null || !profile.onboardingCompleted) {
      return AppRoutes.onboarding;
    }

    return AppRoutes.dashboard;
  }
}
