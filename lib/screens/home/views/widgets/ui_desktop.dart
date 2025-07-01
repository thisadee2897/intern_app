import 'package:flutter/material.dart';

class HomeDesktopUI extends StatefulWidget {
  const HomeDesktopUI({super.key});

  @override
  State<HomeDesktopUI> createState() => _HomeDesktopUIState();
}

class _HomeDesktopUIState extends State<HomeDesktopUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(
        child: Text(
          'Desktop View',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}