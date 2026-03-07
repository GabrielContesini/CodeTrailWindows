import '../../shared/models/app_view_models.dart';
import '../entities/app_entities.dart';
import '../repositories/study_repository.dart';

class CompleteOnboardingUseCase {
  const CompleteOnboardingUseCase(this._repository);

  final StudyRepository _repository;

  Future<void> call(OnboardingInput input) {
    return _repository.completeOnboarding(input);
  }
}

class SaveStudySessionUseCase {
  const SaveStudySessionUseCase(this._repository);

  final StudyRepository _repository;

  Future<void> call(StudySessionEntity session) {
    return _repository.saveStudySession(session);
  }
}

class SaveTaskUseCase {
  const SaveTaskUseCase(this._repository);

  final StudyRepository _repository;

  Future<void> call(TaskEntity task) {
    return _repository.saveTask(task);
  }
}

class RunSyncUseCase {
  const RunSyncUseCase(this._repository);

  final StudyRepository _repository;

  Future<void> call(String userId) {
    return _repository.sync(userId);
  }
}
