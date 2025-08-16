import 'package:flutter/animation.dart';

/// Extension to safely check if AnimationController is disposed
extension AnimationControllerExtension on AnimationController {
  /// Check if the animation controller is disposed
  bool get isDisposed {
    try {
      // Try to access a property that would throw if disposed
      status;
      return false;
    } catch (e) {
      return true;
    }
  }
  
  /// Safely forward the animation
  void safeForward() {
    if (!isDisposed) {
      forward();
    }
  }
  
  /// Safely reverse the animation
  void safeReverse() {
    if (!isDisposed) {
      reverse();
    }
  }
  
  /// Safely reset the animation
  void safeReset() {
    if (!isDisposed) {
      reset();
    }
  }
}
