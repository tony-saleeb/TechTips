import 'package:flutter/material.dart';

/// Abstract repository contract for settings data operations
abstract class SettingsRepository {
  /// Get theme mode
  Future<ThemeMode> getThemeMode();
  
  /// Set theme mode
  Future<void> setThemeMode(ThemeMode themeMode);
  
  /// Get font size
  Future<double> getFontSize();
  
  /// Set font size
  Future<void> setFontSize(double fontSize);
  
  /// Get app version
  String getAppVersion();
  
  /// Get build number
  String getBuildNumber();
  
  /// Clear all settings (reset to defaults)
  Future<void> clearSettings();
  
  /// Export settings
  Future<Map<String, dynamic>> exportSettings();
  
  /// Import settings
  Future<void> importSettings(Map<String, dynamic> settings);
}
