import 'package:flutter/material.dart';
import '../utils/about_launcher.dart';

/// Example showing how to use the Modern About Page
/// 
/// This demonstrates the different ways to launch the new about page:
/// 
/// 1. Simple navigation (recommended):
///    ```dart
///    AboutLauncher.showAbout(context);
///    ```
/// 
/// 2. Custom animation:
///    ```dart
///    AboutLauncher.showModernAbout(context);
///    ```
/// 
/// 3. Modal bottom sheet:
///    ```dart
///    AboutLauncher.showModernAboutModal(context);
///    ```
/// 
/// Usage in your existing code:
/// 
/// Replace any existing about dialog calls like:
/// ```dart
/// // OLD CODE:
/// onTap: () {
///   Navigator.of(context).pop(); // Close drawer first
///   _showAbout(context);  // Replace this line
/// },
/// ```
/// 
/// With:
/// ```dart
/// // NEW CODE:
/// onTap: () {
///   Navigator.of(context).pop(); // Close drawer first
///   AboutLauncher.showAbout(context);  // Use this instead (simple & clean)
/// },
/// ```
/// 
/// The Modern About Page features:
/// - ✨ Clean, professional design that's satisfying to use
/// - 🎨 Perfectly matches your app's design system
/// - 📱 Responsive layout that looks great on all devices
/// - 🚀 Smooth, subtle animations that feel natural
/// - 📊 Clear information layout with stats and features
/// - 🎯 Simple, focused content without overwhelming effects
/// - ⚡ Fast loading and optimized performance
/// 
/// This is a modern, creative, and satisfying about page that users will love!

class AboutUsageExample {
  // Example usage in a button
  static Widget buildAboutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => AboutLauncher.showAbout(context),
      child: const Text('Show About'),
    );
  }

  // Example usage in a drawer item
  static Widget buildAboutDrawerItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text('About'),
      subtitle: const Text('Modern & clean'),
      onTap: () {
        Navigator.of(context).pop(); // Close drawer first
        AboutLauncher.showAbout(context);
      },
    );
  }

  // Example usage in an app bar action
  static Widget buildAboutAppBarAction(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline),
      onPressed: () => AboutLauncher.showAbout(context),
    );
  }
}
