// lib/screens/project/sprint/views/sprint_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/project/sprint/views/delete_sprint_dialog.dart';

// provider ดึงข้อมูล Sprint จริง ให้แก้ตรงนี้ได้เลย
// ตัวอย่างนี้ทำ Mock list ให้ดูชัดๆ

class SprintListScreen extends ConsumerWidget {
  const SprintListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ตัวอย่างรายการ Sprint mock data
    final sprintList = [
      {'id': '1', 'name': 'Sprint 1'},
      {'id': '2', 'name': 'Sprint 2'},
      {'id': '3', 'name': 'Sprint 3'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sprint List'),
      ),
      body: sprintList.isEmpty
          ? const Center(child: Text('ยังไม่มี Sprint'))
          : ListView.separated(
              itemCount: sprintList.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final sprint = sprintList[index];
                return ListTile(
                  title: Text(sprint['name'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red[700],
                    tooltip: 'ลบ Sprint',
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => DeleteSprintDialog(
                          sprintId: sprint['id']!,
                          sprintName: sprint['name']!,
                        ),
                      );

                      if (result == true) {
                        //  ทำอะไรต่อ เช่น เรียก refetch Sprint หรือโชว์ SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ลบ ${sprint['name']} สำเร็จ!'),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        tooltip: 'เพิ่ม Sprint',
        child: const Icon(Icons.add),
      ),
    );
  }
}
