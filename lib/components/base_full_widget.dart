import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'responsive.dart';

abstract class BaseStatefulWidget extends ConsumerStatefulWidget {
  const BaseStatefulWidget({super.key});

  @override
  ConsumerState<BaseStatefulWidget> createState();
}

abstract class BaseState<T extends BaseStatefulWidget> extends ConsumerState<T> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: (sizing) => buildMobile(context, sizing),
      desktop: (sizing) => buildDesktop(context, sizing),
      tablet: (sizing) => buildTablet(context, sizing) ?? buildMobile(context, sizing),
    );
  }

  Widget buildMobile(BuildContext context, SizingInformation sizingInformation);

  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation);

  Widget? buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return null;
  }
}
