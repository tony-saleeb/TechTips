import 'package:flutter/material.dart';
import '../../domain/usecases/manage_settings_usecase.dart';

/// ViewModel for managing settings state and operations
class SettingsViewModel extends ChangeNotifier {
  final ManageSettingsUseCase _manageSettingsUseCase;
  
  SettingsViewModel({
    required ManageSettingsUseCase manageSettingsUseCase,
  }) : _manageSettingsUseCase = manageSettingsUseCase;
  
  // State
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 14.0;
  double _appearanceSize = 1.0; // Default appearance size multiplier
  bool _isLoading = false;
  String? _error;
  
  // Getters
  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  double get appearanceSize => _appearanceSize;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  String get appVersion => _manageSettingsUseCase.getAppVersion();
  String get buildNumber => _manageSettingsUseCase.getBuildNumber();
  
  /// Initialize settings by loading from storage - Ultra performance optimized
  Future<void> initialize() async {
    if (_isLoading) return; // Prevent multiple initialization calls
    
    _isLoading = true;
    _error = null;
    
    try {
      // Load all settings concurrently for maximum performance
      final futures = await Future.wait([
        _manageSettingsUseCase.getThemeMode(),
        _manageSettingsUseCase.getFontSize(),
        _manageSettingsUseCase.getAppearanceSize(),
      ], eagerError: true); // Fail fast if any request fails
      
      _themeMode = futures[0] as ThemeMode;
      _fontSize = futures[1] as double;
      _appearanceSize = futures[2] as double;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Settings initialization error: $e');
      _error = 'Failed to load settings: ${e.toString()}';
      // Use default values on error
      _themeMode = ThemeMode.system;
      _fontSize = 14.0;
      _appearanceSize = 1.0;
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Set theme mode with smooth transition
  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_themeMode == themeMode) return;
    
    _clearError();
    
    try {
      // Update theme mode immediately for smooth UI transition
      _themeMode = themeMode;
      notifyListeners();
      
      // Save to storage in background
      await _manageSettingsUseCase.setThemeMode(themeMode);
    } catch (e) {
      _setError('Failed to set theme mode: ${e.toString()}');
    }
  }
  
  /// Set font size
  Future<void> setFontSize(double fontSize) async {
    if (_fontSize == fontSize) return;
    
    _clearError();
    
    try {
      await _manageSettingsUseCase.setFontSize(fontSize);
      _fontSize = fontSize;
      notifyListeners();
    } catch (e) {
      _setError('Failed to set font size: ${e.toString()}');
    }
  }
  
  /// Set appearance size
  Future<void> setAppearanceSize(double appearanceSize) async {
    if (_appearanceSize == appearanceSize) return;
    
    _clearError();
    
    try {
      await _manageSettingsUseCase.setAppearanceSize(appearanceSize);
      _appearanceSize = appearanceSize;
      notifyListeners();
    } catch (e) {
      _setError('Failed to set appearance size: ${e.toString()}');
    }
  }
  
  /// Reset all settings to defaults
  Future<void> resetSettings() async {
    _setLoading(true);
    _clearError();
    
    try {
      await _manageSettingsUseCase.resetSettings();
      
      // Reset to default values
      _themeMode = ThemeMode.system;
      _fontSize = 14.0;
      _appearanceSize = 1.0;
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to reset settings: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Export settings
  Future<Map<String, dynamic>?> exportSettings() async {
    _clearError();
    
    try {
      return await _manageSettingsUseCase.exportSettings();
    } catch (e) {
      _setError('Failed to export settings: ${e.toString()}');
      return null;
    }
  }
  
  /// Import settings
  Future<void> importSettings(Map<String, dynamic> settings) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _manageSettingsUseCase.importSettings(settings);
      
      // Reload settings after import
      await initialize();
    } catch (e) {
      _setError('Failed to import settings: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Get theme mode display name
  String getThemeModeDisplayName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
  
  /// Get all available theme modes
  List<ThemeMode> get availableThemeModes => [
        ThemeMode.system,
        ThemeMode.light,
        ThemeMode.dark,
      ];
  
  /// Get font size display name
  String getFontSizeDisplayName(double fontSize) {
    if (fontSize <= 12) return 'Small';
    if (fontSize <= 14) return 'Medium';
    if (fontSize <= 16) return 'Large';
    return 'Extra Large';
  }
  
  /// Get available font sizes
  List<double> get availableFontSizes => [12.0, 14.0, 16.0, 18.0, 20.0];
  
  /// Set loading state
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }
  
  /// Set error state
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  /// Clear error state
  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
