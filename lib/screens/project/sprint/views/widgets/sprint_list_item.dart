import 'package:flutter/material.dart';
import 'package:project/models/sprint_model.dart';

// Widget สำหรับแสดงข้อมูล Sprint แต่ละรายการ
class SprintListItem extends StatelessWidget {
  final SprintModel sprint; // ข้อมูล sprint ที่จะแสดง
  final VoidCallback onEdit; // ฟังก์ชันสำหรับกดปุ่มแก้ไข

  const SprintListItem({
    super.key,
    required this.sprint,
    required this.onEdit,
  }); 

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: ListTile(
        title: Text(sprint.name ?? 'Unnamed Sprint'), // แสดงชื่อ sprint
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8), // เว้นระยะห่าง
            Text('Goal: ${sprint.goal ?? "-"}'),
            Text('Duration: ${sprint.duration ?? "-"} days'),
            Text('Completed: ${sprint.completed == true ? "Yes" : "No"}'),
            Text('Active: ${sprint.active == true ? "Yes" : "No"}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit, // เรียกเมื่อกด edit
        ),
      ),
    );
  }
}
