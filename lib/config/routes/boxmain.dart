import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:project/config/routes/route_config.dart';
import 'package:project/screens/auth/providers/controllers/auth_controller.dart';
import 'package:project/screens/project/project_datail/views/widgets/backlog_widget.dart';

final isShowButtomNavigationBar = StateProvider<bool>((ref) => true);

class AppDestination {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const AppDestination({required this.icon, required this.activeIcon, required this.label});
}

// ใช้ชุดเดียวกันทั้ง BottomNav และ NavigationRail
const List<AppDestination> appDestinations = [
  AppDestination(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
  AppDestination(icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded, label: 'Settings'),
];

class ScaffoldWithAppbar extends ConsumerStatefulWidget {
  const ScaffoldWithAppbar({Key? key, required this.navigationShell}) : super(key: key ?? const ValueKey('ScaffoldWithAppbar'));

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ScaffoldWithAppbar> createState() => _ScaffoldWithAppbarState();
}

class _ScaffoldWithAppbarState extends ConsumerState<ScaffoldWithAppbar> {
  @override
  Widget build(BuildContext context) {
    final showBottomBar = ref.watch(isShowButtomNavigationBar);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Row(
        children: [
          if (!isSmallScreen && showBottomBar)
            Container(
              decoration: BoxDecoration(color: Colors.white, border: Border(right: BorderSide(color: Colors.grey.shade300, width: 1.0))),
              child: Column(
                children: [
                  Expanded(
                    child: NavigationRail(
                      indicatorShape: const CircleBorder(side: BorderSide(color: Colors.transparent, width: 0.0)),
                      selectedIndex: widget.navigationShell.currentIndex,
                      onDestinationSelected: _onTap,
                      labelType: NavigationRailLabelType.all,
                      destinations:
                          appDestinations
                              .map((e) => NavigationRailDestination(icon: Icon(e.icon), selectedIcon: Icon(e.activeIcon), label: Text(e.label)))
                              .toList(),
                    ),
                  ),
                  //Logout Button
                  IconButton(
                    icon: const Icon(Icons.logout),
                    // onPressed: () => _handleLogout(),
                    onPressed: () async {
                      try {
                        await ref.read(logoutProvider.future);
                        if (context.mounted) {
                          context.go(Routes.login);
                        }
                      } catch (e, stx) {
                        print(stx);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar:
          isSmallScreen && showBottomBar
              ? BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: widget.navigationShell.currentIndex,
                onTap: _onTap,
                items: appDestinations.map((e) => BottomNavigationBarItem(icon: Icon(e.icon), activeIcon: Icon(e.activeIcon), label: e.label)).toList(),
              )
              : null,
    );
  }

  /// จัดการการจบ Sprint
  Future<void> _handleLogout() async {
    // final formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            var nextSprint = ref.watch(selectNextSprint);
            // var nextSprintList = ref.watch(dropDownSprintFormCompleteProvider);
            return Center(
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                height: 650,
                width: 500,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          ),
                        ),
                        const Gap(20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Complete assaSCRUM Sprint 4', style: Theme.of(context).textTheme.titleLarge),
                              const Gap(20),
                              Text('This sprint contains 0 completed work items and 10 open work items.'),
                              Text("Completed work items includes everything in the last column on the board, Done. "),
                              Text("Open work items includes everything from any other column on the board. Move these to a new sprint or the backlog."),
                              Gap(20),
                              Text('Move open work items to next sprint or backlog', style: Theme.of(context).textTheme.titleMedium),
                              const Gap(10),
                              // Material(
                              //   child: SizedBox(
                              //     width: 500,
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: nextSprintList.when(
                              //         data: (data) {
                              //           return DropdownButtonFormField<SprintModel>(
                              //             borderRadius: BorderRadius.circular(8),
                              //             isExpanded: true,
                              //             value: nextSprint,
                              //             items:
                              //                 data.map((item) {
                              //                   return DropdownMenuItem<SprintModel>(
                              //                     value: item,
                              //                     child: Text(item.name ?? 'No name', style: const TextStyle(fontSize: 14)),
                              //                   );
                              //                 }).toList(),
                              //             onChanged: (item) {
                              //               // ref.read(selectNextSprint.notifier).state = item;
                              //             },
                              //           );
                              //         },
                              //         error: (_, __) => Text('Error loading next sprint', style: TextStyle(color: Colors.red)),
                              //         loading: () => const Center(child: CircularProgressIndicator()),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                height: 100,
                                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                              ),
                            ],
                          ),
                        ),
                        // Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                              FilledButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  // try {
                                  //   await ref
                                  //       .read(updateSprintToCompleteProvider.notifier)
                                  //       .updateComplete(sprintCompleteId: item.id!, moveTaskToSprintId: nextSprint!.id!);
                                  //   if (!mounted) return;

                                  //   _showSuccessSnackBar('Sprint completed successfully');
                                  // } catch (e) {
                                  //   _showErrorSnackBar('Error completing sprint: ${e.toString()}');
                                  // }
                                },
                                child: const Text('Complete', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: Image.asset('assets/images/complete.png', width: 120, height: 120, fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
  }
}
