import 'dart:math' as math;

import '../../../core/utils/note_context_codec.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/models/app_enums.dart';
import '../../mind_maps/application/mind_map_codec.dart';
import '../../mind_maps/application/mind_map_document.dart';

class NoteAiGenerator {
  const NoteAiGenerator._();

  static const int _maxFlashcards = 8;
  static const int _maxMindMapBranches = 6;
  static const List<String> _genericSectionTitles = <String>[
    'anotacoes',
    'anotacoes chave',
    'checklist',
    'codigo comando',
    'codigo',
    'comandos',
    'conteudo',
    'contexto',
    'dicas',
    'exemplo',
    'exemplos',
    'observacoes',
    'passos',
    'pontos chave',
    'proximos passos',
    'resumo',
    'topicos',
    'uso',
  ];
  static const List<String> _branchColors = <String>[
    '#2EC5FF',
    '#7A77FF',
    '#35D49A',
    '#FF9B54',
    '#FF6B81',
    '#FFD166',
  ];

  static List<FlashcardEntity> buildFlashcards({
    required StudyNoteEntity note,
    required NoteContentDocument noteDocument,
    required String Function() createId,
    DateTime? referenceDate,
  }) {
    final parsed = _parseNote(note.title, noteDocument.body);
    final now = (referenceDate ?? DateTime.now()).toUtc();
    final cards = <FlashcardEntity>[];
    final seenAnswers = <String>{};
    final deckName = _buildDeckName(note.title);

    for (final fact in parsed.factPairs) {
      final normalizedAnswer = _normalizeKey(fact.definition);
      if (!seenAnswers.add(normalizedAnswer)) {
        continue;
      }
      cards.add(
        FlashcardEntity(
          id: createId(),
          userId: note.userId,
          deckName: deckName,
          question: _buildFactQuestion(fact.term),
          answer: fact.definition,
          trackId: noteDocument.context.trackId,
          moduleId: noteDocument.context.moduleId,
          projectId: noteDocument.context.projectId,
          dueAt: now,
          lastReviewedAt: null,
          reviewCount: 0,
          correctStreak: 0,
          easeFactor: 2.5,
          intervalDays: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (cards.length >= _maxFlashcards) {
        return cards;
      }
    }

    for (final section in parsed.sections) {
      for (var index = 0; index < section.points.length; index++) {
        final point = section.points[index];
        final normalizedAnswer = _normalizeKey(point);
        if (!seenAnswers.add(normalizedAnswer)) {
          continue;
        }
        cards.add(
          FlashcardEntity(
            id: createId(),
            userId: note.userId,
            deckName: deckName,
            question: _buildSectionQuestion(
              note.title,
              section.title,
              index + 1,
            ),
            answer: point,
            trackId: noteDocument.context.trackId,
            moduleId: noteDocument.context.moduleId,
            projectId: noteDocument.context.projectId,
            dueAt: now,
            lastReviewedAt: null,
            reviewCount: 0,
            correctStreak: 0,
            easeFactor: 2.5,
            intervalDays: 0,
            createdAt: now,
            updatedAt: now,
          ),
        );
        if (cards.length >= _maxFlashcards) {
          return cards;
        }
      }
    }

    return cards;
  }

  static MindMapEntity? buildMindMap({
    required StudyNoteEntity note,
    required NoteContentDocument noteDocument,
    required String Function() createId,
    DateTime? referenceDate,
  }) {
    final parsed = _parseNote(note.title, noteDocument.body);
    final branches = _buildMindMapBranches(note.title, parsed);
    if (branches.isEmpty) {
      return null;
    }

    final rootLabel = _shortLabel(note.title, maxWords: 5, maxLength: 42);
    final document = _buildMindMapDocument(
      rootLabel: rootLabel.isEmpty ? 'Tema central' : rootLabel,
      branches: branches.take(_maxMindMapBranches).toList(),
      createId: createId,
    );
    final now = (referenceDate ?? DateTime.now()).toUtc();

    return MindMapEntity(
      id: createId(),
      userId: note.userId,
      folderName: note.folderName,
      title: 'Mapa IA - ${_truncate(note.title, 42)}',
      contentJson: MindMapCodec.encode(document),
      trackId: noteDocument.context.trackId,
      moduleId: noteDocument.context.moduleId,
      projectId: noteDocument.context.projectId,
      createdAt: now,
      updatedAt: now,
    );
  }

  static List<TaskEntity> buildTasks({
    required StudyNoteEntity note,
    required NoteContentDocument noteDocument,
    required String Function() createId,
    DateTime? referenceDate,
  }) {
    final parsed = _parseNote(note.title, noteDocument.body);
    final now = (referenceDate ?? DateTime.now()).toUtc();
    final suggestions = _buildTaskSuggestions(note.title, parsed);
    final tasks = <TaskEntity>[];

    for (var index = 0; index < suggestions.length; index++) {
      final suggestion = suggestions[index];
      tasks.add(
        TaskEntity(
          id: createId(),
          userId: note.userId,
          trackId: noteDocument.context.trackId,
          moduleId: noteDocument.context.moduleId,
          title: suggestion.title,
          description: suggestion.description,
          priority: index == 0 ? TaskPriority.high : TaskPriority.medium,
          status: TaskStatus.pending,
          dueDate: now.add(Duration(days: math.min(14, 1 + (index * 2)))),
          completedAt: null,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    return tasks;
  }

  static List<ReviewEntity> buildReviewCycle({
    required StudyNoteEntity note,
    required NoteContentDocument noteDocument,
    required String Function() createId,
    DateTime? referenceDate,
  }) {
    final parsed = _parseNote(note.title, noteDocument.body);
    final now = (referenceDate ?? DateTime.now()).toUtc();
    final schedule = <int>[1, 7, 15, 30];
    final reviewNotes = _buildReviewNotes(note, noteDocument, parsed);

    return schedule
        .map(
          (days) => ReviewEntity(
            id: createId(),
            userId: note.userId,
            trackId: noteDocument.context.trackId,
            skillId: null,
            title: note.title,
            scheduledFor: now.add(Duration(days: days)),
            status: ReviewStatus.pending,
            intervalLabel: 'D+$days',
            notes: reviewNotes,
            completedAt: null,
            createdAt: now,
            updatedAt: now,
          ),
        )
        .toList(growable: false);
  }

  static _ParsedNote _parseNote(String noteTitle, String body) {
    final normalizedBody = body.replaceAll('\r\n', '\n').trim();
    final defaultTitle = _sanitizeLabel(noteTitle) ?? 'Tema central';
    final sections = <_MutableSection>[];
    final factPairs = <_NoteFactPair>[];
    final fallbackSection = _ensureSection(sections, defaultTitle);
    var currentSection = fallbackSection;

    for (final rawLine in normalizedBody.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('```')) {
        continue;
      }

      final heading = _extractHeading(line);
      if (heading != null) {
        currentSection = _ensureSection(sections, heading);
        continue;
      }

      final point = _cleanLine(line);
      if (point == null) {
        continue;
      }

      final pair = _extractFactPair(point, currentSection.title);
      if (pair != null) {
        final normalizedTerm = _normalizeKey(pair.term);
        final alreadyExists = factPairs.any(
          (item) => _normalizeKey(item.term) == normalizedTerm,
        );
        if (!alreadyExists) {
          factPairs.add(pair);
          currentSection.factPairs.add(pair);
        }
        continue;
      }

      final normalizedPoint = _normalizeKey(point);
      final alreadyExists = currentSection.points.any(
        (item) => _normalizeKey(item) == normalizedPoint,
      );
      if (!alreadyExists) {
        currentSection.points.add(point);
      }
    }

    final totalPoints = sections.fold<int>(
      0,
      (sum, section) => sum + section.points.length + section.factPairs.length,
    );
    if (totalPoints < 3) {
      for (final sentence in _extractSentenceFallbacks(normalizedBody)) {
        final normalizedSentence = _normalizeKey(sentence);
        final alreadyExists = fallbackSection.points.any(
          (item) => _normalizeKey(item) == normalizedSentence,
        );
        if (!alreadyExists) {
          fallbackSection.points.add(sentence);
        }
      }
    }

    return _ParsedNote(
      sections: sections
          .where(
            (section) =>
                section.points.isNotEmpty || section.factPairs.isNotEmpty,
          )
          .map(
            (section) => _NoteSection(
              title: section.title,
              points: List<String>.unmodifiable(section.points),
              factPairs: List<_NoteFactPair>.unmodifiable(section.factPairs),
            ),
          )
          .toList(growable: false),
      factPairs: List<_NoteFactPair>.unmodifiable(factPairs),
    );
  }

  static _MutableSection _ensureSection(
    List<_MutableSection> sections,
    String title,
  ) {
    final normalizedTitle = _normalizeKey(title);
    for (final section in sections) {
      if (_normalizeKey(section.title) == normalizedTitle) {
        return section;
      }
    }
    final section = _MutableSection(title: title);
    sections.add(section);
    return section;
  }

  static String? _extractHeading(String rawLine) {
    final markdownHeading = RegExp(r'^#{1,6}\s+(.+)$').firstMatch(rawLine);
    if (markdownHeading != null) {
      final label = _sanitizeLabel(markdownHeading.group(1));
      return label;
    }

    if (rawLine.endsWith(':') && rawLine.length <= 64) {
      final label = _sanitizeLabel(rawLine.substring(0, rawLine.length - 1));
      return label;
    }

    return null;
  }

  static String? _cleanLine(String rawLine) {
    var value = rawLine.trim();
    value = value.replaceFirst(
      RegExp(r'^(\- \[[ xX]\]\s+|\- |\* |\u2022 |\d+[.)]\s+)'),
      '',
    );
    value = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (value.length < 4) {
      return null;
    }
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return null;
    }
    return value;
  }

  static _NoteFactPair? _extractFactPair(String point, String sectionTitle) {
    final separator = point.indexOf(':');
    if (separator <= 1 || separator >= point.length - 4) {
      return null;
    }

    final term = point.substring(0, separator).trim();
    final definition = point.substring(separator + 1).trim();
    final termWordCount = term.split(RegExp(r'\s+')).length;
    if (termWordCount > 7 || term.endsWith('?') || definition.length < 6) {
      return null;
    }

    return _NoteFactPair(
      term: _truncate(term, 60),
      definition: _truncate(definition, 220),
      sectionTitle: sectionTitle,
    );
  }

  static List<String> _extractSentenceFallbacks(String body) {
    final sentences = <String>[];
    final normalized = body.replaceAll('\n', ' ');
    for (final rawSentence in normalized.split(RegExp(r'(?<=[.!?])\s+'))) {
      final sentence = rawSentence
          .replaceAll(RegExp(r'[.!?]+$'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (sentence.length < 24 || sentence.length > 180) {
        continue;
      }
      final wordCount = sentence.split(RegExp(r'\s+')).length;
      if (wordCount < 5 || wordCount > 28) {
        continue;
      }
      sentences.add(sentence);
      if (sentences.length == 4) {
        break;
      }
    }
    return sentences;
  }

  static String _buildDeckName(String noteTitle) {
    final label = _truncate(noteTitle.trim(), 42);
    return label.isEmpty ? 'IA local' : 'IA - $label';
  }

  static String _buildFactQuestion(String term) {
    return 'O que significa "$term"?';
  }

  static String _buildSectionQuestion(
    String noteTitle,
    String sectionTitle,
    int itemIndex,
  ) {
    if (_normalizeKey(sectionTitle) == _normalizeKey(noteTitle)) {
      return 'Qual e o ponto-chave $itemIndex desta nota?';
    }
    return 'Em "$sectionTitle", qual e o ponto-chave $itemIndex?';
  }

  static List<_MindMapBranch> _buildMindMapBranches(
    String noteTitle,
    _ParsedNote parsed,
  ) {
    final branches = <_MindMapBranch>[];
    final seenLabels = <String>{};

    for (final section in parsed.sections) {
      final isPrimarySection =
          _normalizeKey(section.title) != _normalizeKey(noteTitle) &&
          !_isGenericSectionTitle(section.title);
      if (!isPrimarySection) {
        continue;
      }

      final children = <String>[
        ...section.factPairs.map((item) => _shortLabel(item.term)),
        ...section.points.map(_pointToLeafLabel),
      ];
      final dedupedChildren = _dedupeLabels(children).take(3).toList();
      final label = _shortLabel(section.title, maxWords: 5, maxLength: 30);
      if (label.isEmpty || !seenLabels.add(_normalizeKey(label))) {
        continue;
      }
      branches.add(
        _MindMapBranch(
          label: label,
          children: dedupedChildren,
        ),
      );
      if (branches.length >= _maxMindMapBranches) {
        return branches;
      }
    }

    if (branches.isEmpty) {
      for (final pair in parsed.factPairs) {
        final label = _shortLabel(pair.term, maxWords: 5, maxLength: 30);
        if (label.isEmpty || !seenLabels.add(_normalizeKey(label))) {
          continue;
        }
        final child = _shortLabel(
          pair.definition,
          maxWords: 8,
          maxLength: 40,
        );
        branches.add(
          _MindMapBranch(
            label: label,
            children: child.isEmpty ? const <String>[] : <String>[child],
          ),
        );
        if (branches.length >= _maxMindMapBranches) {
          return branches;
        }
      }
    }

    if (branches.isEmpty) {
      for (final section in parsed.sections) {
        for (final point in section.points) {
          final label = _pointToLeafLabel(point);
          if (label.isEmpty || !seenLabels.add(_normalizeKey(label))) {
            continue;
          }
          final child = _shortLabel(point, maxWords: 8, maxLength: 40);
          branches.add(
            _MindMapBranch(
              label: label,
              children: child == label ? const <String>[] : <String>[child],
            ),
          );
          if (branches.length >= _maxMindMapBranches) {
            return branches;
          }
        }
      }
    }

    return branches;
  }

  static List<_TaskSuggestion> _buildTaskSuggestions(
    String noteTitle,
    _ParsedNote parsed,
  ) {
    final suggestions = <_TaskSuggestion>[];
    final seenTitles = <String>{};

    void addSuggestion(String title, String description) {
      final cleanTitle = _truncate(title.trim(), 64);
      final cleanDescription = _truncate(description.trim(), 220);
      final normalizedTitle = _normalizeKey(cleanTitle);
      if (cleanTitle.isEmpty ||
          cleanDescription.isEmpty ||
          !seenTitles.add(normalizedTitle)) {
        return;
      }
      suggestions.add(
        _TaskSuggestion(
          title: cleanTitle,
          description: cleanDescription,
        ),
      );
    }

    for (final section in parsed.sections) {
      if (section.points.isEmpty) {
        continue;
      }

      if (_normalizeKey(section.title) == 'checklist' ||
          _normalizeKey(section.title) == 'passos') {
        for (final point in section.points.take(3)) {
          addSuggestion(
            _imperativeTaskTitle(point),
            'Gerado da nota "$noteTitle". Foco: $point',
          );
        }
        if (suggestions.length >= 5) {
          return suggestions.take(5).toList(growable: false);
        }
        continue;
      }

      final focusPoint = section.points.first;
      final title = _normalizeKey(section.title) == _normalizeKey(noteTitle)
          ? 'Consolidar ${_pointToLeafLabel(focusPoint)}'
          : 'Praticar ${_shortLabel(section.title, maxWords: 5, maxLength: 32)}';
      addSuggestion(
        title,
        'Transforme a nota em acao. Comece por: $focusPoint',
      );
      if (suggestions.length >= 5) {
        return suggestions.take(5).toList(growable: false);
      }
    }

    for (final pair in parsed.factPairs) {
      addSuggestion(
        'Revisar ${_shortLabel(pair.term, maxWords: 5, maxLength: 32)}',
        'Explique com as proprias palavras e valide: ${pair.definition}',
      );
      if (suggestions.length >= 5) {
        return suggestions.take(5).toList(growable: false);
      }
    }

    return suggestions.take(5).toList(growable: false);
  }

  static String _buildReviewNotes(
    StudyNoteEntity note,
    NoteContentDocument noteDocument,
    _ParsedNote parsed,
  ) {
    final bullets = <String>[];

    for (final pair in parsed.factPairs.take(2)) {
      bullets.add('- ${pair.term}: ${pair.definition}');
    }
    if (bullets.length < 3) {
      for (final section in parsed.sections.take(3)) {
        if (section.points.isEmpty) {
          continue;
        }
        bullets.add('- ${section.title}: ${section.points.first}');
        if (bullets.length == 3) {
          break;
        }
      }
    }

    final labels = noteDocument.context.labels;
    return <String>[
      'Revisar a nota "${note.title}".',
      if (labels.isNotEmpty) 'Contexto: ${labels.join(' • ')}',
      if (bullets.isNotEmpty) 'Pontos para lembrar:\n${bullets.join('\n')}',
    ].join('\n\n');
  }

  static List<String> _dedupeLabels(List<String> labels) {
    final seen = <String>{};
    final deduped = <String>[];
    for (final label in labels) {
      final normalized = _normalizeKey(label);
      if (normalized.isEmpty || !seen.add(normalized)) {
        continue;
      }
      deduped.add(label);
    }
    return deduped;
  }

  static String _pointToLeafLabel(String point) {
    final separator = point.indexOf(':');
    if (separator > 1 && separator < 36) {
      return _shortLabel(point.substring(0, separator), maxWords: 5);
    }
    return _shortLabel(point, maxWords: 5, maxLength: 32);
  }

  static String _imperativeTaskTitle(String point) {
    final cleaned = _shortLabel(point, maxWords: 7, maxLength: 48);
    if (cleaned.isEmpty) {
      return 'Executar proximo passo';
    }
    final first = cleaned[0].toUpperCase();
    final rest = cleaned.substring(1);
    return '$first$rest';
  }

  static bool _isGenericSectionTitle(String title) {
    final normalized = _normalizeKey(title);
    return _genericSectionTitles.contains(normalized);
  }

  static MindMapDocument _buildMindMapDocument({
    required String rootLabel,
    required List<_MindMapBranch> branches,
    required String Function() createId,
  }) {
    const centerX = 1100.0;
    const centerY = 700.0;
    const branchRadius = 380.0;
    const childRadius = 210.0;

    final nodes = <MindMapCanvasNode>[
      MindMapCanvasNode(
        id: 'root-${createId()}',
        label: rootLabel,
        shape: MindMapNodeShape.rounded,
        colorHex: '#2EC5FF',
        x: centerX - 130,
        y: centerY - 62,
        width: 260,
        height: 124,
      ),
    ];
    final connections = <MindMapCanvasConnection>[];
    final rootId = nodes.first.id;

    for (var branchIndex = 0; branchIndex < branches.length; branchIndex++) {
      final branch = branches[branchIndex];
      final angle = -math.pi / 2 + (2 * math.pi * branchIndex / branches.length);
      final branchX = centerX + math.cos(angle) * branchRadius;
      final branchY = centerY + math.sin(angle) * branchRadius;
      final branchId = 'branch-${createId()}';
      final branchColor = _branchColors[branchIndex % _branchColors.length];

      nodes.add(
        MindMapCanvasNode(
          id: branchId,
          label: branch.label,
          shape: MindMapNodeShape.rectangle,
          colorHex: branchColor,
          x: branchX - 110,
          y: branchY - 50,
          width: _nodeWidth(branch.label, min: 190, max: 240),
          height: 100,
        ),
      );
      connections.add(
        MindMapCanvasConnection(
          id: 'connection-${createId()}',
          sourceId: rootId,
          targetId: branchId,
        ),
      );

      if (branch.children.isEmpty) {
        continue;
      }

      final spread =
          branch.children.length == 1 ? 0.0 : math.min(0.9, branch.children.length * 0.22);
      for (var childIndex = 0; childIndex < branch.children.length; childIndex++) {
        final child = branch.children[childIndex];
        final childOffset = branch.children.length == 1
            ? 0.0
            : (-spread / 2) + (spread * childIndex / (branch.children.length - 1));
        final childAngle = angle + childOffset;
        final childX = branchX + math.cos(childAngle) * childRadius;
        final childY = branchY + math.sin(childAngle) * childRadius;
        final childId = 'leaf-${createId()}';

        nodes.add(
          MindMapCanvasNode(
            id: childId,
            label: child,
            shape: MindMapNodeShape.ellipse,
            colorHex: branchColor,
            x: childX - 100,
            y: childY - 42,
            width: _nodeWidth(child, min: 170, max: 220),
            height: 84,
          ),
        );
        connections.add(
          MindMapCanvasConnection(
            id: 'connection-${createId()}',
            sourceId: branchId,
            targetId: childId,
          ),
        );
      }
    }

    return MindMapDocument(nodes: nodes, connections: connections);
  }

  static double _nodeWidth(
    String label, {
    required double min,
    required double max,
  }) {
    final estimated = min + (label.length * 2.8);
    return estimated.clamp(min, max).toDouble();
  }

  static String _shortLabel(
    String text, {
    int maxWords = 6,
    int maxLength = 36,
  }) {
    final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.isEmpty) {
      return '';
    }
    final words = normalized.split(' ');
    final compact = words.take(maxWords).join(' ');
    return _truncate(compact, maxLength);
  }

  static String _truncate(String value, int maxLength) {
    if (value.length <= maxLength) {
      return value;
    }
    return '${value.substring(0, maxLength - 3).trim()}...';
  }

  static String? _sanitizeLabel(String? raw, {String? fallback}) {
    final value = raw?.replaceAll(RegExp(r'\s+'), ' ').trim() ?? '';
    if (value.isEmpty) {
      return fallback;
    }
    return value;
  }

  static String _normalizeKey(String value) {
    return value
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('ä', 'a')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ë', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ì', 'i')
        .replaceAll('î', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ö', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

class _ParsedNote {
  const _ParsedNote({
    required this.sections,
    required this.factPairs,
  });

  final List<_NoteSection> sections;
  final List<_NoteFactPair> factPairs;
}

class _NoteSection {
  const _NoteSection({
    required this.title,
    required this.points,
    required this.factPairs,
  });

  final String title;
  final List<String> points;
  final List<_NoteFactPair> factPairs;
}

class _MutableSection {
  _MutableSection({required this.title});

  final String title;
  final List<String> points = <String>[];
  final List<_NoteFactPair> factPairs = <_NoteFactPair>[];
}

class _NoteFactPair {
  const _NoteFactPair({
    required this.term,
    required this.definition,
    required this.sectionTitle,
  });

  final String term;
  final String definition;
  final String sectionTitle;
}

class _MindMapBranch {
  const _MindMapBranch({
    required this.label,
    required this.children,
  });

  final String label;
  final List<String> children;
}

class _TaskSuggestion {
  const _TaskSuggestion({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}
