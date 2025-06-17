import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/export.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  const ProjectDetailScreen({super.key});

  @override
  ConsumerState<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // จำนวนแท็บ
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Project Detail'),
          shape: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.0)),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'Summary'),
              Tab(icon: Icon(Icons.table_rows_outlined), text: 'Backlog'),
              Tab(
                //angle 90 องศา
                icon: Transform.rotate(angle: 1.55, child: Icon(Icons.table_rows_outlined)), // ใช้ Transform.rotate เพื่อหมุนไอคอน
                text: 'Board',
              ),
              Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
            ],
          ),
        ),
        body: TabBarView(children: [SummaryWidget(), BacklogWidget(), BoardWidget(), TimelineWidget()]),
      ),
    );
  }
}
