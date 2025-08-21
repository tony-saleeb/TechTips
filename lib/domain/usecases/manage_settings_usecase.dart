import 'package:flutter/material.dart';
import '../repositories/settings_repository.dart';
import '../../core/constants/app_constants.dart';

/// Use case for managing application settings
class ManageSettingsUseCase {
  final SettingsRepository _repository;
  
  const ManageSettingsUseCase(this._repository);
  
  /// Get current theme mode
  Future<ThemeMode> getThemeMode() async {
    try {
      return await _repository.getThemeMode();
    } catch (e) {
      // Return default theme mode on error
      return ThemeMode.system;
    }
  }
  
  /// Set theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      await _repository.setThemeMode(themeMode);
    } catch (e) {
      throw Exception('Failed to set theme mode: $e');
    }
  }
  
  /// Get current font size
  Future<double> getFontSize() async {
    try {
      final fontSize = await _repository.getFontSize();
      
      // Validate font size is within acceptable range
      if (fontSize < AppConstants.minFontSize || fontSize > AppConstants.maxFontSize) {
        return AppConstants.defaultFontSize;
      }
      
      return fontSize;
    } catch (e) {
      // Return default font size on error
      return AppConstants.defaultFontSize;
    }
  }
  
  /// Set font size
  Future<void> setFontSize(double fontSize) async {
    // Validate font size
    if (fontSize < AppConstants.minFontSize || fontSize > AppConstants.maxFontSize) {
      throw ArgumentError(
        'Font size must be between ${AppConstants.minFontSize} and ${AppConstants.maxFontSize}',
      );
    }
    
    try {
      await _repository.setFontSize(fontSize);
    } catch (e) {
      throw Exception('Failed to set font size: $e');
    }
  }
  
  /// Get current appearance size
  Future<double> getAppearanceSize() async {
    try {
      final appearanceSize = await _repository.getAppearanceSize();
      
      // Validate appearance size is within acceptable range
      if (appearanceSize < 0.5 || appearanceSize > 1.2) {
        return 1.0; // Default appearance size
      }
      
      return appearanceSize;
    } catch (e) {
      // Return default appearance size on error
      return 1.0;
    }
  }
  
  /// Set appearance size
  Future<void> setAppearanceSize(double appearanceSize) async {
    // Validate appearance size
    if (appearanceSize < 0.5 || appearanceSize > 1.2) {
      throw ArgumentError(
        'Appearance size must be between 0.5 and 1.2',
      );
    }
    
    try {
      await _repository.setAppearanceSize(appearanceSize);
    } catch (e) {
      throw Exception('Failed to set appearance size: $e');
    }
  }
  
  /// Get app version
  String getAppVersion() {
    return _repository.getAppVersion();
  }
  
  /// Get build number
  String getBuildNumber() {
    return _repository.getBuildNumber();
  }
  
  /// Get app info
  Map<String, String> getAppInfo() {
    return {
      'version': getAppVersion(),
      'build': getBuildNumber(),
    };
  }
  
  /// Reset all settings to defaults
  Future<void> resetSettings() async {
    try {
      await _repository.clearSettings();
    } catch (e) {
      throw Exception('Failed to reset settings: $e');
    }
  }
  
  /// Export current settings
  Future<Map<String, dynamic>> exportSettings() async {
    try {
      return await _repository.exportSettings();
    } catch (e) {
      throw Exception('Failed to export settings: $e');
    }
  }
  
  /// Import settings from data
  Future<void> importSettings(Map<String, dynamic> settings) async {
    if (settings.isEmpty) {
      throw ArgumentError('Settings data cannot be empty');
    }
    
    try {
      await _repository.importSettings(settings);
    } catch (e) {
      throw Exception('Failed to import settings: $e');
    }
  }
  
  /// Validate theme mode string and convert to ThemeMode
  ThemeMode parseThemeMode(String? themeModeString) {
    switch (themeModeString?.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
  
  /// Convert ThemeMode to string
  String themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
