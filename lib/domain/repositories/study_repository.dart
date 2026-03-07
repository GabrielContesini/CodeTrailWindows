import '../../domain/entities/app_entities.dart';
import '../../shared/models/app_view_models.dart';

abstract class StudyRepository {
  Future<void> ensureSeededCatalog();
  Future<void> sync(String userId);

  Future<ProfileEntity?> getProfile(String userId);
  Future<UserGoalEntity?> getGoal(String userId);
  Future<AppSettingsEntity?> getSettings(String userId);

  Stream<List<StudySessionEntity>> watchSessions(String userId);
  Stream<List<TaskEntity>> watchTasks(String userId);
  Stream<List<ReviewEntity>> watchReviews(String userId);
  Stream<List<ProjectBundle>> watchProjects(String userId);
  Stream<List<StudyNoteEntity>> watchNotes(String userId);
  Stream<List<TrackBlueprint>> watchTracks(String userId);

  Future<List<TrackBlueprint>> getTracks(String userId);
  Future<TrackBlueprint?> getTrack(String userId, String trackId);

  Future<void> completeOnboarding(OnboardingInput input);
  Future<void> saveStudySession(StudySessionEntity session);
  Future<void> deleteStudySession(String sessionId);
  Future<void> saveTask(TaskEntity task);
  Future<void> deleteTask(String taskId);
  Future<void> saveReview(ReviewEntity review);
  Future<void> saveReviews(List<ReviewEntity> reviews);
  Future<void> completeReview(ReviewEntity review);
  Future<void> deleteReview(String reviewId);
  Future<void> saveProject(ProjectEntity project);
  Future<void> saveProjectStep(ProjectStepEntity step);
  Future<void> deleteProjectStep(String stepId);
  Future<void> deleteProject(String projectId);
  Future<void> saveNote(StudyNoteEntity note);
  Future<void> deleteNote(String noteId);
  Future<void> saveProfile(ProfileEntity profile);
  Future<void> saveGoal(UserGoalEntity goal);
  Future<void> saveSettings(AppSettingsEntity settings);
}
