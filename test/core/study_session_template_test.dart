import 'package:flutter_test/flutter_test.dart';

import 'package:code_trail_windows/shared/models/app_enums.dart';
import 'package:code_trail_windows/shared/models/app_view_models.dart';

void main() {
  group('StudySessionTemplate', () {
    test('defaults expose the expected presets', () {
      final templates = StudySessionTemplate.defaults();

      expect(templates, hasLength(4));
      expect(
        templates.map((template) => template.type),
        containsAll(<SessionType>[
          SessionType.theory,
          SessionType.practice,
          SessionType.review,
          SessionType.project,
        ]),
      );
    });

    test('renderNotes injects track and module placeholders', () {
      const template = StudySessionTemplate(
        id: 'practice',
        title: 'Pratica guiada',
        subtitle: 'Executar o modulo alvo',
        type: SessionType.practice,
        productivity: 4,
        notesTemplate: 'Track: {track}\nModulo: {module}',
        prefersCoreModule: true,
      );

      final notes = template.renderNotes(
        trackName: 'Backend Python',
        moduleTitle: 'APIs REST',
      );

      expect(notes, contains('Backend Python'));
      expect(notes, contains('APIs REST'));
      expect(notes, isNot(contains('{track}')));
      expect(notes, isNot(contains('{module}')));
    });

    test('serializes and restores template data', () {
      const template = StudySessionTemplate(
        id: 'review',
        title: 'Revisao',
        subtitle: 'Rodar repeticao',
        type: SessionType.review,
        productivity: 3,
        notesTemplate: 'Revisar {module}',
        prefersCoreModule: false,
      );

      final restored = StudySessionTemplate.fromJson(template.toJson());

      expect(restored.toJson(), template.toJson());
    });
  });
}
