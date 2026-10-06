import 'package:flutter/material.dart';

/// Theme mode including AMOLED (pure black dark)
enum AppThemeMode { light, dark, amoled, system }

class AppTheme {
  static const Color _seed = Color(0xFF00E5FF); // Cyan accent

  // ── Light ─────────────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),),
          margin: EdgeInsets.zero,
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),),
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),),
          ),
        ),
      );

  // ── Dark ──────────────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),),
          margin: EdgeInsets.zero,
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),),
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),),
          ),
        ),
      );

  // ── AMOLED (true black) ───────────────────────────────────────────────────
  static ThemeData get amoled {
    final base = dark;
    return base.copyWith(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: base.colorScheme.copyWith(
        surface: Colors.black,
        surfaceContainer: const Color(0xFF080808),
        surfaceContainerHighest: const Color(0xFF111111),
        surfaceContainerHigh: const Color(0xFF0D0D0D),
        surfaceContainerLow: const Color(0xFF050505),
      ),
      cardTheme: base.cardTheme.copyWith(
        color: const Color(0xFF080808),
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: Colors.black,
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        backgroundColor: Colors.black,
        indicatorColor: const Color(0xFF00E5FF).withValues(alpha: 0.2),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      drawerTheme: base.drawerTheme.copyWith(
        backgroundColor: Colors.black,
      ),
    );
  }
}
