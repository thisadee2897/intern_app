import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  AppDestination(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month_rounded, label: 'Projects'),
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
            NavigationRail(
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _onTap,
              labelType: NavigationRailLabelType.all,
              destinations:
                  appDestinations.map((e) => NavigationRailDestination(icon: Icon(e.icon), selectedIcon: Icon(e.activeIcon), label: Text(e.label))).toList(),
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

  void _onTap(int index) {
    widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
  }
}
