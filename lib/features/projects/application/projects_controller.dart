import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/entities/billing_entities.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/models/app_view_models.dart';
import '../../auth/application/auth_controller.dart';
import '../../billing/application/billing_access_exception.dart';
import '../../billing/application/billing_controller.dart';

final projectsProvider = StreamProvider<List<ProjectBundle>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const <ProjectBundle>[]);
  return ref.watch(studyRepositoryProvider).watchProjects(userId);
});

final projectActionsProvider = Provider<ProjectActions>((ref) {
  return ProjectActions(ref);
});

class ProjectActions {
  const ProjectActions(this._ref);

  final Ref _ref;

  Future<void> saveProject(ProjectEntity project) async {
    final projects = await _ref.read(projectsProvider.future);
    final isEditingExisting = projects.any(
      (item) => item.project.id == project.id,
    );
    final decision = _ref
        .read(billingEntitlementServiceProvider)
        .checkCreationAccess(
          _ref.read(currentBillingSnapshotProvider),
          limitFeatureKey: BillingFeatureKey.projectsLimit,
          usedCount: projects.length,
          isEditingExisting: isEditingExisting,
          resourceLabel: 'projeto',
        );
    if (!decision.allowed) {
      throw BillingAccessException(decision);
    }

    return _ref.read(studyRepositoryProvider).saveProject(project);
  }

  Future<void> saveProjects(List<ProjectEntity> projects) async {
    final existingProjects = await _ref.read(projectsProvider.future);
    final existingIds = existingProjects.map((item) => item.project.id).toSet();
    final newProjects = projects
        .where((project) => !existingIds.contains(project.id))
        .toList();
    final decision = _ref
        .read(billingEntitlementServiceProvider)
        .checkCreationAccess(
          _ref.read(currentBillingSnapshotProvider),
          limitFeatureKey: BillingFeatureKey.projectsLimit,
          usedCount: existingProjects.length + newProjects.length - 1,
          isEditingExisting: newProjects.isEmpty,
          resourceLabel: 'projeto',
        );
    if (!decision.allowed) {
      throw BillingAccessException(decision);
    }

    for (final project in projects) {
      await _ref.read(studyRepositoryProvider).saveProject(project);
    }
  }

  Future<void> saveStep(ProjectStepEntity step) {
    return _ref.read(studyRepositoryProvider).saveProjectStep(step);
  }

  Future<void> deleteStep(String stepId) {
    return _ref.read(studyRepositoryProvider).deleteProjectStep(stepId);
  }

  Future<void> deleteProject(String projectId) {
    return _ref.read(studyRepositoryProvider).deleteProject(projectId);
  }
}
