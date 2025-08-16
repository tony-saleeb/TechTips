import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Application theme configuration
class AppTheme {
  /// Light theme configuration - Clean and Professional
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      
      // Color scheme - Minimal and High Contrast
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.neutral100,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.neutral50,
        surface: AppColors.surfaceLight,
        surfaceVariant: AppColors.neutral50,
        error: AppColors.error,
        onPrimary: AppColors.textInverse,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        onError: AppColors.textInverse,
        outline: AppColors.borderLight,
      ),
      
      // App bar theme - Clean and Minimal
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      // Card theme - Minimal with Subtle Shadows
      cardTheme: CardTheme(
        color: AppColors.cardLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      
      // Text theme
      textTheme: _buildTextTheme(Brightness.light),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textTertiary,
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentDark,
          foregroundColor: AppColors.backgroundDark,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.textInverse,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
  
  /// Dark theme configuration - Elegant and Modern
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.accentDark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      
      // Color scheme - Beautiful & Simple
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentDark,
        primaryContainer: AppColors.cardDark,
        secondary: AppColors.textDarkSecondary,
        secondaryContainer: AppColors.surfaceDark,
        surface: AppColors.surfaceDark,
        surfaceVariant: AppColors.cardDark,
        error: AppColors.error,
        onPrimary: AppColors.textInverse,
        onSecondary: AppColors.textDarkPrimary,
        onSurface: AppColors.textDarkPrimary,
        onSurfaceVariant: AppColors.textDarkSecondary,
        onError: AppColors.textInverse,
        outline: AppColors.borderDark,
      ),
      
      // App bar theme - Elegant Dark
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textDarkPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textDarkPrimary,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textDarkPrimary,
          size: 24,
        ),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.accentDark,
        unselectedItemColor: AppColors.textDarkTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      // Card theme - Clean & Beautiful
      cardTheme: CardTheme(
        color: AppColors.cardDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Text theme
      textTheme: _buildTextTheme(Brightness.dark),
      
      // Input decoration theme - Beautiful Dark Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentDark, width: 2),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textDarkTertiary,
        ),
        labelStyle: GoogleFonts.inter(
          color: AppColors.textDarkSecondary,
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentDark,
          foregroundColor: AppColors.backgroundDark,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.textInverse,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
  
  /// Build professional text theme with perfect typography
  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color primaryTextColor = brightness == Brightness.light
        ? AppColors.textPrimary
        : AppColors.textDarkPrimary;
    final Color secondaryTextColor = brightness == Brightness.light
        ? AppColors.textSecondary
        : AppColors.textDarkSecondary;
    
    return TextTheme(
      // Headlines - Clean and Readable
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: primaryTextColor,
        letterSpacing: -1.0,
        height: 1.1,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: -0.3,
        height: 1.3,
      ),
      
      // Titles - Professional Hierarchy
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: -0.2,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        letterSpacing: -0.1,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
        height: 1.4,
      ),
      
      // Body text - Readable and Clean
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryTextColor,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        height: 1.4,
      ),
      
      // Labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
      ),
    );
  }
}
