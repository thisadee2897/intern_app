import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/screens/project/sprint/providers/controllers/update_controller.dart';
import 'package:project/screens/project/sprint/providers/controllers/project_controller.dart';

Future<void> showSprintFormDialog(
  BuildContext context,
  WidgetRef ref,
  ProjectHDModel project, [
  SprintModel? sprint,
]) async {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: sprint?.name ?? '');
  final _goalController = TextEditingController(text: sprint?.goal ?? '');
  final _durationController = TextEditingController(
    text: sprint?.duration?.toString() ?? '',
  );

  await showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: Text(sprint == null ? 'Create Sprint' : 'Edit Sprint'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  style: const TextStyle(fontSize: 16),
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Sprint Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (days)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
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
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final projectId = project.id;
                  if (projectId == null || projectId.isEmpty) {
                    throw Exception('Project ID is empty');
                  }

                  final body = {
                    // ถ้าเป็นแก้ไข sprint ให้ส่ง id ด้วย
                    if (sprint != null &&
                        sprint.id != null &&
                        sprint.id!.isNotEmpty)
                      'id': sprint.id,

                    'name': _nameController.text.trim(),
                    'goal': _goalController.text.trim(),
                    'duration':
                        int.tryParse(_durationController.text.trim()) ?? 14,
                    'start_date': null,
                    'end_date': null,
                    'completed': sprint?.completed ?? false,
                    'active': sprint?.active ?? true,
                    'startting': sprint?.startting ?? false,
                    'project_hd_id': project.id?.toString() ?? '',
                    'hd_id': "1",
                  };

                  print('===== BODY TO SEND =====');
                  print(body);
                  print('========================');

                  await ref
                      .read(updateSprintControllerProvider.notifier)
                      .updateSprint(body: body);

                  final state = ref.read(updateSprintControllerProvider);
                  state.whenOrNull(
                    data: (sprintResponse) async {
                      print('API Response Success: $sprintResponse');

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
                            .getSprints(project.id ?? '');
                        Navigator.of(context).pop();
                      }
                    },
                    error: (e, _) {
                      print('API Error: $e');
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

  _nameController.dispose();
  _goalController.dispose();
  _durationController.dispose();
}






// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:project/models/project_h_d_model.dart';
// import 'package:project/models/sprint_model.dart';
// import 'package:project/screens/project/sprint/providers/controllers/sprint_by_project_controller.dart';
// import 'package:project/screens/project/sprint/providers/controllers/sprint_create_controller.dart';
// import 'package:project/screens/project/sprint/providers/controllers/sprint_update_controller.dart';

// /// ✅ ฟอร์มสร้าง Sprint ใหม่
// Future<void> showCreateSprintDialog(
//   BuildContext context,
//   WidgetRef ref,
//   ProjectHDModel project,
// ) async {
//   final formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final goalController = TextEditingController();
//   final durationController = TextEditingController();

//   await showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: const Text('Create Sprint'),
//       content: Form(
//         key: formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             /// Sprint Name
//             TextFormField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Sprint Name'),
//               validator: (value) =>
//                   value == null || value.isEmpty ? 'Please enter name' : null,
//             ),
//             const SizedBox(height: 8),

//             /// Goal
//             TextFormField(
//               controller: goalController,
//               decoration: const InputDecoration(labelText: 'Goal'),
//             ),
//             const SizedBox(height: 8),

//             /// Duration
//             TextFormField(
//               controller: durationController,
//               decoration: const InputDecoration(labelText: 'Duration (days)'),
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         /// ✅ ปุ่ม Cancel
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('Cancel'),
//         ),

//         /// ✅ ปุ่ม Save
//         ElevatedButton(
//           onPressed: () async {
//             if (formKey.currentState!.validate()) {
//               final body = {
//                 'table_name': 'project_hd',
//                 'name': nameController.text.trim(),
//                 'goal': goalController.text.trim(),
//                 'duration': int.tryParse(durationController.text.trim()) ?? 14,
//                 'start_date': null,
//                 'end_date': null,
//                 'completed': false,
//                 'active': true,
//                 'startting': false,
//                 'project_hd': {
//                   'id': project.id,
//                   'name': project.name,
//                 },
//               };

//               await ref
//                   .read(sprintCreateControllerProvider.notifier)
//                   .createSprint(body: body);

//               // ✅ โหลด Sprint ใหม่ หลังสร้างสำเร็จ
//               await ref
//                   .read(sprintByProjectControllerProvider.notifier)
//                   .getSprints(project.id ?? '');

//               Navigator.of(context).pop(); // ปิด dialog
//             }
//           },
//           child: const Text('Save'),
//         ),
//       ],
//     ),
//   );

//   nameController.dispose();
//   goalController.dispose();
//   durationController.dispose();
// }

// /// ✅ ฟอร์มแก้ไข Sprint
// Future<void> showEditSprintDialog(
//   BuildContext context,
//   WidgetRef ref,
//   ProjectHDModel project,
//   SprintModel sprint,
// ) async {
//   final formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController(text: sprint.name);
//   final goalController = TextEditingController(text: sprint.goal);
//   final durationController =
//       TextEditingController(text: sprint.duration?.toString());

//   await showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: const Text('Edit Sprint'),
//       content: Form(
//         key: formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             /// Sprint Name
//             TextFormField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Sprint Name'),
//               validator: (value) =>
//                   value == null || value.isEmpty ? 'Please enter name' : null,
//             ),
//             const SizedBox(height: 8),

//             /// Goal
//             TextFormField(
//               controller: goalController,
//               decoration: const InputDecoration(labelText: 'Goal'),
//             ),
//             const SizedBox(height: 8),

//             /// Duration
//             TextFormField(
//               controller: durationController,
//               decoration: const InputDecoration(labelText: 'Duration (days)'),
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         /// ✅ ปุ่ม Cancel พร้อม Confirm
//         TextButton(
//           onPressed: () async {
//             final confirm = await showDialog<bool>(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: const Text('Confirm Cancel'),
//                 content: const Text('Are you sure you want to cancel?'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pop(false),
//                     child: const Text('No'),
//                   ),
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pop(true),
//                     child: const Text('Yes'),
//                   ),
//                 ],
//               ),
//             );

//             if (confirm == true) {
//               Navigator.of(context).pop(); // ปิด dialog หลัก
//             }
//           },
//           child: const Text('Cancel'),
//         ),

//         /// ✅ ปุ่ม Update
//         ElevatedButton(
//           onPressed: () async {
//             if (formKey.currentState!.validate()) {
//               final body = {
//                 'table_name': 'project_hd',
//                 'id': sprint.id,
//                 'name': nameController.text.trim(),
//                 'goal': goalController.text.trim(),
//                 'duration': int.tryParse(durationController.text.trim()) ?? 14,
//                 'start_date': sprint.satartDate,
//                 'end_date': sprint.endDate,
//                 'completed': sprint.completed ?? false,
//                 'active': sprint.active ?? true,
//                 'startting': sprint.startting ?? false,
//                 'project_hd': {
//                   'id': project.id,
//                   'name': project.name,
//                 },
//               };

//               await ref
//                   .read(updateControllerProvider.notifier)
//                   .updateSprint(body: body);

//               // ✅ โหลด Sprint ใหม่ หลังแก้ไขสำเร็จ
//               await ref
//                   .read(sprintByProjectControllerProvider.notifier)
//                   .getSprints(project.id ?? '');

//               Navigator.of(context).pop(); // ปิด dialog หลัก
//             }
//           },
//           child: const Text('Update'),
//         ),
//       ],
//     ),
//   );

//   nameController.dispose();
//   goalController.dispose();
//   durationController.dispose();
// }













