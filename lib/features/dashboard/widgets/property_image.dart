import 'package:flutter/material.dart';

/// Renders a bundled property photo, falling back to the generic homepage
/// photo if the given asset path is ever missing.
class PropertyImage extends StatelessWidget {
  const PropertyImage({super.key, required this.path, this.fit = BoxFit.cover, this.width, this.height});

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder:
          (context, error, stackTrace) =>
              Image.asset('assets/images/homepage.jpg', fit: fit, width: width, height: height),
    );
  }
}
