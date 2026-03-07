import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/entities/app_entities.dart';
import '../../auth/application/auth_controller.dart';

final notesProvider = StreamProvider<List<StudyNoteEntity>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const <StudyNoteEntity>[]);
  return ref.watch(studyRepositoryProvider).watchNotes(userId);
});

final noteActionsProvider = Provider<NoteActions>((ref) {
  return NoteActions(ref);
});

class NoteActions {
  const NoteActions(this._ref);

  final Ref _ref;

  Future<void> save(StudyNoteEntity note) {
    return _ref.read(studyRepositoryProvider).saveNote(note);
  }

  Future<void> delete(String noteId) {
    return _ref.read(studyRepositoryProvider).deleteNote(noteId);
  }
}
