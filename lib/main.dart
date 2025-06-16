import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intern_app/home_screen.dart';
import 'package:intern_app/shope_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          name: 'home', // Optional, add name to your routes. Allows you navigate by name instead of path
          path: '/',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(name: 'shope', path: '/shope', builder: (context, state) => ShopeScreen()),
      ],
    );
    return MaterialApp.router(routerConfig: _router);
  }
}
