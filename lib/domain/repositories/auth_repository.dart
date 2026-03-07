import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpResult {
  const SignUpResult({
    required this.requiresEmailConfirmation,
    required this.hasActiveSession,
  });

  final bool requiresEmailConfirmation;
  final bool hasActiveSession;
}

abstract class AuthRepository {
  Session? get currentSession;

  Stream<Session?> sessionChanges();
  Future<bool> restoreSessionOrSignOut();
  Future<void> signIn({required String email, required String password});
  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String fullName,
  });
  Future<void> resetPassword(String email);
  Future<void> signOut();
}
