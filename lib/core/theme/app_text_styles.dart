import 'package:flutter/material.dart';

/// Givonic is the app's general-purpose text face; Quity is reserved for
/// headings only.
class AppTextStyles {
  AppTextStyles._();

  static const String headingFont = 'Quity';
  static const String bodyFont = 'Givonic';

  static TextStyle display({required Color color, double size = 34}) =>
      TextStyle(
        fontFamily: bodyFont,
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w600,
        height: 1.05,
      );

  static TextStyle heading({required Color color, double size = 26}) =>
      TextStyle(
        fontFamily: headingFont,
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w500,
      );

  static TextStyle body({
    required Color color,
    double size = 15,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
    fontFamily: bodyFont,
    color: color,
    fontSize: size,
    fontWeight: weight,
  );

  static TextStyle button({required Color color, double size = 16}) =>
      TextStyle(
        fontFamily: bodyFont,
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w700,
      );
}
