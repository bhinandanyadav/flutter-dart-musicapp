import 'package:flutter/material.dart';

/// Helper extension for Color to handle opacity in a backward-compatible way
extension ColorOpacity on Color {
  /// Replacement for deprecated withOpacity method
  Color withOpacityCompat(double opacity) {
    return withValues(alpha: opacity);
  }
}
