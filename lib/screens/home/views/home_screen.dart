import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:project/config/routes/app_router.dart';
import 'package:project/config/routes/route_config.dart';
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

class _HomeScreenState extends BaseState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    // Start animation when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget buildDesktop(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    return _buildScaffold(context, crossAxisCount: 4, aspectRatio: 1.8);
  }

  @override
  Widget buildTablet(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    return _buildScaffold(context, crossAxisCount: 3, aspectRatio: 1.5);
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
        if (workspaceState.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            return ref.read(appRouterProvider).go(Routes.login);
          });
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade50,
                  Colors.purple.shade50,
                  Colors.pink.shade50,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: workspaceState.appWhen(
              dataBuilder: (workspaces) {
                if (workspaces.isEmpty) {
                  return const Center(child: Text('ไม่พบ workspace'));
                }
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: aspectRatio,
                        ),
                        itemCount: workspaces.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // ปุ่มสร้าง Workspace อยู่ที่ index แรก
                            // return DottedBorder(
                            //   options: RoundedRectDottedBorderOptions(color: Colors.grey, dashPattern: const [6, 3], radius: Radius.circular(20)),
                            //   child: InkWell(
                            //     onTap: () {},
                            //     child: Container(
                            //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey.shade100),
                            //       child: Center(child: Icon(Icons.add, size: 50, color: Colors.grey)),
                            //     ),
                            //   ),
                            // );
                            return DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                color: Colors.grey,
                                dashPattern: const [6, 3],
                                radius: Radius.circular(20),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  final result = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) =>
                                            const InsertUpdateWorkspaceDialog(),
                                  );

                                  if (result == true) {
                                    // รีเฟรช workspace list
                                    ref.invalidate(workspaceProvider);
                                  }
                                },

                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.shade100,
                                  ),

                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // รายการ Workspace อื่นๆ จะเริ่มจาก index 1
                            final workspace =
                                workspaces[index -
                                    1]; // ดึงข้อมูลจาก workspaces โดยใช้ index - 1
                            // คำนวณ animation delay
                            final delay = ((index - 1) * 0.1).clamp(0.0, 0.8);
                            final animation = Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  delay,
                                  (delay + 0.3).clamp(0.0, 1.0),
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                            );
                            return AnimatedBuilder(
                              animation: animation,
                              builder: (context, child) {
                                final animValue = animation.value.clamp(
                                  0.0,
                                  1.0,
                                );
                                return Transform.translate(
                                  offset: Offset(0, 30 * (1 - animValue)),
                                  child: Opacity(
                                    opacity: animValue,
                                    child: Transform.scale(
                                      scale: (0.8 + (0.2 * animValue)).clamp(
                                        0.0,
                                        1.0,
                                      ),
                                      child: WorkspaceCard(
                                        workspace,
                                        title: workspace.name ?? 'ไม่มีชื่อ',
                                        color:
                                            Colors
                                                .primaries[(index - 1) %
                                                    Colors.primaries.length]
                                                .shade400,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
