import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionPreferencesService {
  const SessionPreferencesService(this._storage);

  final FlutterSecureStorage _storage;

  static const _rememberMeKey = 'session.remember_me';
  static const _lastEmailKey = 'session.last_email';

  Future<bool?> getRememberMe() async {
    final value = await _storage.read(key: _rememberMeKey);
    if (value == null) {
      return null;
    }
    return value == 'true';
  }

  Future<String?> getLastEmail() {
    return _storage.read(key: _lastEmailKey);
  }

  Future<void> saveLoginPreferences({
    required bool rememberMe,
    required String email,
  }) async {
    await _storage.write(key: _rememberMeKey, value: '$rememberMe');
    if (rememberMe) {
      await _storage.write(key: _lastEmailKey, value: email);
      return;
    }

    await _storage.delete(key: _lastEmailKey);
  }
}
