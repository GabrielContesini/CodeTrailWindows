import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/service_providers.dart';
import '../../../shared/models/app_view_models.dart';

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, void>(OnboardingController.new);

class OnboardingController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> submit(OnboardingInput input) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(studyRepositoryProvider).completeOnboarding(input),
    );
    return !state.hasError;
  }
}
