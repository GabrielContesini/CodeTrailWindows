import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_env.dart';
import '../errors/app_exception.dart';
import 'secure_supabase_storage.dart';

class SupabaseService {
  const SupabaseService._();

  static bool _initialized = false;
  static SupabaseClient? _client;
  static StreamSubscription<AuthState>? _authStateSubscription;

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
    _syncFunctionAuth(_client!);
    _authStateSubscription?.cancel();
    _authStateSubscription = _client!.auth.onAuthStateChange.listen((data) {
      _syncFunctionAuth(_client!, session: data.session);
    });
    _initialized = true;
  }

  static Future<String> requireAccessToken() async {
    final client = _client;
    if (client == null) {
      throw const AppException(
        'Supabase não configurado. Defina SUPABASE_URL e SUPABASE_ANON_KEY.',
      );
    }

    var session = client.auth.currentSession;
    if (session == null) {
      _syncFunctionAuth(client);
      throw const AppException(
        'Sua sessão não está disponível. Entre novamente para acessar a cobrança.',
        code: 'billing_missing_session',
      );
    }

    if (session.isExpired) {
      try {
        final refreshed = await client.auth.refreshSession();
        session = refreshed.session ?? client.auth.currentSession;
      } on AuthException {
        _syncFunctionAuth(client);
        throw const AppException(
          'Sua sessão expirou. Faça login novamente para continuar.',
          code: 'billing_expired_session',
        );
      }
    }

    final accessToken = session?.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      _syncFunctionAuth(client, session: session);
      throw const AppException(
        'Não foi possível validar sua sessão. Entre novamente e tente de novo.',
        code: 'billing_invalid_session',
      );
    }

    client.functions.setAuth(accessToken);
    return accessToken;
  }

  static void _syncFunctionAuth(SupabaseClient client, {Session? session}) {
    final accessToken =
        session?.accessToken ?? client.auth.currentSession?.accessToken;
    client.functions.setAuth(accessToken ?? AppEnv.supabaseAnonKey);
  }
}
