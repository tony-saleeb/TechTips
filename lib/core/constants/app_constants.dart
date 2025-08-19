/// Application-wide constants
class AppConstants {
  static const String appName = 'TechTips';
  static const String appDescription = 'OS Tips & Tricks for Power Users';
  
  // Storage keys
  static const String themeKey = 'theme_mode';
  static const String fontSizeKey = 'font_size';
  static const String favoritesKey = 'favorites';
  
  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // API endpoints (for future use)
  static const String baseUrl = 'https://api.techshortcuts.com';
  static const String tipsEndpoint = '/tips';
  
  // OS Categories
  static const String windowsOS = 'windows';
  static const String macOS = 'macos';
  static const String linuxOS = 'linux';
  
  // Default values
  static const double defaultFontSize = 14.0;
  static const double minFontSize = 12.0;
  static const double maxFontSize = 20.0;
}
