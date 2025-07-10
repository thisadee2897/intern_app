// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:project/models/project_h_d_model.dart';
// import 'package:project/models/sprint_model.dart';
// import 'package:project/screens/project/sprint/providers/controllers/project_controller.dart';
// import 'package:project/screens/project/sprint/views/widgets/sprint_form_dialog.dart';
// import 'package:project/screens/project/sprint/views/widgets/sprint_list_item.dart';

// // หน้าหลักแสดงรายการ Sprint ของโปรเจกต์
// class ProjectSprintScreen extends ConsumerStatefulWidget {
//   final ProjectHDModel project; // ข้อมูลโปรเจกต์ที่ต้องการแสดง Sprint

//   const ProjectSprintScreen({super.key, required this.project});

//   @override
//   ConsumerState<ProjectSprintScreen> createState() =>
//       _ProjectSprintScreenState();
// }

// class _ProjectSprintScreenState extends ConsumerState<ProjectSprintScreen> {

//   @override
//   void initState() {
//     super.initState();
//     // หลังจากหน้าจอ build เสร็จ โหลด sprint ทั้งหมดของโปรเจกต์นี้
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       print('Loading sprints for project: ${widget.project.id}');
//       print(widget.project.id.runtimeType);
//       ref
//           .read(sprintByProjectControllerProvider.notifier)
//           .getSprints(widget.project.id.toString());
//     });
//   }

//   // ฟังก์ชันเปิด dialog สร้างหรือแก้ไข Sprint
//   void _openSprintForm([SprintModel? sprint]) async {
//     await showSprintFormDialog(context, ref, widget.project, sprint);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ดูสถานะ sprint จาก provider
//     final sprintState = ref.watch(sprintByProjectControllerProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Sprints of ${widget.project.name}',
//           style: const TextStyle(
//             color: Color.fromARGB(255, 24, 87, 118),
//             fontSize: 25,
//           ),
//         ), // แสดงชื่อโปรเจกต์ใน title
//       ),
//       body: sprintState.when(
//         data: (sprints) {
//           // ถ้าไม่มี sprint ให้แจ้งผู้ใช้
//           if (sprints.isEmpty) {
//             return const Center(child: Text('No sprints found.'));
//           }
//           // ถ้ามี sprint แสดงเป็น ListView
//           return ListView.builder(
//             itemCount: sprints.length,
//             itemBuilder: (context, index) {
//               final sprint = sprints[index];
//               return SprintListItem(
//                 sprint: sprint,
//                 onEdit: () => _openSprintForm(sprint), // เมื่อกดแก้ไข
//               );
//             },
//           );
//         },
//         loading:
//             () => const Center(child: CircularProgressIndicator()), // กำลังโหลด
//         error: (error, stack) {
//           print('Error loading sprints: $stack'); // แสดง error ใน console
//           return Center(
//             child: Text(
//               'Error loading sprints: $error'),
//               );
//         }, // error
//       ),
      
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _openSprintForm(), // กดเพื่อสร้าง sprint ใหม่
//         tooltip: 'Create Sprint', 
//         child: const Icon(Icons.add, color: Color.fromARGB(255, 24, 87, 118)),
//       ),
//     );
//   }
// }







// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:project/models/project_h_d_model.dart';
// import 'package:project/models/sprint_model.dart';
// import 'package:project/screens/project/sprint/views/widgets/sprint_list_item.dart';
// import 'package:project/screens/project/sprint/views/widgets/sprint_form_dialog.dart';
// import 'package:project/screens/project/sprint/providers/controllers/sprint_by_project_controller.dart';

// class ProjectSprintScreen extends ConsumerStatefulWidget {
//   final ProjectHDModel project;

//   const ProjectSprintScreen({super.key, required this.project});

//   @override
//   ConsumerState<ProjectSprintScreen> createState() =>
//       _ProjectSprintScreenState();
// }

// class _ProjectSprintScreenState extends ConsumerState<ProjectSprintScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref
//           .read(sprintByProjectControllerProvider.notifier)
//           .getSprints(widget.project.id ?? '');
//     });
//   }

//   void _openSprintForm({SprintModel? sprint}) async {
//     if (sprint == null) {
//       await showCreateSprintDialog(context, ref, widget.project);
//     } else {
//       await showEditSprintDialog(context, ref, widget.project, sprint);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sprintState = ref.watch(sprintByProjectControllerProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Sprints of ${widget.project.name}',
//           style: const TextStyle(
//             color: Color.fromARGB(255, 24, 87, 118),
//             fontSize: 22,
//           ),
//         ),
//       ),
//       body: sprintState.when(
//         data: (sprints) {
//           if (sprints.isEmpty) {
//             return const Center(child: Text('No sprints found.'));
//           }
//           return ListView.builder(
//             itemCount: sprints.length,
//             itemBuilder: (context, index) {
//               final sprint = sprints[index];
//               return SprintListItem(
//                 sprint: sprint,
//                 onEdit: () => _openSprintForm(sprint: sprint),
//               );
//             },
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, _) => Center(child: Text('Error: $err')),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _openSprintForm(),
//         tooltip: 'Create Sprint',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
