import 'dart:ui' as ui;

import 'package:flutter/material.dart';

@immutable
class EntreNosTokens extends ThemeExtension<EntreNosTokens> {
  const EntreNosTokens({
    required this.pagePadding,
    required this.sectionGap,
    required this.cardRadius,
    required this.cardColor,
    required this.subtleSurface,
    required this.success,
    required this.danger,
  });

  final EdgeInsets pagePadding;
  final double sectionGap;
  final BorderRadius cardRadius;
  final Color cardColor;
  final Color subtleSurface;
  final Color success;
  final Color danger;

  static final fallback = EntreNosTokens(
    pagePadding: const EdgeInsets.all(24),
    sectionGap: 20,
    cardRadius: BorderRadius.circular(20),
    cardColor: const Color(0xFFF6F0F5),
    subtleSurface: const Color(0xFFEEE7ED),
    success: const Color(0xFF176B3A),
    danger: const Color(0xFFBA1A1A),
  );

  @override
  EntreNosTokens copyWith({
    EdgeInsets? pagePadding,
    double? sectionGap,
    BorderRadius? cardRadius,
    Color? cardColor,
    Color? subtleSurface,
    Color? success,
    Color? danger,
  }) => EntreNosTokens(
    pagePadding: pagePadding ?? this.pagePadding,
    sectionGap: sectionGap ?? this.sectionGap,
    cardRadius: cardRadius ?? this.cardRadius,
    cardColor: cardColor ?? this.cardColor,
    subtleSurface: subtleSurface ?? this.subtleSurface,
    success: success ?? this.success,
    danger: danger ?? this.danger,
  );

  @override
  EntreNosTokens lerp(EntreNosTokens? other, double t) {
    if (other is! EntreNosTokens) return this;
    return EntreNosTokens(
      pagePadding: EdgeInsets.lerp(pagePadding, other.pagePadding, t)!,
      sectionGap: ui.lerpDouble(sectionGap, other.sectionGap, t)!,
      cardRadius: BorderRadius.lerp(cardRadius, other.cardRadius, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      subtleSurface: Color.lerp(subtleSurface, other.subtleSurface, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

extension EntreNosThemeContext on BuildContext {
  EntreNosTokens get entreNosTokens =>
      Theme.of(this).extension<EntreNosTokens>() ?? EntreNosTokens.fallback;
}

abstract final class EntreNosTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFB78AAF),
      brightness: brightness,
      surface: isDark ? const Color(0xFF11151F) : const Color(0xFFFFFBFF),
    );
    final tokens = EntreNosTokens(
      pagePadding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      sectionGap: 20,
      cardRadius: BorderRadius.circular(20),
      cardColor: isDark ? const Color(0xFF1A2130) : const Color(0xFFF6F0F5),
      subtleSurface: isDark ? const Color(0xFF252C3A) : const Color(0xFFEEE7ED),
      success: isDark ? const Color(0xFF9FD9B4) : const Color(0xFF176B3A),
      danger: isDark ? const Color(0xFFFFB4AB) : const Color(0xFFBA1A1A),
    );

    final baseTextTheme = Typography.material2021().white.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
    final textTheme = baseTextTheme.copyWith(
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontFamily: 'serif',
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontFamily: 'serif',
        fontWeight: FontWeight.w600,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [tokens],
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: tokens.cardRadius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: tokens.cardRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.subtleSurface,
        border: OutlineInputBorder(borderRadius: tokens.cardRadius),
        enabledBorder: OutlineInputBorder(
          borderRadius: tokens.cardRadius,
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: tokens.cardRadius),
      ),
    );
  }
}
