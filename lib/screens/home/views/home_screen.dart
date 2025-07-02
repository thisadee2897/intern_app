import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/home/providers/home_providers.dart';
import 'widgets/ui_desktop.dart';

class HomeScreen extends BaseStatefulWidget {
  const HomeScreen({super.key});
  @override
  BaseState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {
  @override
  Widget buildDesktop(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    return Consumer(
      builder: (context, ref, _) {
        final workspaceState = ref.watch(homeProvider);

        return workspaceState.when(
          data: (workspaces) {
            if (workspaces.isEmpty) {
              return const Center(child: Text('No workspace data'));
            }
            // ตัวอย่าง: แสดง workspace แรก (หรือวนลูปแสดงทั้งหมดก็ได้)
            return HomeDesktopUI(workspace: workspaces.first);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        );
      },
    );
  }

  @override
  Widget buildTablet(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    return Center(
      child: Text('Tablet View', style: Theme.of(context).textTheme.titleLarge),
    );
  }

  @override
  Widget buildMobile(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    return Center(
      child: Text('Mobile View', style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
