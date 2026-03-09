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
      title: 'Cadernos',
      subtitle:
          'Organize pastas, páginas e resumos no estilo notebook sem perder o contexto da trilha.',
      tutorial: const PageTutorialData(
        id: 'notes',
        title: 'Como usar cadernos',
        description:
            'Use esta área para montar cadernos por tema, projeto ou revisão, como uma central de anotações do seu estudo.',
        steps: [
          'Crie uma pasta para cada stack, sprint, projeto ou disciplina.',
          'Abra novas páginas com templates para registrar teoria, prática e checkpoints.',
          'Use o caderno como arquivo vivo para revisar e evoluir junto das sessões.',
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
                  'Crie seu primeiro caderno para guardar resumos, comandos e checkpoints da trilha.',
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
              final wide = constraints.maxWidth >= 1380;
              final medium = constraints.maxWidth >= 1040;

              final shelfPane = _FolderShelfPane(
                folders: folderList,
                selectedFolder: _selectedFolder,
                allNotes: notes,
                totalNotes: notes.length,
                recentNotesCount: recentNotesCount,
                onSelectFolder: (folder) {
                  setState(() {
                    _selectedFolder = folder;
                    _selectedNoteId = null;
                  });
                },
              );

              final listPane = _NotesListPane(
                folders: folderList,
                selectedFolder: _selectedFolder,
                allNotes: notes,
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
                if (medium) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 360,
                        child: Column(
                          children: [
                            SizedBox(height: 250, child: shelfPane),
                            const SizedBox(height: 12),
                            Expanded(child: listPane),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: detailPane),
                    ],
                  );
                }

                return Column(
                  children: [
                    SizedBox(height: 218, child: shelfPane),
                    const SizedBox(height: 12),
                    SizedBox(height: 348, child: listPane),
                    const SizedBox(height: 12),
                    Expanded(child: detailPane),
                  ],
                );
              }

              return Row(
                children: [
                  SizedBox(width: 300, child: shelfPane),
                  const SizedBox(width: 14),
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
    required this.allNotes,
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
  final List<StudyNoteEntity> allNotes;
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
    final visibleFolders = folders.where((folder) => folder != 'Todas').toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estante de páginas',
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Abra cadernos por pasta e encontre a página certa sem misturar tudo.',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: onCreateNote,
                icon: const Icon(Icons.note_add_outlined),
                label: const Text('Nova página'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatChip(label: 'Páginas', value: '$totalNotes'),
              _StatChip(label: 'Cadernos', value: '$folderCount'),
              _StatChip(label: '7 dias', value: '$recentNotesCount'),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              labelText: 'Buscar por título, contexto ou conteúdo',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: searchQuery.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => onSearchChanged(''),
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 116,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: visibleFolders.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _NotebookShelfCard(
                    title: 'Todas',
                    subtitle: 'Estante completa',
                    noteCount: totalNotes,
                    recentCount: recentNotesCount,
                    selected: selectedFolder == 'Todas',
                    accentColor: context.colorScheme.primary,
                    onTap: () => onSelectFolder('Todas'),
                  );
                }

                final folder = visibleFolders[index - 1];
                final folderNotes = allNotes.where((note) => note.folderName == folder).toList();
                folderNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
                final recentCount = folderNotes
                    .where(
                      (note) => note.updatedAt.isAfter(
                        DateTime.now().toUtc().subtract(const Duration(days: 7)),
                      ),
                    )
                    .length;
                return _NotebookShelfCard(
                  title: folder,
                  subtitle: folderNotes.isEmpty
                      ? 'Sem páginas'
                      : 'Última em ${_formatShortDate(folderNotes.first.updatedAt)}',
                  noteCount: folderNotes.length,
                  recentCount: recentCount,
                  selected: selectedFolder == folder,
                  accentColor: _folderAccent(index - 1, context.colorScheme),
                  onTap: () => onSelectFolder(folder),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  selectedFolder == 'Todas'
                      ? 'Páginas do workspace'
                      : 'Páginas de $selectedFolder',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${notes.length} página(s)',
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.68),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: notes.isEmpty
                ? const Center(
                    child: Text('Nenhuma página encontrada nesse filtro.'),
                  )
                : ListView.separated(
                    itemCount: notes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final document = noteDocuments[note.id];
                      return _NotebookNoteCard(
                        note: note,
                        document: document,
                        selected: note.id == selectedNoteId,
                        accentColor: _folderAccent(index, context.colorScheme),
                        onTap: () => onSelectNote(note.id),
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
      return AppCard(
        child: Center(
          child: Text(
            'Selecione uma página para abrir o caderno.',
            style: context.textTheme.titleMedium,
          ),
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
              _StatChip(label: 'Caderno', value: note!.folderName),
              _StatChip(label: 'Palavras', value: '$wordCount'),
              _StatChip(label: 'Leitura', value: '$readingMinutes min'),
              ...contextLabels.map((label) => _ContextPill(label: label)),
              FilledButton.tonalIcon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar página'),
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
          Expanded(
            child: _NotebookPaper(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(82, 34, 34, 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note!.title,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF18212F),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Atualizada em ${_formatDateTime(note!.updatedAt)}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF506176),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SelectableText(
                      visibleContent,
                      style: context.textTheme.bodyLarge?.copyWith(
                        height: 1.72,
                        color: const Color(0xFF18212F),
                      ),
                    ),
                  ],
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

class _FolderShelfPane extends StatelessWidget {
  const _FolderShelfPane({
    required this.folders,
    required this.selectedFolder,
    required this.allNotes,
    required this.totalNotes,
    required this.recentNotesCount,
    required this.onSelectFolder,
  });

  final List<String> folders;
  final String selectedFolder;
  final List<StudyNoteEntity> allNotes;
  final int totalNotes;
  final int recentNotesCount;
  final ValueChanged<String> onSelectFolder;

  @override
  Widget build(BuildContext context) {
    final visibleFolders = folders.where((folder) => folder != 'Todas').toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pastas do caderno',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Cada pasta funciona como uma lombada principal para teoria, prática e revisões.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              itemCount: visibleFolders.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _NotebookShelfCard(
                    title: 'Todas',
                    subtitle: 'Visão completa das páginas',
                    noteCount: totalNotes,
                    recentCount: recentNotesCount,
                    selected: selectedFolder == 'Todas',
                    accentColor: context.colorScheme.primary,
                    onTap: () => onSelectFolder('Todas'),
                  );
                }

                final folder = visibleFolders[index - 1];
                final folderNotes = allNotes.where((note) => note.folderName == folder).toList();
                folderNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
                final recentCount = folderNotes
                    .where(
                      (note) => note.updatedAt.isAfter(
                        DateTime.now().toUtc().subtract(const Duration(days: 7)),
                      ),
                    )
                    .length;
                return _NotebookShelfCard(
                  title: folder,
                  subtitle: folderNotes.isEmpty
                      ? 'Sem páginas ainda'
                      : 'Última em ${_formatShortDate(folderNotes.first.updatedAt)}',
                  noteCount: folderNotes.length,
                  recentCount: recentCount,
                  selected: selectedFolder == folder,
                  accentColor: _folderAccent(index - 1, context.colorScheme),
                  onTap: () => onSelectFolder(folder),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotebookShelfCard extends StatelessWidget {
  const _NotebookShelfCard({
    required this.title,
    required this.subtitle,
    required this.noteCount,
    required this.recentCount,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final int noteCount;
  final int recentCount;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? accentColor.withValues(alpha: 0.64)
                : context.colorScheme.outline,
          ),
          gradient: LinearGradient(
            colors: [
              accentColor.withValues(alpha: selected ? 0.24 : 0.16),
              context.colorScheme.surface.withValues(alpha: 0.18),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: accentColor.withValues(alpha: 0.92),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatChip(label: 'Páginas', value: '$noteCount'),
                _StatChip(label: '7 dias', value: '$recentCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotebookNoteCard extends StatelessWidget {
  const _NotebookNoteCard({
    required this.note,
    required this.document,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });

  final StudyNoteEntity note;
  final NoteContentDocument? document;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labels = document?.context.labels ?? const <String>[];
    final previewText = (document?.body ?? note.content).trim();

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected
                ? accentColor.withValues(alpha: 0.60)
                : context.colorScheme.outline,
          ),
          color: selected
              ? accentColor.withValues(alpha: 0.14)
              : context.colorScheme.surface.withValues(alpha: 0.20),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: accentColor.withValues(alpha: 0.78),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
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
                    '${note.folderName} • ${_formatShortDate(note.updatedAt)}',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (labels.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: labels.take(3).map((label) => _ContextPill(label: label)).toList(),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Text(
                    previewText.isEmpty ? 'Página vazia.' : previewText,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotebookPaper extends StatelessWidget {
  const _NotebookPaper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFD5DDE9)),
        color: const Color(0xFFF8FBFF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _NotebookPaperPainter()),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _NotebookPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final marginPaint = Paint()
      ..color = const Color(0xFFFFD4D4)
      ..strokeWidth = 1.4;
    final linePaint = Paint()
      ..color = const Color(0xFFE1E9F2)
      ..strokeWidth = 1;

    canvas.drawLine(const Offset(58, 0), Offset(58, size.height), marginPaint);

    const step = 34.0;
    for (double y = 42; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Color _folderAccent(int index, ColorScheme colorScheme) {
  const palette = <Color>[
    Color(0xFF6D9CFF),
    Color(0xFF7CFFB2),
    Color(0xFFFFD166),
    Color(0xFFFF9C73),
    Color(0xFFC5A3FF),
    Color(0xFF7FE7FF),
  ];
  return palette[index % palette.length];
}

String _formatShortDate(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day/$month';
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
            title: Text(note == null ? 'Nova página do caderno' : 'Editar página'),
            content: SizedBox(
              width: dialogWidth,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: folderController,
                      decoration: const InputDecoration(labelText: 'Caderno / pasta'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Título da página'),
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
                        labelText: 'Relacionar trilha',
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
                        labelText: 'Relacionar módulo',
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
                        labelText: 'Relacionar projeto',
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
                        labelText: 'Página',
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
                      'Preencha o título e o conteúdo da página.',
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
