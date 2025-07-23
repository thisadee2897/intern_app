import 'package:flutter/material.dart';
import 'package:project/screens/home/providers/apis/delete_workspace_api.dart';
import 'package:project/screens/home/providers/controllers/home_controller.dart';
import 'package:project/screens/home/views/insert_update_workspace_screen.dart';
import 'package:project/utils/extension/async_value_sliver_extension.dart';
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
  Widget buildDesktop(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    return Consumer(
      builder: (context, ref, child) {
        final workspaceState = ref.watch(workspaceProvider);

        return Stack(
          children: [
            // รูปพื้นหลังเต็มหน้าจอ
            Positioned.fill(
              child: Image.network(
                'https://i.pinimg.com/736x/8e/a5/3a/8ea53ad02e66cc60ec4240478ed4c9cb.jpg', // <-- ใส่ลิงก์รูป
                fit: BoxFit.cover, // ให้รูปเต็มจอ
              ),
            ),

            Scaffold(
              backgroundColor: Colors.transparent, // พื้นหลังโปร่งใส
              appBar: AppBar(
                title: const Text(
                  'Workspaces',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 27, 27, 27),
                  ),
                ),
                backgroundColor: const Color.fromARGB(255, 176, 197, 245),
                // ในส่วน appBar.actions ของ HomeScreen
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Color.fromARGB(255, 27, 27, 27),
                    ),
                    tooltip: 'เพิ่ม Workspace',
                    onPressed: () async {
                      final result = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder:
                              (context) => InsertUpdateWorkspaceScreen(
                                workspace: null, // กรณีแก้ไข
                              ),
                        ),
                      );
                      if (result == true) {
                        await ref
                            .read(workspaceProvider.notifier)
                            .fetchWorkspace();
                        print(
                          'เพิ่ม Workspace เรียบร้อยและรีโหลดข้อมูลใหม่แล้ว',
                        );
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, //  จำนวนการ์ดต่อแถว = 3
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio:
                                1.8, //  ปรับอัตราส่วนสี่เหลี่ยม (กว้าง : สูง)
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
                            if (id.isEmpty) {
                              print('id is null or empty');
                              return;
                            }
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
            ),
          ],
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
