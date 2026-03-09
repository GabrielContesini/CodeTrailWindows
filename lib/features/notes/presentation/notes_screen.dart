import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/layout_utils.dart';
import '../../../core/utils/note_context_codec.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/models/app_view_models.dart';
import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../auth/application/auth_controller.dart';
import '../../projects/application/projects_controller.dart';
import '../../tracks/application/tracks_controller.dart';
import '../application/notes_controller.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  String _selectedFolder = 'Todas';
  String? _selectedNoteId;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesProvider);
    final trackBlueprints =
        ref.watch(trackBlueprintsProvider).asData?.value ?? const <TrackBlueprint>[];
    final projectBundles =
        ref.watch(projectsProvider).asData?.value ?? const <ProjectBundle>[];

    return PageFrame(
      title: 'Notas',
      subtitle:
          'Capture resumos, snippets, checklists e decisões sem perder o contexto da trilha.',
      tutorial: const PageTutorialData(
        id: 'notes',
        title: 'Como usar notas',
        description:
            'Use esta área para centralizar resumos, snippets, comandos e checkpoints de estudo.',
        steps: [
          'Crie pastas por assunto, stack ou projeto.',
          'Use templates para abrir notas mais rápido durante a sessão.',
          'Revise as notas junto das sessões e revisões para consolidar a base.',
        ],
      ),
      actions: [
        FilledButton.icon(
          onPressed: () => _showNoteDialog(
            context,
            ref,
            trackBlueprints: trackBlueprints,
            projectBundles: projectBundles,
          ),
          icon: const Icon(Icons.note_add_outlined),
          label: const Text('Nova nota'),
        ),
        PopupMenuButton<_NoteTemplate>(
          onSelected: (template) => _showNoteDialog(
            context,
            ref,
            trackBlueprints: trackBlueprints,
            projectBundles: projectBundles,
            initialFolder: _selectedFolder == 'Todas' ? 'Geral' : _selectedFolder,
            initialTitle: template.defaultTitle,
            initialContent: template.templateContent,
          ),
          itemBuilder: (context) => _NoteTemplate.values
              .map(
                (template) => PopupMenuItem<_NoteTemplate>(
                  value: template,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(template.label),
                      Text(
                        template.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.auto_awesome_outlined, size: 18),
                SizedBox(width: 8),
                Text('Templates'),
              ],
            ),
          ),
        ),
      ],
      child: AsyncValueView(
        value: notesAsync,
        data: (notes) {
          final noteDocuments = <String, NoteContentDocument>{
            for (final note in notes) note.id: NoteContextCodec.decode(note.content),
          };
          final folders = <String>{'Geral', ...notes.map((n) => n.folderName)}
            ..removeWhere((item) => item.trim().isEmpty);
          final sortedFolders = folders.toList()..sort();
          final folderList = ['Todas', ...sortedFolders];
          final normalizedQuery = _searchQuery.trim().toLowerCase();
          final folderFiltered = _selectedFolder == 'Todas'
              ? notes
              : notes.where((note) => note.folderName == _selectedFolder).toList();
          final filteredNotes = normalizedQuery.isEmpty
              ? folderFiltered
              : folderFiltered.where((note) {
                  final document = noteDocuments[note.id] ??
                      NoteContextCodec.decode(note.content);
                  final haystack =
                      '${note.title} ${document.searchableText} ${note.folderName}'
                          .toLowerCase();
                  return haystack.contains(normalizedQuery);
                }).toList();
          final recentNotesCount = notes
              .where(
                (note) =>
                    note.updatedAt.isAfter(
                      DateTime.now().toUtc().subtract(const Duration(days: 7)),
                    ),
              )
              .length;

          if (!folderList.contains(_selectedFolder)) {
            _selectedFolder = 'Todas';
          }

          if (notes.isEmpty) {
            return EmptyState(
              title: 'Nenhuma nota criada ainda',
              subtitle:
                  'Crie sua primeira nota para guardar resumos, comandos e checkpoints da trilha.',
              action: FilledButton.icon(
                onPressed: () => _showNoteDialog(
                  context,
                  ref,
                  trackBlueprints: trackBlueprints,
                  projectBundles: projectBundles,
                ),
                icon: const Icon(Icons.note_add_outlined),
                label: const Text('Criar nota'),
              ),
            );
          }

          _selectedNoteId ??= filteredNotes.isNotEmpty ? filteredNotes.first.id : null;
          if (filteredNotes.every((note) => note.id != _selectedNoteId)) {
            _selectedNoteId = filteredNotes.isNotEmpty ? filteredNotes.first.id : null;
          }

          StudyNoteEntity? selectedNote;
          for (final note in filteredNotes) {
            if (note.id == _selectedNoteId) {
              selectedNote = note;
              break;
            }
          }
          selectedNote ??= filteredNotes.isNotEmpty ? filteredNotes.first : null;

          return LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1260;

              final listPane = _NotesListPane(
                folders: folderList,
                selectedFolder: _selectedFolder,
                notes: filteredNotes,
                selectedNoteId: _selectedNoteId,
                searchQuery: _searchQuery,
                totalNotes: notes.length,
                folderCount: sortedFolders.length,
                recentNotesCount: recentNotesCount,
                noteDocuments: noteDocuments,
                onSearchChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _selectedNoteId = null;
                  });
                },
                onSelectFolder: (folder) {
                  setState(() {
                    _selectedFolder = folder;
                    _selectedNoteId = null;
                  });
                },
                onSelectNote: (noteId) {
                  setState(() => _selectedNoteId = noteId);
                },
                onCreateNote: () => _showNoteDialog(
                  context,
                  ref,
                  trackBlueprints: trackBlueprints,
                  projectBundles: projectBundles,
                  initialFolder: _selectedFolder == 'Todas'
                      ? 'Geral'
                      : _selectedFolder,
                ),
              );

              final detailPane = _NotesDetailPane(
                note: selectedNote,
                noteDocument: selectedNote == null
                    ? null
                    : noteDocuments[selectedNote.id] ??
                        NoteContextCodec.decode(selectedNote.content),
                onEdit: selectedNote == null
                    ? null
                    : () => _showNoteDialog(
                          context,
                          ref,
                          note: selectedNote,
                          trackBlueprints: trackBlueprints,
                          projectBundles: projectBundles,
                        ),
                onDelete: selectedNote == null
                    ? null
                    : () async {
                        await ref
                            .read(noteActionsProvider)
                            .delete(selectedNote!.id);
                        if (!context.mounted) return;
                        context.showAppSnackBar('Nota removida.');
                        setState(() => _selectedNoteId = null);
                      },
              );

              if (!wide) {
                return Column(
                  children: [
                    SizedBox(height: 360, child: listPane),
                    const SizedBox(height: 12),
                    Expanded(child: detailPane),
                  ],
                );
              }

              return Row(
                children: [
                  SizedBox(width: 390, child: listPane),
                  const SizedBox(width: 14),
                  Expanded(child: detailPane),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _NotesListPane extends StatelessWidget {
  const _NotesListPane({
    required this.folders,
    required this.selectedFolder,
    required this.notes,
    required this.selectedNoteId,
    required this.searchQuery,
    required this.totalNotes,
    required this.folderCount,
    required this.recentNotesCount,
    required this.noteDocuments,
    required this.onSearchChanged,
    required this.onSelectFolder,
    required this.onSelectNote,
    required this.onCreateNote,
  });

  final List<String> folders;
  final String selectedFolder;
  final List<StudyNoteEntity> notes;
  final String? selectedNoteId;
  final String searchQuery;
  final int totalNotes;
  final int folderCount;
  final int recentNotesCount;
  final Map<String, NoteContentDocument> noteDocuments;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSelectFolder;
  final ValueChanged<String> onSelectNote;
  final VoidCallback onCreateNote;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Workspace de notas',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Nova nota',
                onPressed: onCreateNote,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatChip(label: 'Notas', value: '$totalNotes'),
              _StatChip(label: 'Pastas', value: '$folderCount'),
              _StatChip(label: '7 dias', value: '$recentNotesCount'),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              labelText: 'Buscar por título, pasta ou conteúdo',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: searchQuery.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => onSearchChanged(''),
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: folders.map((folder) {
                final selected = folder == selectedFolder;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(folder),
                    selected: selected,
                    onSelected: (_) => onSelectFolder(folder),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: notes.isEmpty
                ? const Center(
                    child: Text('Nenhuma nota encontrada com esse filtro.'),
                  )
                : ListView.separated(
                    itemCount: notes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final document = noteDocuments[note.id];
                      final selected = note.id == selectedNoteId;
                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => onSelectNote(note.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected
                                  ? context.colorScheme.primary.withValues(
                                      alpha: 0.24,
                                    )
                                  : context.colorScheme.outline,
                            ),
                            color: selected
                                ? context.colorScheme.primary.withValues(
                                    alpha: 0.10,
                                  )
                                : context.colorScheme.surface.withValues(
                                    alpha: 0.30,
                                  ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                note.folderName,
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (document != null && document.context.labels.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: document.context.labels
                                        .map((label) => _ContextPill(label: label))
                                        .toList(),
                                  ),
                                ),
                              const SizedBox(height: 6),
                              Text(
                                (document?.body ?? note.content),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotesDetailPane extends StatelessWidget {
  const _NotesDetailPane({
    required this.note,
    required this.noteDocument,
    required this.onEdit,
    required this.onDelete,
  });

  final StudyNoteEntity? note;
  final NoteContentDocument? noteDocument;
  final VoidCallback? onEdit;
  final Future<void> Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    if (note == null) {
      return const AppCard(
        child: Center(
          child: Text('Selecione uma nota para visualizar o conteúdo.'),
        ),
      );
    }

    final visibleContent = noteDocument?.body ?? note!.content;
    final contextLabels = noteDocument?.context.labels ?? const <String>[];
    final wordCount = _countWords(visibleContent);
    final readingMinutes = _estimateReadingMinutes(wordCount);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: context.colorScheme.primary.withValues(alpha: 0.10),
                ),
                child: Text(
                  note!.folderName,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _StatChip(label: 'Palavras', value: '$wordCount'),
              _StatChip(label: 'Leitura', value: '$readingMinutes min'),
              ...contextLabels.map((label) => _ContextPill(label: label)),
              FilledButton.tonalIcon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar'),
              ),
              FilledButton.tonalIcon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: visibleContent));
                  if (context.mounted) {
                    context.showAppSnackBar('Conteúdo copiado.');
                  }
                },
                icon: const Icon(Icons.content_copy_rounded),
                label: const Text('Copiar'),
              ),
              if (onDelete != null)
                IconButton(
                  tooltip: 'Excluir nota',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            note!.title,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Atualizada em ${_formatDateTime(note!.updatedAt)}',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.64),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: context.colorScheme.outline),
                color: context.colorScheme.surface.withValues(alpha: 0.24),
              ),
              child: SingleChildScrollView(
                child: Text(
                  visibleContent,
                  style: context.textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContextPill extends StatelessWidget {
  const _ContextPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: context.colorScheme.primary.withValues(alpha: 0.10),
      ),
      child: Text(
        label,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outline),
        color: context.colorScheme.surface.withValues(alpha: 0.20),
      ),
      child: Text(
        '$label: $value',
        style: context.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

Future<void> _showNoteDialog(
  BuildContext context,
  WidgetRef ref, {
  required List<TrackBlueprint> trackBlueprints,
  required List<ProjectBundle> projectBundles,
  StudyNoteEntity? note,
  String initialFolder = 'Geral',
  String? initialTitle,
  String? initialContent,
}) async {
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) return;
  final noteDocument = note == null
      ? NoteContentDocument(body: initialContent ?? '')
      : NoteContextCodec.decode(note.content);

  final folderController = TextEditingController(
    text: note?.folderName ?? initialFolder,
  );
  final titleController = TextEditingController(
    text: note?.title ?? initialTitle ?? '',
  );
  final contentController = TextEditingController(
    text: noteDocument.body,
  );
  final uuid = const Uuid();
  String? selectedTrackId = noteDocument.context.trackId;
  String? selectedModuleId = noteDocument.context.moduleId;
  String? selectedProjectId = noteDocument.context.projectId;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final dialogWidth = responsiveDialogWidth(
        dialogContext,
        ideal: 620,
        min: 340,
      );
      return StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final selectedTrack = _findTrackBlueprint(
            trackBlueprints,
            selectedTrackId,
          );
          final availableModules = selectedTrack?.modules ?? const <StudyModuleEntity>[];

          return AlertDialog(
            title: Text(note == null ? 'Nova nota' : 'Editar nota'),
            content: SizedBox(
              width: dialogWidth,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: folderController,
                      decoration: const InputDecoration(labelText: 'Pasta'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      initialValue: trackBlueprints.any(
                        (item) => item.track.id == selectedTrackId,
                      )
                          ? selectedTrackId
                          : null,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Vincular trilha',
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Sem trilha'),
                        ),
                        ...trackBlueprints.map(
                          (item) => DropdownMenuItem<String?>(
                            value: item.track.id,
                            child: Text(item.track.name),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedTrackId = value;
                          if (!availableModules.any((item) => item.id == selectedModuleId)) {
                            selectedModuleId = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      initialValue: availableModules.any(
                        (item) => item.id == selectedModuleId,
                      )
                          ? selectedModuleId
                          : null,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Vincular módulo',
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Sem módulo'),
                        ),
                        ...availableModules.map(
                          (item) => DropdownMenuItem<String?>(
                            value: item.id,
                            child: Text(item.title),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          setDialogState(() => selectedModuleId = value),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      initialValue: projectBundles.any(
                        (item) => item.project.id == selectedProjectId,
                      )
                          ? selectedProjectId
                          : null,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Vincular projeto',
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Sem projeto'),
                        ),
                        ...projectBundles.map(
                          (item) => DropdownMenuItem<String?>(
                            value: item.project.id,
                            child: Text(item.project.title),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          setDialogState(() => selectedProjectId = value),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentController,
                      minLines: 10,
                      maxLines: 14,
                      decoration: const InputDecoration(
                        labelText: 'Conteúdo',
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  final folder = folderController.text.trim().isEmpty
                      ? 'Geral'
                      : folderController.text.trim();
                  final title = titleController.text.trim();
                  final content = contentController.text.trim();
                  if (title.isEmpty || content.isEmpty) {
                    dialogContext.showAppSnackBar(
                      'Preencha título e conteúdo da nota.',
                    );
                    return;
                  }

                  final selectedModule = _findModule(
                    availableModules,
                    selectedModuleId,
                  );
                  final selectedProject = _findProject(
                    projectBundles,
                    selectedProjectId,
                  );
                  final encodedContent = NoteContextCodec.encode(
                    body: content,
                    context: NoteContextLink(
                      trackId: selectedTrack?.track.id,
                      trackLabel: selectedTrack?.track.name,
                      moduleId: selectedModule?.id,
                      moduleLabel: selectedModule?.title,
                      projectId: selectedProject?.project.id,
                      projectLabel: selectedProject?.project.title,
                    ),
                  );

                  final now = DateTime.now().toUtc();
                  await ref.read(noteActionsProvider).save(
                        StudyNoteEntity(
                          id: note?.id ?? uuid.v4(),
                          userId: userId,
                          folderName: folder,
                          title: title,
                          content: encodedContent,
                          createdAt: note?.createdAt ?? now,
                          updatedAt: now,
                        ),
                      );

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      );
    },
  );
}

int _countWords(String content) {
  return content
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .length;
}

int _estimateReadingMinutes(int wordCount) {
  if (wordCount == 0) return 0;
  return (wordCount / 180).ceil();
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/${local.year} • $hour:$minute';
}

TrackBlueprint? _findTrackBlueprint(
  List<TrackBlueprint> tracks,
  String? trackId,
) {
  if (trackId == null) return null;
  for (final item in tracks) {
    if (item.track.id == trackId) {
      return item;
    }
  }
  return null;
}

StudyModuleEntity? _findModule(
  List<StudyModuleEntity> modules,
  String? moduleId,
) {
  if (moduleId == null) return null;
  for (final item in modules) {
    if (item.id == moduleId) {
      return item;
    }
  }
  return null;
}

ProjectBundle? _findProject(
  List<ProjectBundle> projects,
  String? projectId,
) {
  if (projectId == null) return null;
  for (final item in projects) {
    if (item.project.id == projectId) {
      return item;
    }
  }
  return null;
}

enum _NoteTemplate {
  summary,
  checklist,
  snippet;

  String get label {
    switch (this) {
      case _NoteTemplate.summary:
        return 'Resumo';
      case _NoteTemplate.checklist:
        return 'Checklist';
      case _NoteTemplate.snippet:
        return 'Snippet';
    }
  }

  String get description {
    switch (this) {
      case _NoteTemplate.summary:
        return 'Resumo rápido de um conceito, aula ou módulo.';
      case _NoteTemplate.checklist:
        return 'Passos objetivos para fechar uma tarefa ou revisão.';
      case _NoteTemplate.snippet:
        return 'Comando, query, trecho de código ou referência prática.';
    }
  }

  String get defaultTitle {
    switch (this) {
      case _NoteTemplate.summary:
        return 'Resumo de estudo';
      case _NoteTemplate.checklist:
        return 'Checklist de execução';
      case _NoteTemplate.snippet:
        return 'Snippet útil';
    }
  }

  String get templateContent {
    switch (this) {
      case _NoteTemplate.summary:
        return 'Contexto:\n\nPontos-chave:\n- \n- \n- \n\nO que revisar depois:\n- ';
      case _NoteTemplate.checklist:
        return 'Objetivo:\n\nChecklist:\n- [ ]\n- [ ]\n- [ ]\n\nBloqueios:\n- ';
      case _NoteTemplate.snippet:
        return 'Uso:\n\nCódigo / comando:\n\n```txt\n\n```\n\nObservações:\n- ';
    }
  }
}
