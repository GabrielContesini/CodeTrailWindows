import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData dark() {
    final colorScheme = const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColors.primaryAccent,
      secondary: AppColors.secondaryAccent,
      tertiary: AppColors.warningAccent,
      error: AppColors.dangerAccent,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      onPrimary: Colors.white,
      onSecondary: AppColors.brandBlack,
      outline: AppColors.darkBorder,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.darkBackground,
      cardColor: AppColors.darkCard,
      textColor: AppColors.darkTextPrimary,
      secondaryTextColor: AppColors.darkTextSecondary,
      splashFactory: InkSparkle.splashFactory,
    );
  }

  static ThemeData light() {
    final colorScheme = const ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColors.primaryAccent,
      secondary: AppColors.secondaryAccent,
      tertiary: AppColors.warningAccent,
      error: AppColors.dangerAccent,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      onPrimary: Colors.white,
      onSecondary: AppColors.brandBlack,
      outline: AppColors.lightBorder,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.lightBackground,
      cardColor: AppColors.lightCard,
      textColor: AppColors.lightTextPrimary,
      secondaryTextColor: AppColors.lightTextSecondary,
      splashFactory: InkRipple.splashFactory,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
    required InteractiveInkFeatureFactory splashFactory,
  }) {
    final baseTextTheme = GoogleFonts.manropeTextTheme(
      colorScheme.brightness == Brightness.dark
          ? Typography.whiteMountainView
          : Typography.blackMountainView,
    ).apply(bodyColor: textColor, displayColor: textColor);

    final textTheme = _buildTextTheme(
      base: baseTextTheme,
      textColor: textColor,
      secondaryTextColor: secondaryTextColor,
    );

    final isDark = colorScheme.brightness == Brightness.dark;
    final panelColor = Color.alphaBlend(
      (isDark ? Colors.white : Colors.black).withValues(
        alpha: isDark ? 0.02 : 0.008,
      ),
      cardColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      cardColor: panelColor,
      textTheme: textTheme,
      splashFactory: splashFactory,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            Colors.black.withValues(alpha: isDark ? 0.18 : 0.10),
            colorScheme.surface,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.7)),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 46),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 46),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.9)),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(40, 40),
          padding: const EdgeInsets.all(9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: panelColor,
        selectedColor: colorScheme.primary.withValues(alpha: 0.14),
        labelStyle: textTheme.labelMedium ?? const TextStyle(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.9)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color.alphaBlend(
          (isDark ? Colors.white : Colors.black).withValues(
            alpha: isDark ? 0.01 : 0.005,
          ),
          panelColor,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: secondaryTextColor),
        labelStyle: textTheme.bodyMedium?.copyWith(color: secondaryTextColor),
        prefixIconColor: secondaryTextColor,
        suffixIconColor: secondaryTextColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.85)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: colorScheme.primary.withValues(alpha: 0.95)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: colorScheme.error.withValues(alpha: 0.9)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      cardTheme: CardThemeData(
        color: panelColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.9)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: panelColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.9)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: panelColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.85)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.82),
        thickness: 1,
        space: 1,
      ),
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(999),
        thickness: WidgetStateProperty.all(8),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return colorScheme.primary.withValues(alpha: 0.8);
          }
          return colorScheme.primary.withValues(alpha: 0.45);
        }),
        trackColor: WidgetStateProperty.all(
          colorScheme.surface.withValues(alpha: 0.24),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbIcon: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Icon(Icons.check_rounded, size: 14);
          }
          return const Icon(Icons.close_rounded, size: 14);
        }),
      ),
      listTileTheme: ListTileThemeData(
        dense: true,
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(vertical: -2),
        iconColor: secondaryTextColor,
        textColor: textColor,
      ),
    );
  }

  static TextTheme _buildTextTheme({
    required TextTheme base,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    TextStyle? display(TextStyle? style, double size) {
      if (style == null) return null;
      return GoogleFonts.spaceGrotesk(
        textStyle: style.copyWith(
          fontSize: size,
          color: textColor,
          fontWeight: FontWeight.w700,
          height: 1.02,
          letterSpacing: -0.7,
        ),
      );
    }

    TextStyle? title(TextStyle? style, double size, FontWeight weight) {
      if (style == null) return null;
      return style.copyWith(
        fontSize: size,
        color: textColor,
        fontWeight: weight,
        height: 1.14,
      );
    }

    TextStyle? body(TextStyle? style, double size, {Color? color}) {
      if (style == null) return null;
      return style.copyWith(
        fontSize: size,
        color: color ?? textColor,
        height: 1.5,
      );
    }

    return base.copyWith(
      displayLarge: display(base.displayLarge, 52),
      displayMedium: display(base.displayMedium, 42),
      displaySmall: display(base.displaySmall, 34),
      headlineLarge: display(base.headlineLarge, 30),
      headlineMedium: display(base.headlineMedium, 24),
      headlineSmall: display(base.headlineSmall, 20),
      titleLarge: title(base.titleLarge, 18, FontWeight.w800),
      titleMedium: title(base.titleMedium, 15, FontWeight.w700),
      titleSmall: title(base.titleSmall, 13, FontWeight.w700),
      bodyLarge: body(base.bodyLarge, 14),
      bodyMedium: body(base.bodyMedium, 13, color: secondaryTextColor),
      bodySmall: body(base.bodySmall, 11.5, color: secondaryTextColor),
      labelLarge: body(
        base.labelLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.18),
        12.5,
      ),
      labelMedium: body(
        base.labelMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.16),
        11.5,
      ),
      labelSmall: body(
        base.labelSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.15),
        10.5,
      ),
    );
  }
}
