// 📁 project_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/project/project_datail/providers/controllers/task_controller.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'widgets/export.dart';
import 'package:project/screens/project/project_datail/gantt_chart/views/widgets/gantt_app_widget.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  @override
  void initState() {
    super.initState();

    // ตั้งค่า projectId ใน provider
    ref.read(selectProjectIdProvider.notifier).state = widget.projectId;

    // โหลด Sprint
    ref.read(sprintProvider.notifier).get();

    // โหลด Task ตาม projectId
    ref.read(taskBySprintControllerProvider(widget.projectId).notifier).fetch();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Project Detail'),
          shape: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.0)),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontSize: isMobile ? 12 : 14),
            unselectedLabelStyle: TextStyle(fontSize: isMobile ? 10 : 12),
            tabs: const [
              Tab(icon: Icon(Icons.dashboard, size: 15), child: Text('Summary', overflow: TextOverflow.ellipsis)),
              Tab(icon: Icon(Icons.table_rows_outlined, size: 15), child: Text('Backlog', overflow: TextOverflow.ellipsis)),
              Tab(icon: RotatedBox(quarterTurns: 1, child: Icon(Icons.table_rows_outlined, size: 15)), child: Text('Board', overflow: TextOverflow.ellipsis)),
              Tab(icon: Icon(Icons.timeline, size: 15), child: Text('Timeline', overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SummaryWidget(),
            BacklogWidget(),
            // ส่ง projectId เข้า BoardWidget
            BoardWidget(projectId: widget.projectId),
            GanttAppWidget(projectId: widget.projectId),
          ],
        ),
      ),
    );
  }
}
