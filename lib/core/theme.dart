import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

/// KriyaLink Material 3 theme.
class KriyaLinkTheme {
  KriyaLinkTheme._();

  // ── Color Scheme ──────────────────────────────────────────────────────────
  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: kPrimaryColor,
    onPrimary: kOnPrimaryColor,
    secondary: kSecondaryColor,
    onSecondary: Colors.white,
    error: kErrorColor,
    onError: Colors.white,
    surface: kSurfaceColor,
    onSurface: kTextPrimaryColor,
    surfaceContainerHighest: kBackgroundColor,
  );

  // ── Text Theme ────────────────────────────────────────────────────────────
  static TextTheme get _textTheme {
    final headlineFont = GoogleFonts.poppinsTextTheme();
    final bodyFont = GoogleFonts.interTextTheme();

    return TextTheme(
      // Headlines — Poppins
      displayLarge: headlineFont.displayLarge?.copyWith(
        color: kTextPrimaryColor,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: headlineFont.displayMedium?.copyWith(
        color: kTextPrimaryColor,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: headlineFont.displaySmall?.copyWith(
        color: kTextPrimaryColor,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: headlineFont.headlineLarge?.copyWith(
        color: kTextPrimaryColor,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: headlineFont.headlineMedium?.copyWith(
        color: kTextPrimaryColor,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: headlineFont.headlineSmall?.copyWith(
        color: kTextPrimaryColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: headlineFont.titleLarge?.copyWith(
        color: kTextPrimaryColor,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: headlineFont.titleMedium?.copyWith(
        color: kTextPrimaryColor,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: headlineFont.titleSmall?.copyWith(
        color: kTextPrimaryColor,
        fontWeight: FontWeight.w500,
      ),

      // Body — Inter
      bodyLarge: bodyFont.bodyLarge?.copyWith(color: kTextPrimaryColor),
      bodyMedium: bodyFont.bodyMedium?.copyWith(color: kTextPrimaryColor),
      bodySmall: bodyFont.bodySmall?.copyWith(color: kTextSecondaryColor),

      // Labels — Inter
      labelLarge: bodyFont.labelLarge?.copyWith(
        color: kTextPrimaryColor,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: bodyFont.labelMedium?.copyWith(color: kTextSecondaryColor),
      labelSmall: bodyFont.labelSmall?.copyWith(color: kTextSecondaryColor),
    );
  }

  // ── Component Themes ──────────────────────────────────────────────────────

  static final _cardTheme = CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kBorderRadiusCard),
      side: const BorderSide(color: kBorderColor, width: 1),
    ),
    color: kSurfaceColor,
    margin: EdgeInsets.zero,
  );

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: kOnPrimaryColor,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusButton),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: kPrimaryColor,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusButton),
      ),
      side: const BorderSide(color: kPrimaryColor, width: 1.5),
      textStyle: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: kPrimaryColor,
      textStyle: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final _inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: kSurfaceColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadiusInput),
      borderSide: const BorderSide(color: kBorderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadiusInput),
      borderSide: const BorderSide(color: kBorderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadiusInput),
      borderSide: const BorderSide(color: kPrimaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadiusInput),
      borderSide: const BorderSide(color: kErrorColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kBorderRadiusInput),
      borderSide: const BorderSide(color: kErrorColor, width: 2),
    ),
    hintStyle: GoogleFonts.inter(
      color: kTextSecondaryColor,
      fontSize: 14,
    ),
    labelStyle: GoogleFonts.inter(
      color: kTextSecondaryColor,
      fontSize: 14,
    ),
  );

  static const _appBarTheme = AppBarTheme(
    backgroundColor: kSurfaceColor,
    foregroundColor: kTextPrimaryColor,
    elevation: 0,
    scrolledUnderElevation: 0.5,
    centerTitle: false,
  );

  static final _bottomNavBarTheme = BottomNavigationBarThemeData(
    backgroundColor: kSurfaceColor,
    selectedItemColor: kPrimaryColor,
    unselectedItemColor: kTextSecondaryColor,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    selectedLabelStyle: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
  );

  static const _chipTheme = ChipThemeData(
    backgroundColor: kBackgroundColor,
    selectedColor: kPrimaryColor,
    side: BorderSide(color: kBorderColor),
    labelStyle: TextStyle(fontSize: 13),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    shape: StadiumBorder(),
  );

  static const _dividerTheme = DividerThemeData(
    color: kBorderColor,
    thickness: 1,
    space: 1,
  );

  // ── ThemeData ─────────────────────────────────────────────────────────────

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: kBackgroundColor,
      textTheme: _textTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      appBarTheme: _appBarTheme,
      bottomNavigationBarTheme: _bottomNavBarTheme,
      chipTheme: _chipTheme,
      dividerTheme: _dividerTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
