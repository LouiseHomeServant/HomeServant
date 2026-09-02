import 'package:flutter/material.dart';

/// Quity (primary/display) paired with Givonic (secondary/accent), matching
/// the wordmark and headings from the brand's font pairing.
class AppTextStyles {
  AppTextStyles._();

  static const String primaryFont = 'Quity';
  static const String accentFont = 'Givonic';

  static TextStyle display({required Color color, double size = 34}) =>
      TextStyle(
        fontFamily: primaryFont,
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w600,
        height: 1.05,
      );

  static TextStyle heading({required Color color, double size = 26}) =>
      TextStyle(
        fontFamily: primaryFont,
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w500,
      );

  static TextStyle body({
    required Color color,
    double size = 15,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
    fontFamily: primaryFont,
    color: color,
    fontSize: size,
    fontWeight: weight,
  );

  static TextStyle button({required Color color, double size = 16}) =>
      TextStyle(
        fontFamily: accentFont,
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w700,
      );
}
