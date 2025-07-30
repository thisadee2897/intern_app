import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/project/project_datail/gantt_chart/views/widgets/gantt_app_widget.dart';
import '../gantt_chart/views/gantt_chart.dart';
import 'widgets/export.dart';
// import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart'; // อย่าลืม import SprintProvider ด้วย

class ProjectDetailScreen extends ConsumerStatefulWidget {
  const ProjectDetailScreen({super.key});

  @override
  ConsumerState<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
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

          // ถ้าตรงการปุ่ม icon ถังขยะบน AppBar ให้จัดการ Sprint ทั้งหมดจัดการได้ที่ตรงนี้
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.delete),
            //   tooltip: 'Delete Sprint',
            //   onPressed: () {
            //     // สมมติทดสอบส่งค่า sprintId/sprintName จริงได้ตามโปรเจ็กต์
            //     _showDeleteSprintDialog(
            //       sprintId: '1',
            //       sprintName: 'Sprint 1',
            //     );
            //   },
            // ),
          ],
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
            BoardWidget(),
            GanttAppWidget(),
            // TimelineWidget(),
          ],
        ),
      ),
    );
  }
}
