import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../shared/models/app_view_models.dart';

final sessionTemplatesProvider = AsyncNotifierProvider<
    SessionTemplatesController,
    List<StudySessionTemplate>>(
  SessionTemplatesController.new,
);

class SessionTemplatesController
    extends AsyncNotifier<List<StudySessionTemplate>> {
  @override
  FutureOr<List<StudySessionTemplate>> build() {
    return ref.read(sessionTemplateServiceProvider).loadTemplates();
  }

  Future<void> saveTemplates(List<StudySessionTemplate> templates) async {
    state = await AsyncValue.guard(() async {
      await ref.read(sessionTemplateServiceProvider).saveTemplates(templates);
      return templates;
    });
  }

  Future<void> resetTemplates() async {
    state = await AsyncValue.guard(() async {
      await ref.read(sessionTemplateServiceProvider).resetTemplates();
      return StudySessionTemplate.defaults();
    });
  }
}
