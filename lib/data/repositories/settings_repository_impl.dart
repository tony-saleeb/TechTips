import 'package:flutter/material.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local_data_source.dart';
import '../../core/constants/app_constants.dart';

/// Implementation of SettingsRepository using local data source
class SettingsRepositoryImpl implements SettingsRepository {
  final LocalDataSource _localDataSource;
  
  static const String _appVersion = '1.0.0';
  static const String _buildNumber = '1';
  
  SettingsRepositoryImpl(this._localDataSource);
  
  @override
  Future<ThemeMode> getThemeMode() async {
    try {
      final themeModeString = await _localDataSource.getThemeMode();
      return _parseThemeMode(themeModeString);
    } catch (e) {
      // Return default theme mode on error
      return ThemeMode.system;
    }
  }
  
  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final themeModeString = _themeModeToString(themeMode);
      await _localDataSource.saveThemeMode(themeModeString);
    } catch (e) {
      throw Exception('Failed to set theme mode: $e');
    }
  }
  
  @override
  Future<double> getFontSize() async {
    try {
      final fontSize = await _localDataSource.getFontSize();
      return fontSize ?? AppConstants.defaultFontSize;
    } catch (e) {
      // Return default font size on error
      return AppConstants.defaultFontSize;
    }
  }
  
  @override
  Future<void> setFontSize(double fontSize) async {
    try {
      await _localDataSource.saveFontSize(fontSize);
    } catch (e) {
      throw Exception('Failed to set font size: $e');
    }
  }
  
  @override
  Future<double> getAppearanceSize() async {
    try {
      final appearanceSize = await _localDataSource.getAppearanceSize();
      return appearanceSize ?? 1.0; // Default appearance size
    } catch (e) {
      // Return default appearance size on error
      return 1.0;
    }
  }
  
  @override
  Future<void> setAppearanceSize(double appearanceSize) async {
    try {
      await _localDataSource.saveAppearanceSize(appearanceSize);
    } catch (e) {
      throw Exception('Failed to set appearance size: $e');
    }
  }
  
  @override
  String getAppVersion() {
    return _appVersion;
  }
  
  @override
  String getBuildNumber() {
    return _buildNumber;
  }
  
  @override
  Future<void> clearSettings() async {
    try {
      await _localDataSource.clearAllPreferences();
    } catch (e) {
      throw Exception('Failed to clear settings: $e');
    }
  }
  
  @override
  Future<Map<String, dynamic>> exportSettings() async {
    try {
      final preferences = await _localDataSource.getAllPreferences();
      
      // Add app metadata
      preferences['app_version'] = _appVersion;
      preferences['build_number'] = _buildNumber;
      preferences['export_date'] = DateTime.now().toIso8601String();
      
      return preferences;
    } catch (e) {
      throw Exception('Failed to export settings: $e');
    }
  }
  
  @override
  Future<void> importSettings(Map<String, dynamic> settings) async {
    try {
      // Remove metadata before importing
      final settingsToImport = Map<String, dynamic>.from(settings);
      settingsToImport.remove('app_version');
      settingsToImport.remove('build_number');
      settingsToImport.remove('export_date');
      
      await _localDataSource.setAllPreferences(settingsToImport);
    } catch (e) {
      throw Exception('Failed to import settings: $e');
    }
  }
  
  /// Parse theme mode string to ThemeMode enum
  ThemeMode _parseThemeMode(String? themeModeString) {
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
  
  /// Convert ThemeMode enum to string
  String _themeModeToString(ThemeMode themeMode) {
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
