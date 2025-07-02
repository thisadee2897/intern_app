import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/home/providers/controllers/home_controller.dart';
import 'workspace_card.dart';
import 'package:project/components/export.dart';
//import 'package:project/models/workspace_model.dart';

class HomeScreen extends BaseStatefulWidget {
  const HomeScreen({super.key});
  @override
  BaseState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {
  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return Consumer(
      builder: (context, ref, child) {
        final workspaceState = ref.watch(workspaceProvider);

        return Scaffold(
          appBar: AppBar(title: const Text('Workspaces')),
          backgroundColor: const Color.fromARGB(255, 55, 57, 62),
          body: workspaceState.when(
            data: (workspaces) {
              if (workspaces.isEmpty) {
                return const Center(child: Text('ไม่พบ workspace'));
              }
              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: workspaces.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,         //  จำนวนการ์ดต่อแถว = 3
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.8,     //  ปรับอัตราส่วนสี่เหลี่ยม (กว้าง : สูง)
                  ),
                  itemBuilder: (context, index) {
                    final workspace = workspaces[index];
                    return WorkspaceCard(workspace: workspace);
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('เกิดข้อผิดพลาด: $error')),
          ),
        );
      },
    );
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
