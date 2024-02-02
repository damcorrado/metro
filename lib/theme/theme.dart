import 'package:flutter/material.dart';

class ThemeConstants {
  static const double borderRadius = 20.0;
  static const String fontFamilyPrimary = "WorkSans";
}

// CUSTOM THEME
const ColorScheme _darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Colors.deepPurple,
  onPrimary: Colors.white,
  secondary: Colors.deepPurpleAccent,
  onSecondary: Colors.white,
  tertiary: Colors.deepPurpleAccent,
  onTertiary: Colors.white,
  error: Colors.red,
  onError: Colors.white,
  background: Color(0xFF000000),
  onBackground: Colors.white,
  surface: Color(0xFF444444),
  onSurface: Colors.white,
);

const ColorScheme _lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.deepPurple,
  onPrimary: Colors.white,
  secondary: Colors.deepPurpleAccent,
  onSecondary: Colors.white,
  tertiary: Colors.deepPurpleAccent,
  onTertiary: Colors.white,
  error: Colors.red,
  onError: Colors.white,
  background: Color(0xFFFAFAFA),
  onBackground: Color(0xFF222222),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF444444),
);

const TextTheme _textTheme = TextTheme(
  headlineLarge: TextStyle(fontSize: 38, fontFamily: ThemeConstants.fontFamilyPrimary, fontWeight: FontWeight.w600),
  headlineMedium: TextStyle(fontSize: 34, fontFamily: ThemeConstants.fontFamilyPrimary, fontWeight: FontWeight.w500),
  headlineSmall: TextStyle(fontSize: 30, fontFamily: ThemeConstants.fontFamilyPrimary, fontWeight: FontWeight.w400),
  titleLarge: TextStyle(fontSize: 22.0, fontFamily: ThemeConstants.fontFamilyPrimary, fontWeight: FontWeight.w600),
  titleMedium: TextStyle(fontSize: 20.0, fontFamily: ThemeConstants.fontFamilyPrimary, fontWeight: FontWeight.w500),
  titleSmall: TextStyle(fontSize: 18.0, fontFamily: ThemeConstants.fontFamilyPrimary, fontWeight: FontWeight.w400),
  bodyLarge: TextStyle(fontSize: 16.0, fontFamily: ThemeConstants.fontFamilyPrimary, fontWeight: FontWeight.w400),
  bodyMedium: TextStyle(fontSize: 14.0, fontFamily: ThemeConstants.fontFamilyPrimary, fontWeight: FontWeight.w400),
  bodySmall: TextStyle(fontSize: 12.0, fontFamily: ThemeConstants.fontFamilyPrimary, fontWeight: FontWeight.w400),
  labelLarge: TextStyle(fontSize: 16.0, fontFamily: ThemeConstants.fontFamilyPrimary, fontWeight: FontWeight.w700),
  labelMedium: TextStyle(fontSize: 14.0, fontFamily: ThemeConstants.fontFamilyPrimary, fontWeight: FontWeight.w700),
  labelSmall: TextStyle(fontSize: 12.0, fontFamily: ThemeConstants.fontFamilyPrimary, fontWeight: FontWeight.w700),
);

ThemeData getTheme({bool darkMode = true}) {
  ColorScheme genericColorScheme = darkMode ? _darkScheme : _lightScheme;

  return ThemeData(
    colorScheme: genericColorScheme,
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: genericColorScheme.onBackground,
        backgroundColor: Colors.white30,
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 5.0,
        ),
        textStyle: _textTheme.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 5.0,
          ),
        textStyle: _textTheme.labelMedium,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          _textTheme.bodySmall?.copyWith(
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: _textTheme.titleMedium,
      backgroundColor: genericColorScheme.background,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: genericColorScheme.onPrimary,
        size: 25,
      ),
      actionsIconTheme: IconThemeData(
        color: genericColorScheme.onPrimary,
        size: 25,
      ),
    ),
    cardTheme: CardTheme(
      color: genericColorScheme.onBackground.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
      ),
      elevation: 0,
    ),
    // Snack bar
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: genericColorScheme.primary,
      contentTextStyle: TextStyle(color: genericColorScheme.onPrimary),
    ),
    textTheme: _textTheme,
  );
}
