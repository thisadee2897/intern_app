import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/home_screen.dart';
import 'package:project/login.dart';
import 'package:project/shope_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          name: 'home', // Optional, add name to your routes. Allows you navigate by name instead of path
          path: '/home',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          name: 'login', // Optional, add name to your routes. Allows you navigate by name instead of path
          path: '/login',
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(name: 'shope', path: '/shope', builder: (context, state) => ShopeScreen()),
      ],
    );
    return MaterialApp.router(routerConfig: _router, theme: ThemeData(primarySwatch: Colors.blue));
  }
}
