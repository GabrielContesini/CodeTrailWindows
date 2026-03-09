import 'package:code_trail_windows/core/services/study_plan_generator.dart';
import 'package:code_trail_windows/domain/entities/app_entities.dart';
import 'package:code_trail_windows/shared/models/app_enums.dart';
import 'package:code_trail_windows/shared/models/app_view_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StudyPlanGenerator', () {
    test('buildPreview derives milestones and weekly cadence', () {
      final preview = StudyPlanGenerator.buildPreview(
        _input(),
        blueprint: _blueprint(),
        referenceDate: DateTime.utc(2026, 3, 9),
      );

      expect(preview.weeklyHours, 15);
      expect(preview.horizonWeeks, 18);
      expect(preview.trackEffortHours, 28);
      expect(preview.milestones, isNotEmpty);
      expect(preview.weeklyPlaybook, hasLength(3));
    });

    test('buildSummary includes confidence and weekly load', () {
      final summary = StudyPlanGenerator.buildSummary(
        _input(),
        blueprint: _blueprint(),
        referenceDate: DateTime.utc(2026, 3, 9),
      );

      expect(summary, contains('Carga semanal estimada: 15h.'));
      expect(summary, contains('Ritmo sugerido:'));
      expect(summary, contains('Backend Python'));
    });
  });
}

OnboardingInput _input() {
  return OnboardingInput(
    userId: 'user-1',
    name: 'Gabriel',
    objective: 'Conseguir vaga backend',
    desiredArea: 'Backend',
    trackId: 'track-backend',
    selectedTrackName: 'Backend Python',
    currentLevel: SkillLevel.beginner,
    hoursPerDay: 3,
    daysPerWeek: 5,
    deadline: DateTime.utc(2026, 7, 10),
    focusType: FocusType.job,
  );
}

TrackBlueprint _blueprint() {
  final now = DateTime.utc(2026, 3, 9);
  return TrackBlueprint(
    track: StudyTrackEntity(
      id: 'track-backend',
      name: 'Backend Python',
      description: 'APIs, banco e deploy.',
      iconKey: 'server',
      colorHex: '#4F8CFF',
      roadmapSummary: 'Base sólida de backend',
      createdAt: now,
      updatedAt: now,
    ),
    skills: const [],
    modules: [
      StudyModuleEntity(
        id: 'mod-1',
        trackId: 'track-backend',
        title: 'Python HTTP fundamentals',
        summary: 'Rotas, handlers e contratos.',
        estimatedHours: 10,
        sortOrder: 1,
        isCore: true,
        createdAt: now,
        updatedAt: now,
      ),
      StudyModuleEntity(
        id: 'mod-2',
        trackId: 'track-backend',
        title: 'Persistência e ORM',
        summary: 'Modelagem e queries.',
        estimatedHours: 8,
        sortOrder: 2,
        isCore: true,
        createdAt: now,
        updatedAt: now,
      ),
      StudyModuleEntity(
        id: 'mod-3',
        trackId: 'track-backend',
        title: 'Deploy e observabilidade',
        summary: 'Entrega e monitoramento.',
        estimatedHours: 10,
        sortOrder: 3,
        isCore: true,
        createdAt: now,
        updatedAt: now,
      ),
    ],
    progressBySkill: const {},
  );
}
