// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:project/apis/project_data/delete_project_hd.dart';
// import 'package:project/models/category_model.dart';
// import 'package:project/models/project_h_d_model.dart';
// import 'package:project/screens/project/controllers/delete_project_hd_controller.dart';
// import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
// import 'package:project/screens/project/project_update/provider/controllers/project_update_controller.dart';

// final dataProjectHDProvider = StateProvider<ProjectHDModel>((ref) => ProjectHDModel(id: '0', name: '', key: '', description: '', active: true));

// class InsertOrUpdateProjectHD extends ConsumerStatefulWidget {
//   final ProjectHDModel projectHDModel;
//   final CategoryModel category;
//   const InsertOrUpdateProjectHD({super.key, required this.category, required this.projectHDModel});

//   @override
//   ConsumerState<InsertOrUpdateProjectHD> createState() => _InsertOrUpdateProjectHDState();
// }

// class _InsertOrUpdateProjectHDState extends ConsumerState<InsertOrUpdateProjectHD> {
//   final TextEditingController _projectNameController = TextEditingController();
//   final TextEditingController _projectKeyController = TextEditingController();
//   final TextEditingController _projectDescriptionController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _projectNameController.text = widget.projectHDModel.name ?? '';
//       _projectKeyController.text = widget.projectHDModel.key ?? '';
//       _projectDescriptionController.text = widget.projectHDModel.description ?? '';
//       ref.read(dataProjectHDProvider.notifier).state = widget.projectHDModel;
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _projectNameController.dispose();
//     _projectKeyController.dispose();
//     _projectDescriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, child) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: Row(
//             children: [
//               Text(widget.projectHDModel.id == '0' ? 'เพิ่มโปรเจค' : 'แก้ไขโปรเจค'),

//             //แสดงเมื่อเปิดแก้ไขโปรเจค
//               if (widget.projectHDModel.id != '0') ...[
//                 const Spacer(),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.grey),
//                   onPressed: () {
//                     // แสดง dialog ยืนยันการลบ
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           backgroundColor: Colors.white,
//                           title: const Text('ยืนยันการลบ'),
//                           content: const Text('คุณต้องการลบโปรเจคนี้ใช่หรือไม่?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: const Text('ยกเลิก'),
//                             ),
//                             TextButton(
//                               onPressed: () async {
//                                 await ref
//                                     .read(deleteProjectHDControllerProvider.notifier)
//                                     .deleteProjectHD(widget.projectHDModel.id!);

//                                 // รีเฟรชข้อมูล category เพื่ออัปเดตรายการโปรเจค
//                                 ref.read(categoryProvider.notifier).getCategory(widget.category.workspaceId!);

//                                 // แสดง SnackBar
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text('ลบโปรเจคเรียบร้อย')),
//                                 );

//                                 Navigator.pop(context); // ปิด dialog ยืนยันการลบ
//                                 Navigator.pop(context); // ปิด dialog แก้ไขโปรเจค
//                                   },
//                                   child: const Text('ลบ'),
//                                   ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ]
//             ],
//           ),
//           content: SizedBox(
//             width: 400,
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 spacing: 16,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   //name
//                   TextField(
//                     controller: _projectNameController,
//                     decoration: const InputDecoration(labelText: 'ชื่อโปรเจค', hintText: 'ชื่อโปรเจค'),
//                     onChanged: (value) {
//                       // ref.read(dataProjectHDProvider.notifier).state = ref.read(dataProjectHDProvider).copyWith(name: value);
//                     },
//                   ),
//                   //key
//                   TextField(
//                     controller: _projectKeyController,
//                     decoration: const InputDecoration(labelText: 'Key โปรเจค', hintText: 'Key โปรเจค'),
//                     onChanged: (value) {
//                       // ref.read(dataProjectHDProvider.notifier).state = ref.read(dataProjectHDProvider).copyWith(key: value);
//                     },
//                   ),
//                   //description
//                   TextField(
//                     maxLines: 3,
//                     controller: _projectDescriptionController,
//                     decoration: const InputDecoration(labelText: 'คำอธิบายโปรเจค', hintText: 'คำอธิบายโปรเจค'),
//                     onChanged: (value) {
//                       // ref.read(dataProjectHDProvider.notifier).state = ref.read(dataProjectHDProvider).copyWith(description: value);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
//             FilledButton(onPressed: _submit, child: Text(widget.projectHDModel.id == '0' ? 'เพิ่มโปรเจค' : 'แก้ไขโปรเจค')),
//           ],

//         );
//       },
//     );
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     try {
//       var item = ref.read(dataProjectHDProvider);
//     final body = {
//       'id': item.id,
//       'name': _projectNameController.text.trim(),
//       'key': _projectKeyController.text.trim(),
//       'description': _projectDescriptionController.text.trim(),
//       'project_category_id': widget.category.id,
//       'lead_id': item.leader!.id,
//     };

//     await ref.read(projectUpdateControllerProvider.notifier).submitProjectHD(body: body);
//     ref.read(categoryProvider.notifier).getCategory(widget.category.workspaceId!);
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(widget.projectHDModel.id == '0' ? 'เพิ่มโปรเจคสำเร็จ' : 'แก้ไขโปรเจคสำเร็จ'),
//           backgroundColor: Colors.green.shade600,
//           behavior: SnackBarBehavior.floating,
//           margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//       Navigator.of(context).pop(true);
//     }
//     }catch (e,stx) {
//       print('Error: $e, StackTrace: $stx');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('เกิดข้อผิดพลาด: $e'),
//           backgroundColor: Colors.red.shade600,
//           behavior: SnackBarBehavior.floating,
//           margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/category_model.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/screens/project/controllers/delete_project_hd_controller.dart';
import 'package:project/screens/project/controllers/project_image_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/screens/project/project_update/provider/controllers/project_update_controller.dart';

final dataProjectHDProvider = StateProvider<ProjectHDModel>(
  (ref) =>
      ProjectHDModel(id: '0', name: '', key: '', description: '', active: true),
);

class InsertOrUpdateProjectHD extends ConsumerStatefulWidget {
  final ProjectHDModel projectHDModel;
  final CategoryModel category;
  const InsertOrUpdateProjectHD({
    super.key,
    required this.category,
    required this.projectHDModel,
  });

  @override
  ConsumerState<InsertOrUpdateProjectHD> createState() =>
      _InsertOrUpdateProjectHDState();
}

class _InsertOrUpdateProjectHDState
    extends ConsumerState<InsertOrUpdateProjectHD> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectKeyController = TextEditingController();
  final TextEditingController _projectDescriptionController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _projectNameController.text = widget.projectHDModel.name ?? '';
      _projectKeyController.text = widget.projectHDModel.key ?? '';
      _projectDescriptionController.text =
          widget.projectHDModel.description ?? '';
      ref.read(dataProjectHDProvider.notifier).state = widget.projectHDModel;
    });
    super.initState();
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectKeyController.dispose();
    _projectDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectData = ref.watch(dataProjectHDProvider);

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Text(widget.projectHDModel.id == '0' ? 'เพิ่มโปรเจค' : 'แก้ไขโปรเจค'),
          if (widget.projectHDModel.id != '0') ...[
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () => _confirmDeleteProject(context),
            ),
          ],
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                // -------- ช่องกรอกข้อมูล --------
                TextField(
                  controller: _projectNameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อโปรเจค',
                    hintText: 'ชื่อโปรเจค',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _projectKeyController,
                  decoration: const InputDecoration(
                    labelText: 'Key โปรเจค',
                    hintText: 'Key โปรเจค',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  controller: _projectDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'คำอธิบายโปรเจค',
                    hintText: 'คำอธิบายโปรเจค',
                  ),
                ),
                const SizedBox(height: 16),
                // -------- รูปโปรเจค --------
                DottedBorder(
                  // borderType: BorderType.RRect,
                  //   radius: const Radius.circular(20),
                  //  dashPattern: const [6, 3],
                  // color: Colors.grey,
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Stack(
                      children: [
                        Align(
                          alignment:
                              Alignment.center, // หรือ Alignment.center ก็ได้
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child:
                                (projectData.image != null &&
                                        projectData.image!.isNotEmpty)
                                    ? CachedNetworkImage(
                                      imageUrl: projectData.image!,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                      errorWidget:
                                          (context, url, error) => const Center(
                                            child: Text('โหลดรูปไม่สำเร็จ'),
                                          ),
                                      height: 60,
                                      width: 60, // ✅ บังคับขนาดรูป
                                    )
                                    : Center(
                                      child: OutlinedButton.icon(
                                        onPressed: () async {
                                          await _pickAndUploadProjectImage(ref);
                                        },
                                        icon: const Icon(Icons.upload),
                                        label: const Text('อัพโหลดรูปโปรเจค'),
                                      ),
                                    ),
                          ),
                        ),
                        if (projectData.image != null &&
                            projectData.image!.isNotEmpty)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton.filled(
                              onPressed: () async {
                                await _deleteProjectImage(ref);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black45,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  226,
                                  226,
                                  226,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ยกเลิก'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(
            widget.projectHDModel.id == '0' ? 'เพิ่มโปรเจค' : 'แก้ไขโปรเจค',
          ),
        ),
      ],
    );
  }

  /// เลือกไฟล์ + อัปโหลดรูปโปรเจค
  Future<void> _pickAndUploadProjectImage(WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: const ['jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final platformFile = result.files.single;
        final bytes = platformFile.bytes!;

        final tempDir = Directory.systemTemp;
        final fileName = platformFile.name;
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(bytes);

        final uploadedUrl = await ref
            .read(projectImageProvider.notifier)
            .uploadProjectImage(tempFile);

        // update state
        ref.read(dataProjectHDProvider.notifier).state = ref
            .read(dataProjectHDProvider)
            .copyWith(image: uploadedUrl);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('อัพโหลดรูปโปรเจคสำเร็จ')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
      }
    }
  }

  /// ลบรูปโปรเจค
  Future<void> _deleteProjectImage(WidgetRef ref) async {
    final projectData = ref.read(dataProjectHDProvider);
    if (projectData.image == null || projectData.image!.isEmpty) return;

    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('ยืนยันการลบ'),
            content: const Text('คุณต้องการลบรูปโปรเจคหรือไม่?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('ลบ'),
              ),
            ],
          ),
    );

    if (confirmDelete == true) {
      try {
        await ref
            .read(projectImageProvider.notifier)
            .deleteProjectImage(projectData.image!);

        ref.read(dataProjectHDProvider.notifier).state = projectData.copyWith(
          image: '',
        );

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('ลบรูปโปรเจคสำเร็จ')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
        }
      }
    }
  }

  /// ยืนยันลบโปรเจค
  Future<void> _confirmDeleteProject(BuildContext context) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('ยืนยันการลบ'),
            content: const Text('คุณต้องการลบโปรเจคนี้ใช่หรือไม่?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('ลบ'),
              ),
            ],
          ),
    );

    if (confirmDelete == true) {
      try {
        await ref
            .read(deleteProjectHDControllerProvider.notifier)
            .deleteProjectHD(widget.projectHDModel.id!);

        ref
            .read(categoryProvider.notifier)
            .getCategory(widget.category.workspaceId!);

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('ลบโปรเจคเรียบร้อย')));
        }

        Navigator.pop(context);
        Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
        }
      }
    }
  }

  /// Submit เพิ่ม/แก้ไขโปรเจค
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      var item = ref.read(dataProjectHDProvider);
      final body = {
        'id': item.id,
        'name': _projectNameController.text.trim(),
        'key': _projectKeyController.text.trim(),
        'description': _projectDescriptionController.text.trim(),
        'project_category_id': widget.category.id,
        'lead_id': item.leader?.id,
        'image': item.image ?? '',
      };

      await ref
          .read(projectUpdateControllerProvider.notifier)
          .submitProjectHD(body: body);

      ref
          .read(categoryProvider.notifier)
          .getCategory(widget.category.workspaceId!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.projectHDModel.id == '0'
                  ? 'เพิ่มโปรเจคสำเร็จ'
                  : 'แก้ไขโปรเจคสำเร็จ',
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e, stx) {
      print('Error: $e, StackTrace: $stx');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
