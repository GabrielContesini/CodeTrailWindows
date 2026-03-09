import 'package:code_trail_windows/core/utils/note_context_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NoteContextCodec', () {
    test('encodes and decodes linked note metadata', () {
      const context = NoteContextLink(
        trackId: 'track-1',
        trackLabel: 'Backend Python',
        moduleId: 'module-1',
        moduleLabel: 'Persistencia',
        projectId: 'project-1',
        projectLabel: 'API Portfolio',
      );

      final content = NoteContextCodec.encode(
        body: 'Resumo importante do modulo.',
        context: context,
      );
      final document = NoteContextCodec.decode(content);

      expect(document.body, 'Resumo importante do modulo.');
      expect(document.context.trackId, 'track-1');
      expect(document.context.moduleLabel, 'Persistencia');
      expect(document.context.projectLabel, 'API Portfolio');
    });

    test('returns plain content when no metadata exists', () {
      final document = NoteContextCodec.decode('Nota solta');

      expect(document.body, 'Nota solta');
      expect(document.context.hasContext, isFalse);
    });
  });
}
