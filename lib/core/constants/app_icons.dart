import 'package:flutter/material.dart';

/// Application icons
class AppIcons {
  // Navigation icons
  static const IconData windows = Icons.laptop_windows;
  static const IconData macOS = Icons.laptop_mac;
  static const IconData linux = Icons.computer;
  static const IconData settings = Icons.settings;
  
  // Action icons
  static const IconData search = Icons.search;
  static const IconData favorite = Icons.favorite;
  static const IconData favoriteBorder = Icons.favorite_border;
  static const IconData share = Icons.share;
  static const IconData copy = Icons.copy;
  
  // UI icons
  static const IconData back = Icons.arrow_back;
  static const IconData forward = Icons.arrow_forward;
  static const IconData close = Icons.close;
  static const IconData menu = Icons.menu;
  static const IconData more = Icons.more_vert;
  
  // Theme icons
  static const IconData lightMode = Icons.light_mode;
  static const IconData darkMode = Icons.dark_mode;
  static const IconData autoMode = Icons.brightness_auto;
  
  // Content icons
  static const IconData info = Icons.info_outline;
  static const IconData warning = Icons.warning_amber_outlined;
  static const IconData error = Icons.error_outline;
  static const IconData success = Icons.check_circle_outline;
  
  // Media icons
  static const IconData image = Icons.image;
  static const IconData video = Icons.play_circle_outline;
  static const IconData gif = Icons.gif;
  
  // OS specific icons
  static const IconData keyboard = Icons.keyboard;
  static const IconData mouse = Icons.mouse;
  static const IconData terminal = Icons.terminal;
  static const IconData folder = Icons.folder_outlined;
  static const IconData file = Icons.description_outlined;
  
  /// Get OS specific icon
  static IconData getOSIcon(String os) {
    switch (os.toLowerCase()) {
      case 'windows':
        return windows;
      case 'macos':
        return macOS;
      case 'linux':
        return linux;
      default:
        return computer;
    }
  }
  
  static const IconData computer = Icons.computer;
}
