import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Main app ViewModel for managing global app state
class AppViewModel extends ChangeNotifier {
  // State
  int _currentTabIndex = 0;
  bool _isInitialized = false;
  
  // Getters
  int get currentTabIndex => _currentTabIndex;
  bool get isInitialized => _isInitialized;
  
  /// Available OS tabs
  List<String> get availableOS => [
        AppConstants.windowsOS,
        AppConstants.macOS,
        AppConstants.linuxOS,
      ];
  
  /// Get OS display name
  String getOSDisplayName(String os) {
    switch (os.toLowerCase()) {
      case 'windows':
        return 'Windows';
      case 'macos':
        return 'macOS';
      case 'linux':
        return 'Linux';
      default:
        return os.toUpperCase();
    }
  }
  
  /// Set current tab index
  void setCurrentTabIndex(int index) {
    if (index >= 0 && index < availableOS.length && _currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }
  
  /// Get current OS
  String get currentOS => availableOS[_currentTabIndex];
  
  /// Initialize app
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Perform any initialization tasks here
      // For now, just mark as initialized
      await Future.delayed(const Duration(milliseconds: 100));
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to initialize app: $e');
      // Don't prevent app from starting due to initialization errors
      _isInitialized = true;
      notifyListeners();
    }
  }
  
  /// Navigate to specific OS tab
  void navigateToOS(String os) {
    final index = availableOS.indexOf(os.toLowerCase());
    if (index != -1) {
      setCurrentTabIndex(index);
    }
  }
  
  /// Get tab icon for OS - Distinctive and recognizable
  IconData getOSIcon(String os) {
    switch (os.toLowerCase()) {
      case 'windows':
        return Icons.window; // Windows window icon - distinctive
      case 'macos':
        return Icons.apple; // Apple logo - instantly recognizable
      case 'linux':
        return Icons.terminal; // Terminal icon that represents Linux command line - distinctive
      default:
        return Icons.computer;
    }
  }
  
  /// Check if current tab is active
  bool isTabActive(int index) {
    return _currentTabIndex == index;
  }
}
