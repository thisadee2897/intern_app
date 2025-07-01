import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'widgets/ui_desktop.dart';

class HomeScreen extends BaseStatefulWidget {
  const HomeScreen({super.key});
  @override
  BaseState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {
  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return const HomeDesktopUI();
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return Center(
      child: Text(
        'Tablet View',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return Center(
      child: Text(
        'Mobile View',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
