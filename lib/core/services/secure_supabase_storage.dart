import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SecureSupabaseStorage extends LocalStorage {
  SecureSupabaseStorage(this._storage);

  static const _key = 'code_trail.supabase.session';
  final FlutterSecureStorage _storage;

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> accessToken() async {
    final session = await _storage.read(key: _key);
    if (session == null) return null;

    final payload = jsonDecode(session) as Map<String, dynamic>;
    return payload['access_token'] as String?;
  }

  @override
  Future<bool> hasAccessToken() async {
    final token = await accessToken();
    return token?.isNotEmpty ?? false;
  }

  @override
  Future<void> persistSession(String persistSessionString) {
    return _storage.write(key: _key, value: persistSessionString);
  }

  @override
  Future<void> removePersistedSession() {
    return _storage.delete(key: _key);
  }
}
