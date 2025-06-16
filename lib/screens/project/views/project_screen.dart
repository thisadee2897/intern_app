import 'package:flutter/material.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Projects')), body: Center(child: Text('Projects Screen', style: Theme.of(context).textTheme.labelLarge)));
  }
}
