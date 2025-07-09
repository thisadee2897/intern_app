import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/screens/project/sprint/providers/controllers/update_controller.dart';
import 'package:project/screens/project/sprint/providers/controllers/project_controller.dart';

// ฟังก์ชันที่ใช้แสดง Dialog สำหรับสร้างหรือแก้ไข Sprint
Future<void> showSprintFormDialog(
  BuildContext context,
  WidgetRef ref,
  ProjectHDModel project, [
  SprintModel? sprint,
]) async {
  // สร้าง GlobalKey สำหรับ validate form
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: sprint?.name ?? '');
  final _goalController = TextEditingController(text: sprint?.goal ?? '');
  final _durationController = TextEditingController(
    text: sprint?.duration?.toString() ?? '',
  );

  // รอ showDialog จบ (async)
  await showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          // กำหนด title ตามโหมด (สร้างหรือแก้ไข)
          title: Text(sprint == null ? 'Create Sprint' : 'Edit Sprint'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(style: const TextStyle(fontSize: 16),
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Sprint Name',
                    border: OutlineInputBorder(),
                    ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Please enter sprint name'
                              : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _goalController,
                  decoration: const InputDecoration(
                    labelText: 'Goal',
                    border: OutlineInputBorder(),
                    ),
                ),
                const SizedBox(height: 16), 

                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (days)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          // ปุ่มด้านล่างของ dialog
          actions: [
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Confirm Cancel'),
                        content: const Text('Are you sure you want to cancel?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('No'), // เพิ่ม child
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Yes'), // เพิ่ม child
                          ),
                        ],
                      ),
                );
              },
              child: const Text('Cancel'), // เพิ่ม child
            ),

            ElevatedButton(
              onPressed: () async {
                // ถ้าฟอร์ม validate ผ่าน
                if (_formKey.currentState!.validate()) {
                  // เตรียม body ส่งไป API
                  final body = {
                    'id': sprint?.id ?? '', // ถ้าไม่มี id แปลว่าสร้างใหม่
                    'project_id': project.id, // id โปรเจกต์
                    'name': _nameController.text.trim(), // ตัด space
                    'goal': _goalController.text.trim(),
                    'duration':
                        int.tryParse(_durationController.text.trim()) ?? 14,
                  };
                  

                  // เรียก update controller
                  await ref
                      .read(updateSprintControllerProvider.notifier)
                      .updateSprint(body: body);

                  // อ่าน state หลัง update
                  final state = ref.read(updateSprintControllerProvider);
                  state.whenOrNull(
                    data: (_) async {
                      // แสดง dialog ยืนยัน
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Success'),
                              content: const Text(
                                'Sprint saved successfully. Close the form?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        ref
                            .read(sprintByProjectControllerProvider.notifier)
                            .getSprints(project.id.toString());
                        Navigator.of(context).pop(); // ปิด dialog form
                      }
                    },
                    error: (e, _) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save sprint: $e')),
                      );
                    },
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
  );

  // clear controller หลังปิด
  _nameController.dispose();
  _goalController.dispose();
  _durationController.dispose();
}
