import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/export.dart';
import 'package:project/utils/extension/context_extension.dart'; // ถ้ายังไม่มี ให้สร้าง extension context

class ProjectDetailScreen extends ConsumerStatefulWidget {
  const ProjectDetailScreen({super.key});

  @override
  ConsumerState<ProjectDetailScreen> createState() =>
      _ProjectDetailScreenState();
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
          shape: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
          ),
          bottom: TabBar(
            //isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontSize: isMobile ? 12 : 14,
            ), // ปรับขนาดตัวอักษรตามขนาดจอ
            unselectedLabelStyle: TextStyle(
              fontSize: isMobile ? 10 : 12,
            ), // ปรับขนาดตัวอักษรสำหรับแท็บที่ไม่ถูกเลือก
            tabs: const [
              Tab(
                icon: Icon(Icons.dashboard, size: 15),
                child: Text('Summary', overflow: TextOverflow.ellipsis),
              ),
              Tab(
                icon: Icon(Icons.table_rows_outlined, size: 15),
                child: Text('Backlog', overflow: TextOverflow.ellipsis),
              ),
              Tab(
                icon: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(Icons.table_rows_outlined, size: 15),
                ),
                child: Text('Board', overflow: TextOverflow.ellipsis),
              ),
              Tab(
                icon: Icon(Icons.timeline, size: 15),
                child: Text('Timeline', overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SummaryWidget(),
            BacklogWidget(),
            BoardWidget(),
            TimelineWidget(),
          ],
        ),
      ),
    );
  }
}
