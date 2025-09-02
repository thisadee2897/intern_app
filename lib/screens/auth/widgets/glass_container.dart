import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:project/utils/extension/hex_color.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final Border? border;

  const GlassContainer({super.key, required this.child, this.blur = 10.0, this.opacity = 0.2, this.borderRadius, this.border});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            border: border ?? Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class FloatingCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const FloatingCard({super.key, required this.child, this.padding, this.elevation = 8.0, this.backgroundColor, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 50, offset: Offset(5, 10))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.lightBlueAccent]),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [HexColor.fromHex('#002B77'), HexColor.fromHex('#002156'), HexColor.fromHex('#001437')],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(padding: padding ?? const EdgeInsets.all(24), child: child),
            ),
          ),
        ),
      ),
    );
  }
}
