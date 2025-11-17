import 'package:flutter/material.dart';

class AppTheme {
  // Purple color palette
  static const Color primaryPurple = Color(0xFF7C3AED); // Vibrant purple
  static const Color secondaryPurple = Color(0xFF9333EA);
  static const Color lightPurple = Color(0xFFDDD6FE);
  static const Color darkPurple = Color(0xFF5B21B6);
  static const Color accentPink = Color(0xFFEC4899);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF9333EA), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryPurple,
      primary: primaryPurple,
      secondary: secondaryPurple,
      tertiary: accentPink,
      surface: Colors.white,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1F2937),
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: Color(0xFF1F2937),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Card theme
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryPurple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      prefixIconColor: primaryPurple,
      suffixIconColor: Colors.grey,
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryPurple,
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Icon button theme
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: const Color(0xFF6B7280),
      ),
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryPurple,
      unselectedItemColor: Color(0xFF9CA3AF),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      showUnselectedLabels: true,
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryPurple,
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: lightPurple,
      labelStyle: const TextStyle(color: darkPurple),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // Dialog theme
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // Snackbar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1F2937),
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryPurple,
    ),

    // Divider theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5E7EB),
      thickness: 1,
      space: 1,
    ),
  );

  // Dark theme (optional)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryPurple,
      primary: primaryPurple,
      secondary: secondaryPurple,
      tertiary: accentPink,
      surface: const Color(0xFF1F2937),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF111827),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Color(0xFF1F2937),
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Card theme
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFF1F2937),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );
}
