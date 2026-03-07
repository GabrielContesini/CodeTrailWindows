import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/layout_utils.dart';
import '../../../domain/entities/app_entities.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/models/page_tutorial.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/async_value_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/page_frame.dart';
import '../../auth/application/auth_controller.dart';
import '../application/notes_controller.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  String _selectedFolder = 'Todas';
  String? _selectedNoteId;

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesProvider);

    return PageFrame(
      title: 'Notas',
      subtitle:
          'Anotações internas do CodeTrail organizadas por pasta, prontas para consulta durante os estudos.',
      tutorial: const PageTutorialData(
        id: 'notes',
        title: 'Como usar notas',
        description:
            'Use esta área para centralizar resumos, snippets, comandos e checkpoints de estudo.',
        steps: [
          'Crie pastas por assunto, stack ou projeto.',
          'Mantenha uma nota por conceito importante ou bloqueio real.',
          'Revise as notas junto das sessões e revisões para consolidar a base.',
        ],
      ),
      actions: [
        FilledButton.icon(
          onPressed: () => _showNoteDialog(context, ref),
          icon: const Icon(Icons.note_add_outlined),
          label: const Text('Nova nota'),
        ),
      ],
      child: AsyncValueView(
        value: notesAsync,
        data: (notes) {
          final folders = <String>{'Geral', ...notes.map((n) => n.folderName)}
            ..removeWhere((item) => item.trim().isEmpty);
          final sortedFolders = folders.toList()..sort();
          final folderList = ['Todas', ...sortedFolders];
          final filteredNotes = _selectedFolder == 'Todas'
              ? notes
              : notes.where((note) => note.folderName == _selectedFolder).toList();

          if (!folderList.contains(_selectedFolder)) {
            _selectedFolder = 'Todas';
          }

          if (notes.isEmpty) {
            return EmptyState(
              title: 'Nenhuma nota criada ainda',
              subtitle:
                  'Crie sua primeira nota para guardar resumos, comandos e checkpoints da trilha.',
              action: FilledButton.icon(
                onPressed: () => _showNoteDialog(context, ref),
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
                  initialFolder: _selectedFolder == 'Todas'
                      ? 'Geral'
                      : _selectedFolder,
                ),
              );

              final detailPane = _NotesDetailPane(
                note: selectedNote,
                onEdit: selectedNote == null
                    ? null
                    : () => _showNoteDialog(context, ref, note: selectedNote),
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
                    SizedBox(height: 290, child: listPane),
                    const SizedBox(height: 12),
                    Expanded(child: detailPane),
                  ],
                );
              }

              return Row(
                children: [
                  SizedBox(width: 360, child: listPane),
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
    required this.onSelectFolder,
    required this.onSelectNote,
    required this.onCreateNote,
  });

  final List<String> folders;
  final String selectedFolder;
  final List<StudyNoteEntity> notes;
  final String? selectedNoteId;
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
                  'Pastas e notas',
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
                    child: Text('Nenhuma nota nesta pasta.'),
                  )
                : ListView.separated(
                    itemCount: notes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final note = notes[index];
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
                                note.content,
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
    required this.onEdit,
    required this.onDelete,
  });

  final StudyNoteEntity? note;
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
              FilledButton.tonalIcon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar'),
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
                  note!.content,
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

Future<void> _showNoteDialog(
  BuildContext context,
  WidgetRef ref, {
  StudyNoteEntity? note,
  String initialFolder = 'Geral',
}) async {
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) return;

  final folderController = TextEditingController(
    text: note?.folderName ?? initialFolder,
  );
  final titleController = TextEditingController(text: note?.title ?? '');
  final contentController = TextEditingController(text: note?.content ?? '');
  final uuid = const Uuid();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final dialogWidth = responsiveDialogWidth(
        dialogContext,
        ideal: 620,
        min: 340,
      );
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

              final now = DateTime.now().toUtc();
              await ref.read(noteActionsProvider).save(
                    StudyNoteEntity(
                      id: note?.id ?? uuid.v4(),
                      userId: userId,
                      folderName: folder,
                      title: title,
                      content: content,
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
}

String _formatDateTime(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/${local.year} • $hour:$minute';
}
