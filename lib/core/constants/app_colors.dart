import 'package:flutter/material.dart';

/// Professional, minimal color palette inspired by modern design systems
class AppColors {
  // Core Brand Colors - Sophisticated and Minimal
  static const Color primary = Color(0xFF1A1A1A); // Rich Black
  static const Color secondary = Color(0xFF6B7280); // Warm Gray
  static const Color accent = Color(0xFFEAB308); // Refined Gold
  static const Color accentDark = Color(0xFF0891B2); // Darker cyan - more sophisticated
  static const Color success = Color(0xFF059669); // Forest Green
  
  // Neutral Palette - Professional Grays
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color neutral300 = Color(0xFFD4D4D4);
  static const Color neutral400 = Color(0xFFA3A3A3);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral800 = Color(0xFF262626);
  static const Color neutral900 = Color(0xFF171717);
  
  // OS Accent Colors - All Use Same Darker Cyan
  static const Color windowsAccent = Color(0xFF0891B2); // Same darker cyan
  static const Color macAccent = Color(0xFF0891B2); // Same darker cyan
  static const Color linuxAccent = Color(0xFF0891B2); // Same darker cyan
  
  // Semantic Colors - Clean and Professional
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFDC2626); // Red
  static const Color info = Color(0xFF06B6D4); // Light Cyan - Eye-Friendly
  static const Color favoriteRed = Color(0xFF8B2635); // Relaxing dark red for favorites
  
  // Background Colors - Beautiful & Simple
  static const Color backgroundLight = Color(0xFFFFFFFF); // Pure white
  static const Color backgroundDark = Color(0xFF1A1A1A); // Beautiful dark like Discord
  static const Color surfaceLight = Color(0xFFFAFAFA); // Off-white
  static const Color surfaceDark = Color(0xFF2F2F2F); // Clean elevated surface

  // Card Colors - Clean & Modern
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF3A3A3A); // Beautiful card color

  // Border Colors - Subtle & Clean
  static const Color borderLight = Color(0xFFE5E5E5);
  static const Color borderDark = Color(0xFF4A4A4A); // Visible but subtle
  
  // Text Colors - High Contrast and Readable
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFFA3A3A3);
  static const Color textInverse = Color(0xFFFFFFFF);
  
  // Dark Theme Text Colors - Eye-Friendly & Readable
  static const Color textDarkPrimary = Color(0xFFFFFFFF); // Pure white - crystal clear
  static const Color textDarkSecondary = Color(0xFFE5E5E5); // Very light gray - much more readable
  static const Color textDarkTertiary = Color(0xFFA0A0A0); // Light gray - still visible
  
  // Shadow Colors - Subtle and Professional
  static const Color shadowLight = Color(0x08000000); // 3% black
  static const Color shadowDark = Color(0x40000000); // 25% black
  
  /// Get OS specific accent color - Subtle and Professional
  static Color getOSColor(String os) {
    switch (os.toLowerCase()) {
      case 'windows':
        return windowsAccent;
      case 'macos':
        return macAccent;
      case 'linux':
        return linuxAccent;
      default:
        return primary;
    }
  }
  
  /// Get OS specific light color for backgrounds
  static Color getOSLightColor(String os) {
    switch (os.toLowerCase()) {
      case 'windows':
        return const Color(0xFFF8FAFC);
      case 'macos':
        return const Color(0xFFF9FAFB);
      case 'linux':
        return const Color(0xFFF0F9FF);
      default:
        return neutral50;
    }
  }
  
  /// Professional color combinations for cards
  static List<Color> getCardColors(bool isDark) {
    if (isDark) {
      return [cardDark, surfaceDark];
    } else {
      return [cardLight, surfaceLight];
    }
  }
}
