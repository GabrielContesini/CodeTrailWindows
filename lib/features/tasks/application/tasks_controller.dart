import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/entities/app_entities.dart';
import '../../auth/application/auth_controller.dart';

final tasksProvider = StreamProvider<List<TaskEntity>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const <TaskEntity>[]);
  return ref.watch(studyRepositoryProvider).watchTasks(userId);
});

final taskActionsProvider = Provider<TaskActions>((ref) {
  return TaskActions(ref);
});

class TaskActions {
  const TaskActions(this._ref);

  final Ref _ref;

  Future<void> save(TaskEntity task) {
    return _ref.read(studyRepositoryProvider).saveTask(task);
  }

  Future<void> delete(String taskId) {
    return _ref.read(studyRepositoryProvider).deleteTask(taskId);
  }
}
