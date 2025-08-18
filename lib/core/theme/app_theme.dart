import 'package:flutter/material.dart';

class AppTheme {
  /// Returns the light theme configuration.
  static ThemeData lightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // Add additional light theme settings (fonts, icon themes, etc.)
    );
  }

  /// Returns the dark theme configuration.
  static ThemeData darkTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // Add additional dark theme settings
    );
  }
}