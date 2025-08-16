import 'package:flutter/material.dart';

/// Extension methods for enhanced functionality
extension StringExtensions on String {
  /// Capitalize first letter of each word
  String get titleCase {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }
  
  /// Check if string is a valid search query
  bool get isValidSearchQuery {
    return trim().length >= 2;
  }
  
  /// Convert OS name to display name
  String get osDisplayName {
    switch (toLowerCase()) {
      case 'windows':
        return 'Windows';
      case 'macos':
        return 'macOS';
      case 'linux':
        return 'Linux';
      default:
        return titleCase;
    }
  }
}

extension ListExtensions<T> on List<T> {
  /// Safely get element at index
  T? elementAtOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
}

extension BuildContextExtensions on BuildContext {
  /// Get theme data
  ThemeData get theme => Theme.of(this);
  
  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;
  
  /// Get text theme
  TextTheme get textTheme => theme.textTheme;
  
  /// Get media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  /// Get screen size
  Size get screenSize => mediaQuery.size;
  
  /// Get screen width
  double get screenWidth => screenSize.width;
  
  /// Get screen height
  double get screenHeight => screenSize.height;
  
  /// Check if device is in dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;
  
  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? theme.colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  /// Navigate to route
  Future<T?> pushRoute<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute<T>(builder: (_) => page),
    );
  }
  
  /// Navigate and replace current route
  Future<T?> pushReplacementRoute<T>(Widget page) {
    return Navigator.of(this).pushReplacement<T, void>(
      MaterialPageRoute<T>(builder: (_) => page),
    );
  }
  
  /// Pop current route
  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }
}
