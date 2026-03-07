import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import '../../core/services/supabase_service.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();

  SupabaseClient get _client {
    final client = SupabaseService.client;
    if (client == null) {
      throw const AppException(
        'Supabase não configurado. Defina as chaves para autenticação.',
      );
    }
    return client;
  }

  @override
  Session? get currentSession => SupabaseService.client?.auth.currentSession;

  @override
  Stream<Session?> sessionChanges() {
    final client = SupabaseService.client;
    if (client == null) return Stream.value(null);

    return client.auth.onAuthStateChange
        .map((event) => event.session)
        .startWith(client.auth.currentSession);
  }

  @override
  Future<bool> restoreSessionOrSignOut() async {
    final client = SupabaseService.client;
    final session = client?.auth.currentSession;
    if (client == null || session == null) {
      return false;
    }

    try {
      if (session.isExpired) {
        await client.auth.refreshSession();
      } else {
        await client.auth.getUser(session.accessToken);
      }
      return client.auth.currentSession != null;
    } on AuthException {
      await client.auth.signOut();
      return false;
    } catch (_) {
      return client.auth.currentSession != null;
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (error) {
      final message = error.message.toLowerCase();
      if (message.contains('confirm') || message.contains('verified')) {
        throw const AppException(
          'Confirme seu e-mail antes de entrar. Verifique sua caixa de entrada.',
        );
      }

      throw AppException(error.message);
    }
  }

  @override
  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      return SignUpResult(
        requiresEmailConfirmation:
            response.user != null && response.session == null,
        hasActiveSession: response.session != null,
      );
    } on AuthException catch (error) {
      throw AppException(error.message);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (error) {
      throw AppException(error.message);
    }
  }

  @override
  Future<void> signOut() async {
    final client = SupabaseService.client;
    if (client == null) {
      return;
    }

    try {
      await client.auth.signOut();
    } on AuthException {
      // Startup should recover to login even if the persisted session is stale.
    }
  }
}
