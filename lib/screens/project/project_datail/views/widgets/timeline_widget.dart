import 'package:flutter/material.dart';
import 'package:project/components/export.dart';

class TimelineWidget extends BaseStatefulWidget {
  const TimelineWidget({super.key});
  @override
  BaseState<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends BaseState<TimelineWidget> {
  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return Container(color: Colors.amber[50], child: Center(child: Text('Desktop View', style: Theme.of(context).textTheme.titleLarge)));
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Tablet View', style: Theme.of(context).textTheme.titleLarge));
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Mobile View', style: Theme.of(context).textTheme.titleLarge));
  }
}
