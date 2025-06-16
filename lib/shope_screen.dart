import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShopeScreen extends StatefulWidget {
  const ShopeScreen({super.key});

  @override
  State<ShopeScreen> createState() => _ShopeScreenState();
}

class _ShopeScreenState extends State<ShopeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shope Screen'), backgroundColor: Colors.red),
      body: Center(
        child: Column(
          children: [
            const Text('Welcome to the Shope Screen!'),
            TextButton(
              onPressed: () {
                // Navigate back to the Home screen
                context.go('/');
              },
              child: const Text('Go Back to Home Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
