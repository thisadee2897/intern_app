
import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
class ExampleScreen extends BaseStatefulWidget {
  const ExampleScreen({super.key});
  @override
  BaseState<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends BaseState<ExampleScreen> {
  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Desktop View', style: Theme.of(context).textTheme.titleLarge));
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
