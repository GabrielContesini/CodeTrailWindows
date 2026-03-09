import 'package:code_trail_windows/core/constants/app_constants.dart';
import 'package:code_trail_windows/core/theme/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App basics', () {
    test('exposes stable app constants', () {
      expect(AppConstants.appName, 'CodeTrail Windows');
      expect(AppConstants.defaultDailySessionMinutes, greaterThan(0));
      expect(AppConstants.syncRetryLimit, greaterThan(0));
    });

    test('defines the expected premium palette anchors', () {
      expect(AppColors.darkBackground.toARGB32(), 0xFF0A0F14);
      expect(AppColors.primaryAccent.toARGB32(), 0xFF005F73);
      expect(AppColors.lightBackground.toARGB32(), 0xFFF4F8FB);
    });
  });
}
