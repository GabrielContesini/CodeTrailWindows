import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../shared/models/app_view_models.dart';

class SessionTemplateService {
  const SessionTemplateService(this._storage);

  final FlutterSecureStorage _storage;

  static const _templatesKey = 'study.session_templates';

  Future<List<StudySessionTemplate>> loadTemplates() async {
    final raw = await _storage.read(key: _templatesKey);
    if (raw == null || raw.trim().isEmpty) {
      return StudySessionTemplate.defaults();
    }

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final templates = decoded
          .whereType<Map<String, dynamic>>()
          .map(StudySessionTemplate.fromJson)
          .toList();
      return templates.isEmpty ? StudySessionTemplate.defaults() : templates;
    } catch (_) {
      return StudySessionTemplate.defaults();
    }
  }

  Future<void> saveTemplates(List<StudySessionTemplate> templates) {
    final payload = jsonEncode(
      templates.map((item) => item.toJson()).toList(),
    );
    return _storage.write(key: _templatesKey, value: payload);
  }

  Future<void> resetTemplates() {
    return _storage.delete(key: _templatesKey);
  }
}
