import 'package:flutter/material.dart';
import '../utils/about_launcher.dart';

/// Example showing how to use the Revolutionary About Page
/// 
/// This demonstrates the different ways to launch the new about page:
/// 
/// 1. Full screen navigation:
///    ```dart
///    AboutLauncher.showRevolutionaryAbout(context);
///    ```
/// 
/// 2. Modal bottom sheet:
///    ```dart
///    AboutLauncher.showRevolutionaryAboutModal(context);
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
///   AboutLauncher.showRevolutionaryAbout(context);  // Use this instead
/// },
/// ```
/// 
/// The Revolutionary About Page features:
/// - 🚀 Ultra-premium design with holographic effects
/// - 🎨 Matches your app's purple/blue theme perfectly
/// - ✨ Advanced animations and particle effects
/// - 🌟 Modern glassmorphism and gradient effects
/// - 💎 Premium statistics and feature sections
/// - 🎪 Revolutionary background animations
/// - 🔥 Smooth transitions and micro-interactions
/// 
/// This is the most creative and modern about page ever created!

class AboutUsageExample {
  // Example usage in a button
  static Widget buildAboutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => AboutLauncher.showRevolutionaryAbout(context),
      child: const Text('Show Revolutionary About'),
    );
  }

  // Example usage in a drawer item
  static Widget buildAboutDrawerItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text('About'),
      subtitle: const Text('Revolutionary & modern'),
      onTap: () {
        Navigator.of(context).pop(); // Close drawer first
        AboutLauncher.showRevolutionaryAbout(context);
      },
    );
  }

  // Example usage in an app bar action
  static Widget buildAboutAppBarAction(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline),
      onPressed: () => AboutLauncher.showRevolutionaryAbout(context),
    );
  }
}
