import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/service_providers.dart';
import '../../../domain/repositories/auth_repository.dart';

final authSessionProvider = StreamProvider<Session?>((ref) {
  return ref.watch(authRepositoryProvider).sessionChanges();
});

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authSessionProvider).asData?.value?.user.id ??
      ref.read(authRepositoryProvider).currentSession?.user.id;
});

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password)
          .then(
            (_) => ref
                .read(sessionPreferencesProvider)
                .saveLoginPreferences(rememberMe: rememberMe, email: email)
                .then((_) => ref.invalidate(authSessionProvider)),
          );
    });
    return !state.hasError;
  }

  Future<SignUpResult?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = const AsyncLoading();
    try {
      final result = await ref
          .read(authRepositoryProvider)
          .signUp(email: email, password: password, fullName: fullName);
      ref.invalidate(authSessionProvider);
      state = const AsyncData(null);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return null;
    }
  }

  Future<bool> resetPassword(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).resetPassword(email),
    );
    return !state.hasError;
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    ref.invalidate(authSessionProvider);
  }
}
