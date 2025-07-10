// Example usage of InsertUpdateSprint widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'insert_update_sprint.dart';

class ExampleSprintUsage extends ConsumerWidget {
  const ExampleSprintUsage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sprint Management Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ปุ่มสำหรับเพิ่ม Sprint ใหม่
            ElevatedButton.icon(
              onPressed: () {
                // ตั้งค่า project ID ก่อน (จำลองค่า)
                ref.read(selectProjectIdProvider.notifier).state = "456";
                
                // นำทางไปหน้าเพิ่ม Sprint ใหม่
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InsertUpdateSprint(), // sprint = null = เพิ่มใหม่
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('เพิ่ม Sprint ใหม่'),
            ),
            
            const SizedBox(height: 16),
            
            // ปุ่มสำหรับแก้ไข Sprint (จำลองข้อมูล)
            ElevatedButton.icon(
              onPressed: () {
                // ตั้งค่า project ID ก่อน (จำลองค่า)
                ref.read(selectProjectIdProvider.notifier).state = "456";
                
                // สร้างข้อมูล Sprint จำลองสำหรับแก้ไข
                final mockSprint = const SprintModel(
                  id: "11",
                  name: "Sprint 1A",
                  duration: 14,
                  goal: "Complete initial setup",
                );
                
                // นำทางไปหน้าแก้ไข Sprint
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InsertUpdateSprint(sprint: mockSprint), // ส่ง sprint = แก้ไข
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('แก้ไข Sprint (ตัวอย่าง)'),
            ),
          ],
        ),
      ),
    );
  }
}
