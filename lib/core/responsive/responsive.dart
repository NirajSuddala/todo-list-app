import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  Responsive(this.context);

  /// Returns the screen width.
  double get width => MediaQuery.of(context).size.width;

  /// Returns the screen height.
  double get height => MediaQuery.of(context).size.height;

  /// Returns true if the device is mobile (width < 600).
  bool get isMobile => width < 600;

  /// Returns true if the device is a tablet (600 <= width < 1100).
  bool get isTablet => width >= 600 && width < 1100;

  /// Returns true if the device is desktop (width >= 1100).
  bool get isDesktop => width >= 1100;

  /// Returns a width percentage (e.g., 50% of the screen width).
  double wp(double percentage) => width * percentage / 100;

  /// Returns a height percentage (e.g., 50% of the screen height).
  double hp(double percentage) => height * percentage / 100;
}
  