import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import '../../core/services/supabase_service.dart';
import 'app_models.dart';

class SupabaseRemoteDataSource {
  const SupabaseRemoteDataSource();

  SupabaseClient get _client {
    final client = SupabaseService.client;
    if (client == null) {
      throw const AppException(
        'Supabase não configurado. Defina SUPABASE_URL e SUPABASE_ANON_KEY.',
      );
    }
    return client;
  }

  Future<void> upsertRow(String table, Map<String, dynamic> payload) async {
    await _client.from(table).upsert(payload, onConflict: 'id');
  }

  Future<void> deleteRow(String table, String id) async {
    await _client.from(table).delete().eq('id', id);
  }

  bool isMissingTableError(Object error, {String? table}) {
    final normalizedTable = table?.toLowerCase();

    bool matchesMessage(String message) {
      final normalizedMessage = message.toLowerCase();
      final looksLikeMissingTable =
          normalizedMessage.contains('pgrst205') ||
          normalizedMessage.contains('could not find the table') ||
          normalizedMessage.contains('schema cache');

      if (!looksLikeMissingTable) {
        return false;
      }

      if (normalizedTable == null || normalizedTable.isEmpty) {
        return true;
      }

      return normalizedMessage.contains("'public.$normalizedTable'") ||
          normalizedMessage.contains('"public.$normalizedTable"') ||
          normalizedMessage.contains("'$normalizedTable'") ||
          normalizedMessage.contains('"$normalizedTable"') ||
          normalizedMessage.contains('public.$normalizedTable');
    }

    if (error is PostgrestException) {
      if (error.code == 'PGRST205' &&
          (normalizedTable == null || matchesMessage(error.message))) {
        return true;
      }

      if (matchesMessage(error.message)) {
        return true;
      }
    }

    return matchesMessage(error.toString());
  }

  Future<RemoteSyncBundle> fetchAll(String userId) async {
    final trackRows = await _client.from('study_tracks').select();
    final skillRows = await _client.from('study_skills').select();
    final moduleRows = await _client.from('study_modules').select();
    final profileRows = await _client
        .from('profiles')
        .select()
        .eq('id', userId);
    final goalRows = await _client
        .from('user_goals')
        .select()
        .eq('user_id', userId);
    final progressRows = await _client
        .from('user_skill_progress')
        .select()
        .eq('user_id', userId);
    final sessionRows = await _client
        .from('study_sessions')
        .select()
        .eq('user_id', userId);
    final taskRows = await _client.from('tasks').select().eq('user_id', userId);
    final reviewRows = await _client
        .from('reviews')
        .select()
        .eq('user_id', userId);
    final projectRows = await _client
        .from('projects')
        .select()
        .eq('user_id', userId);
    var flashcardsAvailable = true;
    List<dynamic> flashcardRows = <dynamic>[];
    try {
      flashcardRows = await _client
          .from('flashcards')
          .select()
          .eq('user_id', userId);
    } catch (error) {
      if (isMissingTableError(error, table: 'flashcards')) {
        flashcardsAvailable = false;
        flashcardRows = <dynamic>[];
      } else {
        rethrow;
      }
    }
    var mindMapsAvailable = true;
    List<dynamic> mindMapRows = <dynamic>[];
    try {
      mindMapRows = await _client
          .from('mind_maps')
          .select()
          .eq('user_id', userId);
    } catch (error) {
      if (isMissingTableError(error, table: 'mind_maps')) {
        mindMapsAvailable = false;
        mindMapRows = <dynamic>[];
      } else {
        rethrow;
      }
    }
    var notesAvailable = true;
    List<dynamic> noteRows = <dynamic>[];
    try {
      noteRows = await _client
          .from('study_notes')
          .select()
          .eq('user_id', userId);
    } catch (error) {
      if (isMissingTableError(error, table: 'study_notes')) {
        notesAvailable = false;
        noteRows = <dynamic>[];
      } else {
        rethrow;
      }
    }
    final settingRows = await _client
        .from('app_settings')
        .select()
        .eq('user_id', userId)
        .order('updated_at', ascending: false)
        .limit(1);

    final projectIds = projectRows
        .cast<Map<String, dynamic>>()
        .map((item) => item['id'] as String)
        .toList();

    final stepRows = <dynamic>[];
    for (final projectId in projectIds) {
      final response = await _client
          .from('project_steps')
          .select()
          .eq('project_id', projectId);
      stepRows.addAll(response);
    }

    return RemoteSyncBundle(
      profiles: profileRows
          .cast<Map<String, dynamic>>()
          .map(ProfileModel.fromJson)
          .toList(),
      goals: goalRows
          .cast<Map<String, dynamic>>()
          .map(UserGoalModel.fromJson)
          .toList(),
      tracks: trackRows
          .cast<Map<String, dynamic>>()
          .map(StudyTrackModel.fromJson)
          .toList(),
      skills: skillRows
          .cast<Map<String, dynamic>>()
          .map(StudySkillModel.fromJson)
          .toList(),
      progress: progressRows
          .cast<Map<String, dynamic>>()
          .map(UserSkillProgressModel.fromJson)
          .toList(),
      modules: moduleRows
          .cast<Map<String, dynamic>>()
          .map(StudyModuleModel.fromJson)
          .toList(),
      sessions: sessionRows
          .cast<Map<String, dynamic>>()
          .map(StudySessionModel.fromJson)
          .toList(),
      tasks: taskRows
          .cast<Map<String, dynamic>>()
          .map(TaskModel.fromJson)
          .toList(),
      reviews: reviewRows
          .cast<Map<String, dynamic>>()
          .map(ReviewModel.fromJson)
          .toList(),
      projects: projectRows
          .cast<Map<String, dynamic>>()
          .map(ProjectModel.fromJson)
          .toList(),
      projectSteps: stepRows
          .cast<Map<String, dynamic>>()
          .map(ProjectStepModel.fromJson)
          .toList(),
      notes: noteRows
          .cast<Map<String, dynamic>>()
          .map(StudyNoteModel.fromJson)
          .toList(),
      flashcards: flashcardRows
          .cast<Map<String, dynamic>>()
          .map(FlashcardModel.fromJson)
          .toList(),
      mindMaps: mindMapRows
          .cast<Map<String, dynamic>>()
          .map(MindMapModel.fromJson)
          .toList(),
      settings: settingRows
          .cast<Map<String, dynamic>>()
          .map(AppSettingsModel.fromJson)
          .toList(),
      notesAvailable: notesAvailable,
      flashcardsAvailable: flashcardsAvailable,
      mindMapsAvailable: mindMapsAvailable,
    );
  }
}
