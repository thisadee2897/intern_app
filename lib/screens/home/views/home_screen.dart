import 'package:flutter/material.dart';
import 'package:project/screens/home/providers/apis/delete_workspace_api.dart';
import 'package:project/screens/home/providers/controllers/home_controller.dart';
import 'package:project/screens/home/views/insert_update_workspace_screen.dart';
import 'package:project/utils/extension/async_value_sliver_extension.dart';
import 'package:project/components/export.dart';
import 'workspace_card.dart';

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
    return _buildScaffold(context, crossAxisCount: 3, aspectRatio: 1.8);
  }

  @override
  Widget buildTablet(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    return _buildScaffold(context, crossAxisCount: 2, aspectRatio: 1.5);
  }

  @override
  Widget buildMobile(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    return _buildScaffold(context, crossAxisCount: 1, aspectRatio: 1.2);
  }

  Widget _buildScaffold(
    BuildContext context, {
    required int crossAxisCount,
    required double aspectRatio,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final workspaceState = ref.watch(workspaceProvider);

        return Scaffold(
          backgroundColor: Colors.white, //  backgrondColor ของแอปทั้งหน้า
          appBar: AppBar(
            title: const Text(
              'Workspaces',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 27, 27, 27),
              ),
            ),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 16, 18, 37),
                  
                ),
                tooltip: 'Insert Workspace',
                onPressed: () async {
                  final result = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              InsertUpdateWorkspaceScreen(workspace: null),
                    ),
                  );
                  if (mounted && result == true) {
                    await ref.read(workspaceProvider.notifier).fetchWorkspace();
                  }
                },
              ),
            ],
          ),
          body: workspaceState.appWhen(
            dataBuilder: (workspaces) {
              if (workspaces.isEmpty) {
                return const Center(child: Text('ไม่พบ workspace'));
              }
              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: workspaces.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final workspace = workspaces[index];
                    return WorkspaceCard(
                      workspace: workspace,
                      onWorkspaceChanged: () async {
                        await ref
                            .read(workspaceProvider.notifier)
                            .fetchWorkspace();
                      },
                      onDeleteWorkspace: (String id) async {
                        if (id.isEmpty) return;
                        await ref.read(apiDeleteWorkspace).delete(id: id);
                        await ref
                            .read(workspaceProvider.notifier)
                            .fetchWorkspace();
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
