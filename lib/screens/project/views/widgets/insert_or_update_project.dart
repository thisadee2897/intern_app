// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/category_model.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/screens/auth/widgets/glass_container.dart';
import 'package:project/screens/project/controllers/delete_project_hd_controller.dart';
import 'package:project/screens/project/controllers/project_image_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/screens/project/project_update/provider/controllers/project_update_controller.dart';
import 'package:project/utils/extension/custom_snackbar.dart';

final dataProjectHDProvider = StateProvider<ProjectHDModel>(
  (ref) => ProjectHDModel(
      id: '0', name: '', key: '', description: '', active: true),
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
    extends ConsumerState<InsertOrUpdateProjectHD>
    with TickerProviderStateMixin {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectKeyController = TextEditingController();
  final TextEditingController _projectDescriptionController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _projectNameController.text = widget.projectHDModel.name ?? '';
      _projectKeyController.text = widget.projectHDModel.key ?? '';
      _projectDescriptionController.text =
          widget.projectHDModel.description ?? '';
      ref.read(dataProjectHDProvider.notifier).state = widget.projectHDModel;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _projectNameController.dispose();
    _projectKeyController.dispose();
    _projectDescriptionController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  final projectData = ref.watch(dataProjectHDProvider);

  return FadeTransition(
    opacity: _fadeAnimation,
    child: ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: FloatingCard(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.projectHDModel.id == '0'
                            ? 'เพิ่มโปรเจค'
                            : 'แก้ไขโปรเจค',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      if (widget.projectHDModel.id != '0') ...[
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _confirmDeleteProject(context),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  Form(
                    key: _formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // รูปโปรเจค
                        DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            color: Colors.white,
                            dashPattern: const [6, 3],
                            radius: const Radius.circular(20),
                          ),
                          child: SizedBox(
                            width: 220,
                            height: 220,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: (projectData.image != null &&
                                            projectData.image!.isNotEmpty)
                                        ? CachedNetworkImage(
                                            imageUrl: projectData.image!,
                                            fit: BoxFit.cover,
                                            height: 210,
                                            width: 210,
                                            placeholder: (context, url) =>
                                                const Center(child: CircularProgressIndicator()),
                                            errorWidget: (context, url, error) =>
                                                const Center(child: Text('โหลดรูปไม่สำเร็จ')),
                                          )
                                        : Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  await _pickAndUploadProjectImage(ref);
                                                },
                                                icon: const Icon(Icons.upload, size: 30),
                                              ),
                                              const SizedBox(height: 4),
                                              const Text('อัพโหลดรูปภาพโปรเจค'),
                                            ],
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
                                      icon: const Icon(Icons.delete, color: Colors.black45),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 226, 226, 226),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // ฟอร์ม
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _projectNameController,
                                decoration: InputDecoration(
                                  labelText: 'ชื่อโปรเจค',
                                  filled: true,
                                  fillColor: const Color(0xFF001B4B),
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFF667eea))),
                                ),
                                style: const TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'กรุณากรอกชื่อโปรเจค';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _projectKeyController,
                                decoration: InputDecoration(
                                  labelText: 'Key โปรเจค',
                                  filled: true,
                                  fillColor: const Color(0xFF001B4B),
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFF667eea))),
                                ),
                                style: const TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'กรุณากรอก Key โปรเจค';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _projectDescriptionController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'คำอธิบายโปรเจค',
                                  filled: true,
                                  fillColor: const Color(0xFF001B4B),
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFF667eea))),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade600, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        ),
                        child: const Text('ยกเลิก', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          backgroundColor: const Color(0xFF003B99),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          widget.projectHDModel.id == '0' ? 'เพิ่มโปรเจค' : 'แก้ไขโปรเจค',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
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
        ref.read(dataProjectHDProvider.notifier).state =
            ref.read(dataProjectHDProvider).copyWith(image: uploadedUrl);

        if (mounted) {
          CustomSnackbar.showSnackBar(
            context: context,
            title: "สำเร็จ",
            message: "อัพโหลดรูปโปรเจคเรียบร้อย",
            contentType: ContentType.success,
            color: Colors.green,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showSnackBar(
          context: context,
          title: "เกิดข้อผิดพลาด",
          message: "$e",
          contentType: ContentType.failure,
          color: Colors.red,
        );
      }
    }
  }

  /// ลบรูปโปรเจค
Future<void> _deleteProjectImage(WidgetRef ref) async {
  final projectData = ref.read(dataProjectHDProvider);
  if (projectData.image == null || projectData.image!.isEmpty) return;

  final bool? confirmDelete = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (context, anim1, anim2) => FadeTransition(
      opacity: anim1,
      child: ScaleTransition(
        scale: anim1,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: FloatingCard(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.orange, Colors.deepOrange]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.warning_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'ยืนยันการลบรูปโปรเจค',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('คุณต้องการลบรูปโปรเจคนี้หรือไม่?', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade600, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          ),
                          child: const Text('ยกเลิก', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            backgroundColor: Colors.red.shade600,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('ลบ', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  if (confirmDelete == true) {
    try {
      await ref.read(projectImageProvider.notifier).deleteProjectImage(projectData.image!);
      ref.read(dataProjectHDProvider.notifier).state = projectData.copyWith(image: '');
      if (mounted) {
        CustomSnackbar.showSnackBar(
          context: context,
          title: "สำเร็จ",
          message: "ลบรูปโปรเจคเรียบร้อย",
          contentType: ContentType.success,
          color: Colors.green,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showSnackBar(
          context: context,
          title: "เกิดข้อผิดพลาด",
          message: "$e",
          contentType: ContentType.failure,
          color: Colors.red,
        );
      }
    }
  }
}


  /// ยืนยันลบโปรเจค
  Future<void> _confirmDeleteProject(BuildContext context) async {
  final bool? confirmDelete = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (context, anim1, anim2) => FadeTransition(
      opacity: anim1,
      child: ScaleTransition(
        scale: anim1,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: FloatingCard(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.orange, Colors.deepOrange]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.warning_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'ยืนยันการลบโปรเจค',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('คุณต้องการลบโปรเจคนี้ใช่หรือไม่?', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade600, width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          ),
                          child: const Text('ยกเลิก', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            backgroundColor: Colors.red.shade600,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('ลบ', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  if (confirmDelete == true) {
    try {
      await ref.read(deleteProjectHDControllerProvider.notifier)
          .deleteProjectHD(widget.projectHDModel.id!);
      ref.read(categoryProvider.notifier).getCategory(widget.category.workspaceId!);

      if (mounted) {
        CustomSnackbar.showSnackBar(
          context: context,
          title: "สำเร็จ",
          message: "ลบโปรเจคเรียบร้อย",
          contentType: ContentType.success,
          color: Colors.green,
        );
      }
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showSnackBar(
          context: context,
          title: "เกิดข้อผิดพลาด",
          message: "$e",
          contentType: ContentType.failure,
          color: Colors.red,
        );
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

      ref.read(categoryProvider.notifier)
          .getCategory(widget.category.workspaceId!);

      if (mounted) {
        CustomSnackbar.showSnackBar(
          context: context,
          title: "สำเร็จ",
          message: widget.projectHDModel.id == '0'
              ? "เพิ่มโปรเจคสำเร็จ"
              : "แก้ไขโปรเจคสำเร็จ",
          contentType: ContentType.success,
          color: Colors.green,
        );
        Navigator.of(context).pop(true);
      }
    } catch (e, stx) {
      print('Error: $e, StackTrace: $stx');
      if (mounted) {
        CustomSnackbar.showSnackBar(
          context: context,
          title: "ผิดพลาด",
          message: "$e",
          contentType: ContentType.failure,
          color: Colors.red,
        );
      }
    }
  }
}
