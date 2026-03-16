import 'package:flutter_test/flutter_test.dart';
import 'package:code_trail_windows/core/utils/note_context_codec.dart';
import 'package:code_trail_windows/domain/entities/app_entities.dart';
import 'package:code_trail_windows/features/mind_maps/application/mind_map_codec.dart';
import 'package:code_trail_windows/features/notes/application/note_ai_generator.dart';

void main() {
  group('NoteAiGenerator', () {
    test('buildFlashcards creates cards from structured note content', () {
      var counter = 0;
      String nextId() => 'id-${counter++}';

      final note = StudyNoteEntity(
        id: 'note-1',
        userId: 'user-1',
        folderName: 'Backend',
        title: 'HTTP essentials',
        content: 'unused',
        createdAt: DateTime.utc(2026, 3, 16),
        updatedAt: DateTime.utc(2026, 3, 16),
      );
      final document = NoteContentDocument(
        body: '''
HTTP: protocolo de comunicacao entre cliente e servidor.

Metodos:
- GET busca recursos.
- POST cria recursos.
- Cache reduz latencia percebida.
''',
        context: const NoteContextLink(
          trackId: 'track-1',
          moduleId: 'module-1',
          projectId: 'project-1',
        ),
      );

      final flashcards = NoteAiGenerator.buildFlashcards(
        note: note,
        noteDocument: document,
        createId: nextId,
        referenceDate: DateTime.utc(2026, 3, 16, 12),
      );

      expect(flashcards.length, greaterThanOrEqualTo(3));
      expect(flashcards.first.question, 'O que significa "HTTP"?');
      expect(
        flashcards.any((item) => item.answer.contains('GET busca recursos')),
        isTrue,
      );
      expect(flashcards.every((item) => item.trackId == 'track-1'), isTrue);
      expect(flashcards.every((item) => item.moduleId == 'module-1'), isTrue);
      expect(flashcards.every((item) => item.projectId == 'project-1'), isTrue);
    });

    test('buildMindMap creates a connected document from note headings', () {
      var counter = 0;
      String nextId() => 'node-${counter++}';

      final note = StudyNoteEntity(
        id: 'note-2',
        userId: 'user-1',
        folderName: 'Arquitetura',
        title: 'Sync offline-first',
        content: 'unused',
        createdAt: DateTime.utc(2026, 3, 16),
        updatedAt: DateTime.utc(2026, 3, 16),
      );
      final document = const NoteContentDocument(
        body: '''
Arquitetura:
- Drift salva localmente.
- Supabase replica mudancas relevantes.

Fila de sync:
- Cada alteracao entra na fila.
- Retry acontece quando a conexao volta.
''',
      );

      final mindMap = NoteAiGenerator.buildMindMap(
        note: note,
        noteDocument: document,
        createId: nextId,
        referenceDate: DateTime.utc(2026, 3, 16, 12),
      );

      expect(mindMap, isNotNull);

      final decoded = MindMapCodec.decode(mindMap!.contentJson);
      expect(decoded.nodes.length, greaterThan(2));
      expect(decoded.connections, isNotEmpty);
      expect(
        decoded.nodes.any((node) => node.label.contains('Arquitetura')),
        isTrue,
      );
      expect(
        decoded.nodes.any((node) => node.label.contains('Fila de sync')),
        isTrue,
      );
    });

    test('buildTasks and buildReviewCycle create actionable outputs', () {
      var counter = 0;
      String nextId() => 'item-${counter++}';

      final note = StudyNoteEntity(
        id: 'note-3',
        userId: 'user-9',
        folderName: 'Flutter',
        title: 'Riverpod aplicacao',
        content: 'unused',
        createdAt: DateTime.utc(2026, 3, 16),
        updatedAt: DateTime.utc(2026, 3, 16),
      );
      final document = const NoteContentDocument(
        body: '''
Checklist:
- Configurar providers principais.
- Separar estado de tela e efeitos.

Revisao:
- Riverpod reduz acoplamento.
- ConsumerWidget escuta providers.
''',
        context: NoteContextLink(
          trackId: 'track-flutter',
          moduleId: 'module-riverpod',
        ),
      );

      final tasks = NoteAiGenerator.buildTasks(
        note: note,
        noteDocument: document,
        createId: nextId,
        referenceDate: DateTime.utc(2026, 3, 16, 12),
      );
      final reviews = NoteAiGenerator.buildReviewCycle(
        note: note,
        noteDocument: document,
        createId: nextId,
        referenceDate: DateTime.utc(2026, 3, 16, 12),
      );

      expect(tasks, isNotEmpty);
      expect(tasks.first.title, contains('Configurar'));
      expect(tasks.every((item) => item.trackId == 'track-flutter'), isTrue);
      expect(reviews.length, 4);
      expect(reviews.first.intervalLabel, 'D+1');
      expect(reviews.last.intervalLabel, 'D+30');
      expect(reviews.every((item) => item.notes?.contains('Riverpod') ?? false), isTrue);
    });
  });
}
