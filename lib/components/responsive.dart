import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

typedef SizingBuilder = Widget Function(SizingInformation sizingInformation);

class Responsive extends StatelessWidget {
  final SizingBuilder mobile;
  final SizingBuilder? tablet;
  final SizingBuilder desktop;

  const Responsive({super.key, required this.mobile, this.tablet, required this.desktop});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      // If our width is more than 1100 then we consider it a desktop
      builder: (context, sizing) {
        if (sizing.isDesktop) {
          return Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1200), child: desktop(sizing)));
        }
        // If width it less then 1100 and more then 650 we consider it as tablet
        else if (sizing.isTablet) {
          return tablet == null ? desktop(sizing) : tablet!(sizing);
        }
        // Or less then that we called it mobile
        else {
          return mobile(sizing);
        }
      },
    );
  }
}
