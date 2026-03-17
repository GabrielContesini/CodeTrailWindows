import 'package:code_trail_windows/core/router/app_router.dart';
import 'package:code_trail_windows/core/services/startup_coordinator.dart';
import 'package:code_trail_windows/domain/entities/app_entities.dart';
import 'package:code_trail_windows/domain/entities/billing_entities.dart';
import 'package:code_trail_windows/domain/repositories/auth_repository.dart';
import 'package:code_trail_windows/domain/repositories/billing_repository.dart';
import 'package:code_trail_windows/domain/repositories/study_repository.dart';
import 'package:code_trail_windows/shared/models/app_enums.dart';
import 'package:code_trail_windows/shared/models/app_view_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('StartupCoordinator', () {
    late _FakeAuthRepository authRepository;
    late _FakeBillingRepository billingRepository;
    late _FakeStudyRepository studyRepository;
    late StartupCoordinator coordinator;

    setUp(() {
      authRepository = _FakeAuthRepository();
      billingRepository = _FakeBillingRepository();
      studyRepository = _FakeStudyRepository();
      coordinator = StartupCoordinator(
        authRepository: authRepository,
        billingRepository: billingRepository,
        studyRepository: studyRepository,
      );
    });

    test(
      'resolveInitialRoute seeds catalog and clears stale session',
      () async {
        authRepository.currentSessionValue = _sessionFor('user-1');

        final route = await coordinator.resolveInitialRoute();

        expect(route, AppRoutes.login);
        expect(studyRepository.ensureSeededCatalogCalls, 1);
        expect(authRepository.signOutCalls, 1);
      },
    );

    test(
      'resolveAuthenticatedRoute returns login when restore fails',
      () async {
        authRepository.restoreSessionResult = false;

        final route = await coordinator.resolveAuthenticatedRoute();

        expect(route, AppRoutes.login);
        expect(studyRepository.syncUserIds, isEmpty);
      },
    );

    test(
      'resolveAuthenticatedRoute returns onboarding for incomplete profile',
      () async {
        authRepository.restoreSessionResult = true;
        authRepository.currentSessionValue = _sessionFor('user-2');
        studyRepository.profile = _profile(
          userId: 'user-2',
          onboardingCompleted: false,
        );

        final route = await coordinator.resolveAuthenticatedRoute();

        expect(route, AppRoutes.onboarding);
        expect(studyRepository.syncUserIds, ['user-2']);
        expect(billingRepository.refreshUserIds, ['user-2']);
      },
    );

    test(
      'resolveAuthenticatedRoute returns dashboard for ready profile',
      () async {
        authRepository.restoreSessionResult = true;
        authRepository.currentSessionValue = _sessionFor('user-3');
        studyRepository.profile = _profile(
          userId: 'user-3',
          onboardingCompleted: true,
        );

        final route = await coordinator.resolveAuthenticatedRoute();

        expect(route, AppRoutes.dashboard);
        expect(studyRepository.syncUserIds, ['user-3']);
        expect(billingRepository.refreshUserIds, ['user-3']);
      },
    );

    test('resolvePostLoginRoute throws when session is unavailable', () async {
      expect(coordinator.resolvePostLoginRoute(), throwsA(isA<StateError>()));
    });

    test(
      'resolvePostLoginRoute returns dashboard when session and profile are ready',
      () async {
        authRepository.currentSessionValue = _sessionFor('user-4');
        studyRepository.profile = _profile(
          userId: 'user-4',
          onboardingCompleted: true,
        );

        final route = await coordinator.resolvePostLoginRoute();

        expect(route, AppRoutes.dashboard);
        expect(studyRepository.syncUserIds, ['user-4']);
        expect(billingRepository.refreshUserIds, ['user-4']);
      },
    );
  });
}

class _FakeAuthRepository extends Fake implements AuthRepository {
  Session? currentSessionValue;
  bool restoreSessionResult = true;
  int signOutCalls = 0;

  @override
  Session? get currentSession => currentSessionValue;

  @override
  Stream<Session?> sessionChanges() =>
      Stream<Session?>.value(currentSessionValue);

  @override
  Future<bool> restoreSessionOrSignOut() async => restoreSessionResult;

  @override
  Future<void> signOut() async {
    signOutCalls += 1;
    currentSessionValue = null;
  }
}

class _FakeStudyRepository extends Fake implements StudyRepository {
  int ensureSeededCatalogCalls = 0;
  final List<String> syncUserIds = <String>[];
  ProfileEntity? profile;

  @override
  Future<void> ensureSeededCatalog() async {
    ensureSeededCatalogCalls += 1;
  }

  @override
  Future<void> sync(String userId) async {
    syncUserIds.add(userId);
  }

  @override
  Future<void> forceSync(String userId) async {}

  @override
  Future<ProfileEntity?> getProfile(String userId) async => profile;

  @override
  Future<UserGoalEntity?> getGoal(String userId) async => null;

  @override
  Future<AppSettingsEntity?> getSettings(String userId) async => null;

  @override
  Stream<List<StudySessionEntity>> watchSessions(String userId) =>
      const Stream<List<StudySessionEntity>>.empty();

  @override
  Stream<List<TaskEntity>> watchTasks(String userId) =>
      const Stream<List<TaskEntity>>.empty();

  @override
  Stream<List<ReviewEntity>> watchReviews(String userId) =>
      const Stream<List<ReviewEntity>>.empty();

  @override
  Stream<List<ProjectBundle>> watchProjects(String userId) =>
      const Stream<List<ProjectBundle>>.empty();

  @override
  Stream<List<StudyNoteEntity>> watchNotes(String userId) =>
      const Stream<List<StudyNoteEntity>>.empty();

  @override
  Stream<List<FlashcardEntity>> watchFlashcards(String userId) =>
      const Stream<List<FlashcardEntity>>.empty();

  @override
  Stream<List<MindMapEntity>> watchMindMaps(String userId) =>
      const Stream<List<MindMapEntity>>.empty();

  @override
  Stream<List<TrackBlueprint>> watchTracks(String userId) =>
      const Stream<List<TrackBlueprint>>.empty();

  @override
  Future<List<TrackBlueprint>> getTracks(String userId) async => const [];

  @override
  Future<TrackBlueprint?> getTrack(String userId, String trackId) async => null;

  @override
  Future<void> completeOnboarding(OnboardingInput input) async {}

  @override
  Future<void> saveStudySession(StudySessionEntity session) async {}

  @override
  Future<void> deleteStudySession(String sessionId) async {}

  @override
  Future<void> saveTask(TaskEntity task) async {}

  @override
  Future<void> deleteTask(String taskId) async {}

  @override
  Future<void> saveReview(ReviewEntity review) async {}

  @override
  Future<void> saveReviews(List<ReviewEntity> reviews) async {}

  @override
  Future<void> completeReview(ReviewEntity review) async {}

  @override
  Future<void> deleteReview(String reviewId) async {}

  @override
  Future<void> saveProject(ProjectEntity project) async {}

  @override
  Future<void> saveProjectStep(ProjectStepEntity step) async {}

  @override
  Future<void> deleteProjectStep(String stepId) async {}

  @override
  Future<void> deleteProject(String projectId) async {}

  @override
  Future<void> saveNote(StudyNoteEntity note) async {}

  @override
  Future<void> deleteNote(String noteId) async {}

  @override
  Future<void> saveFlashcard(FlashcardEntity flashcard) async {}

  @override
  Future<void> deleteFlashcard(String flashcardId) async {}

  @override
  Future<void> saveMindMap(MindMapEntity mindMap) async {}

  @override
  Future<void> deleteMindMap(String mindMapId) async {}

  @override
  Future<void> saveProfile(ProfileEntity profile) async {}

  @override
  Future<void> saveGoal(UserGoalEntity goal) async {}

  @override
  Future<void> saveSettings(AppSettingsEntity settings) async {}
}

class _FakeBillingRepository extends Fake implements BillingRepository {
  final List<String> refreshUserIds = <String>[];

  @override
  Future<BillingSnapshot?> loadCachedSnapshot(String userId) async => null;

  @override
  Future<BillingSnapshot> refreshSnapshot(String userId) async {
    refreshUserIds.add(userId);
    return BillingSnapshot.fallbackFree();
  }

  @override
  Future<BillingCheckoutSession> createCheckout({
    required String userId,
    required BillingPlanCode planCode,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<String> createPortalSession(String userId) {
    throw UnimplementedError();
  }

  @override
  Future<BillingSnapshot> cancelSubscription(String userId) {
    throw UnimplementedError();
  }

  @override
  Future<BillingSnapshot> syncSubscription(
    String userId, {
    String? gatewaySubscriptionId,
    String? paymentId,
  }) {
    throw UnimplementedError();
  }
}

ProfileEntity _profile({
  required String userId,
  required bool onboardingCompleted,
}) {
  final now = DateTime.utc(2026, 3, 9, 12);
  return ProfileEntity(
    id: userId,
    fullName: 'Gabriel',
    desiredArea: 'Backend',
    currentLevel: SkillLevel.junior,
    onboardingCompleted: onboardingCompleted,
    createdAt: now,
    updatedAt: now,
  );
}

Session _sessionFor(String userId) {
  return Session.fromJson({
    'access_token': 'header.payload.signature',
    'token_type': 'bearer',
    'refresh_token': 'refresh-token',
    'user': {
      'id': userId,
      'aud': 'authenticated',
      'app_metadata': {'provider': 'email'},
      'user_metadata': {'full_name': 'Gabriel'},
      'email': '$userId@example.com',
      'created_at': '2026-03-09T12:00:00.000Z',
    },
  })!;
}
