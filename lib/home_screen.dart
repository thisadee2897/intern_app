import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen'),
      backgroundColor: Colors.amber,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            // Navigate to the login screen
            context.go('/login');
          },
        ),
      ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Home Screen!'),
            ElevatedButton(
              onPressed: () {
                context.go('/shope');
              },
              child: const Text('Go to Shope Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
