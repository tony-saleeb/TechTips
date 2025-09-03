import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/viewmodels/settings_viewmodel.dart';

/// Device categories for responsive sizing
enum DeviceCategory {
  smallPhone,   // < 360px
  mediumPhone,  // 360-400px
  largePhone,   // 400-600px
  tablet,       // 600-900px
  smallDesktop, // 900-1200px
  largeDesktop, // 1200px+
}

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
  /// Get device category based on screen width
  DeviceCategory get deviceCategory {
    final width = screenWidth;
    if (width < 360) return DeviceCategory.smallPhone;
    if (width < 400) return DeviceCategory.mediumPhone;
    if (width < 600) return DeviceCategory.largePhone;
    if (width < 900) return DeviceCategory.tablet;
    if (width < 1200) return DeviceCategory.smallDesktop;
    return DeviceCategory.largeDesktop;
  }
  
  /// Get scaling factor based on device category and user preference
  double get scaleFactor {
    // Get user's appearance size preference from settings with listening
    double userScaleFactor = 1.0;
    try {
      final settingsViewModel = Provider.of<SettingsViewModel>(this, listen: true);
      userScaleFactor = settingsViewModel.appearanceSize;
    } catch (e) {
      // If settings not available, use default
      userScaleFactor = 1.0;
    }
    
    // Combine device category scaling with user preference
    double deviceScaleFactor;
    switch (deviceCategory) {
      case DeviceCategory.smallPhone:
        deviceScaleFactor = 0.8;
        break;
      case DeviceCategory.mediumPhone:
        deviceScaleFactor = 0.9;
        break;
      case DeviceCategory.largePhone:
        deviceScaleFactor = 1.0;
        break;
      case DeviceCategory.tablet:
        deviceScaleFactor = 1.1;
        break;
      case DeviceCategory.smallDesktop:
        deviceScaleFactor = 1.2;
        break;
      case DeviceCategory.largeDesktop:
        deviceScaleFactor = 1.3;
        break;
    }
    
    return deviceScaleFactor * userScaleFactor;
  }
  
  /// Responsive font size
  double rs(double baseSize) => baseSize * scaleFactor;
  
  /// Responsive padding
  double rp(double basePadding) => basePadding * scaleFactor;
  
  /// Responsive margin
  double rm(double baseMargin) => baseMargin * scaleFactor;
  
  /// Responsive icon size
  double ri(double baseIconSize) => baseIconSize * scaleFactor;
  
  /// Responsive border radius
  double rbr(double baseRadius) => baseRadius * scaleFactor;
  
  /// Responsive height
  double rh(double baseHeight) => baseHeight * scaleFactor;
  
  /// Responsive width
  double rw(double baseWidth) => baseWidth * scaleFactor;
  
  /// Responsive spacing
  double rsp(double baseSpacing) => baseSpacing * scaleFactor;
  
  /// Responsive edge insets
  EdgeInsets re(double basePadding) => EdgeInsets.all(basePadding * scaleFactor);
  
  /// Responsive symmetric edge insets
  EdgeInsets rse({double? horizontal, double? vertical}) {
    return EdgeInsets.symmetric(
      horizontal: (horizontal ?? 0) * scaleFactor,
      vertical: (vertical ?? 0) * scaleFactor,
    );
  }
  
  /// Responsive only edge insets
  EdgeInsets ro({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: (left ?? 0) * scaleFactor,
      top: (top ?? 0) * scaleFactor,
      right: (right ?? 0) * scaleFactor,
      bottom: (bottom ?? 0) * scaleFactor,
    );
  }
  
  /// Responsive sized box
  Widget rsb({double? width, double? height}) {
    return SizedBox(
      width: width != null ? width * scaleFactor : null,
      height: height != null ? height * scaleFactor : null,
    );
  }
  
  /// Responsive container with custom padding
  Widget rcc(Widget child, {EdgeInsets? padding}) {
    if (padding == null) return child;
    return Container(
      padding: EdgeInsets.only(
        left: padding.left * scaleFactor,
        top: padding.top * scaleFactor,
        right: padding.right * scaleFactor,
        bottom: padding.bottom * scaleFactor,
      ),
      child: child,
    );
  }
  
  /// Responsive grid layout helper
  int get responsiveGridColumns {
    switch (deviceCategory) {
      case DeviceCategory.smallPhone:
        return 1;
      case DeviceCategory.mediumPhone:
        return 1;
      case DeviceCategory.largePhone:
        return 2;
      case DeviceCategory.tablet:
        return 3;
      case DeviceCategory.smallDesktop:
        return 4;
      case DeviceCategory.largeDesktop:
        return 5;
    }
  }
  
  /// Responsive aspect ratio for cards
  double get responsiveCardAspectRatio {
    switch (deviceCategory) {
      case DeviceCategory.smallPhone:
        return 1.2;
      case DeviceCategory.mediumPhone:
        return 1.3;
      case DeviceCategory.largePhone:
        return 1.4;
      case DeviceCategory.tablet:
        return 1.5;
      case DeviceCategory.smallDesktop:
        return 1.6;
      case DeviceCategory.largeDesktop:
        return 1.7;
    }
  }
  
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
