import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/config/routes/boxmain.dart';
import 'package:project/config/routes/route_config.dart';
import 'package:project/screens/contact_us/views/contact_us_screen.dart';
import 'package:project/screens/documentation/views/documetation_screen.dart';
import 'package:project/screens/home/views/home_screen.dart';
import 'package:project/screens/auth/view/login.dart';
import 'package:project/screens/product_update/view/product_updat_screen.dart';
import 'package:project/screens/project/project_datail/views/project_detail_screen.dart';
import 'package:project/screens/project/views/project_screen.dart';
import 'package:project/screens/settings/profile/view/profile_screen.dart';
import 'package:project/screens/settings/views/setting_screen.dart';
import 'package:project/utils/services/local_storage_service.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>();
final _shellNavigatorProjectKey = GlobalKey<NavigatorState>();
final _shellNavigatorSettingsKey = GlobalKey<NavigatorState>();
final _shellNavigatorContactUsKey = GlobalKey<NavigatorState>();
final _shellNavigatorproductupdate = GlobalKey<NavigatorState>();
final _shellNavigatorDocumentationKey = GlobalKey<NavigatorState>();
final appRouterProvider = Provider<GoRouter>((ref) {
  ref.read(localStorageServiceProvider).getUserLogin();
  return GoRouter(
    redirect: (context, state)async {
      //ถ้า Token ไม่มีให้ไปหน้า Login
      String? token = await ref.read(localStorageServiceProvider).getToken();
      var currentPath = state.fullPath;
      if (token == null || token.isEmpty) {
        if (currentPath != Routes.login) {
          return Routes.login;
        }
      } else {
        //ถ้า Token มีให้ไปหน้า Home
        if (currentPath == Routes.login) {
          return Routes.home;
        }
      }
      return null;
    },
    initialLocation: Routes.login,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: GestureDetector(onTap: () => FocusScope.of(_rootNavigatorKey.currentContext!).unfocus(), child: const LoginScreen()),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final scaffold = Scaffold(
                resizeToAvoidBottomInset: false,
                body: FadeTransition(
                  opacity: animation.drive(Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut))),
                  child: ScaleTransition(
                    scale: animation.drive(Tween(begin: 0.9, end: 1.0).chain(CurveTween(curve: Curves.easeInOut))),
                    child: const LoginScreen(),
                  ),
                ),
              );
              return scaffold;
            },
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithAppbar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [GoRoute(path: Routes.home, pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()))],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProjectKey,
            routes: [
              GoRoute(
                path: Routes.project,
                pageBuilder: (context, state) => const NoTransitionPage(child: ProjectScreen()),
                routes: [
                  GoRoute(
                    path: Routes.projectDetail,
                    pageBuilder: (context, state) => NoTransitionPage(child: ProjectDetailScreen()),
                    routes: [GoRoute(path: Routes.projectDetail, pageBuilder: (context, state) => NoTransitionPage(child: ProjectDetailScreen()))],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettingsKey,
            routes: [
              GoRoute(
                path: Routes.setting,
                pageBuilder: (context, state) => NoTransitionPage(child: SettingScreen()),
                routes: [
                  GoRoute(
                    path: 'profile',
                    pageBuilder: (context, state) => NoTransitionPage(child: ProfileScreen()),
                  ),
                ],
                //   GoRoute(
                //     path: Routes.appointmentDetail,
                //     pageBuilder: (context, state) => const NoTransitionPage(child: AppointmentDetailScreen()),
                //     routes: const [],
                //   ),
                // ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorContactUsKey,
            routes: [
              GoRoute(
                path: Routes.contactUs,
                pageBuilder: (context, state) => NoTransitionPage(child: ContactUsScreen()),
                // routes: [
                //   GoRoute(
                //     path: Routes.appointmentDetail,
                //     pageBuilder: (context, state) => const NoTransitionPage(child: AppointmentDetailScreen()),
                //     routes: const [],
                //   ),
                // ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorproductupdate,
            routes: [
              GoRoute(
                path: Routes.productUpdate,
                pageBuilder: (context, state) => NoTransitionPage(child: ProductUpdatScreen()),
                // routes: [
                //   GoRoute(
                //     path: Routes.appointmentDetail,
                //     pageBuilder: (context, state) => const NoTransitionPage(child: AppointmentDetailScreen()),
                //     routes: const [],
                //   ),
                // ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDocumentationKey,
            routes: [
              GoRoute(
                path: Routes.documentation,
                pageBuilder: (context, state) => NoTransitionPage(child: DocumetationScreen()),
                // routes: [
                //   GoRoute(
                //     path: Routes.appointmentDetail,
                //     pageBuilder: (context, state) => const NoTransitionPage(child: AppointmentDetailScreen()),
                //     routes: const [],
                //   ),
                // ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
