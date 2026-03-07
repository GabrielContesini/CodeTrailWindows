import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_env.dart';
import 'secure_supabase_storage.dart';

class SupabaseService {
  const SupabaseService._();

  static bool _initialized = false;
  static SupabaseClient? _client;

  static SupabaseClient? get client => _client;

  static bool get isReady => _initialized && _client != null;

  static Future<void> initialize() async {
    if (_initialized) return;

    if (!AppEnv.isSupabaseConfigured) {
      _initialized = true;
      return;
    }

    await Supabase.initialize(
      url: AppEnv.supabaseUrl,
      anonKey: AppEnv.supabaseAnonKey,
      authOptions: FlutterAuthClientOptions(
        localStorage: SecureSupabaseStorage(const FlutterSecureStorage()),
      ),
    );

    _client = Supabase.instance.client;
    _initialized = true;
  }
}
