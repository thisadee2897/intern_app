import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/config/routes/route_config.dart';
import 'package:project/config/routes/route_helper.dart';

class ProjectScreen extends ConsumerStatefulWidget {
  const ProjectScreen({super.key});

  @override
  ConsumerState<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends ConsumerState<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Projects'), shape: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.0))),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: ListView.builder(
            itemCount: 1200,
            itemBuilder: (context, index) {
              return ListTile(
                visualDensity: VisualDensity.compact,
                title: Text('Project Item ${index + 1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('10/20 tasks', style: TextStyle(color: Colors.grey)),
                    Row(
                      children: [
                        SizedBox(width: 80, child: LinearProgressIndicator(value: 0.5, backgroundColor: Colors.grey.shade300, color: Colors.lightBlue)),
                        const SizedBox(width: 8),
                        const Text('50%'),
                      ],
                    ),
                  ],
                ),
                leading: const Icon(Icons.folder, color: Colors.lightBlue),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => ref.goSubPath(Routes.projectDetail),
              );
            },
          ),
        ),
      ),
    );
  }
}
