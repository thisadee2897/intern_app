import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/components/export.dart';
import 'package:project/models/user_model.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/home/providers/controllers/delete_workspace_controllers.dart';
import 'package:project/screens/home/providers/controllers/insert_update_workspace_controllers.dart';
import 'package:project/screens/home/providers/controllers/image_workspace_controllers.dart';
import 'package:project/screens/project/category/providers/controllers/workspace_controller.dart';

final dataUserProvider = StateProvider<UserModel>(
  (ref) => UserModel(id: '0', name: '', active: true),
);

class InsertUpdateWorkspaceDialog extends ConsumerStatefulWidget {
  final WorkspaceModel? workspace;
  const InsertUpdateWorkspaceDialog({super.key, this.workspace});

  @override
  ConsumerState<InsertUpdateWorkspaceDialog> createState() =>
      _InsertUpdateWorkspaceDialogState();
}

class _InsertUpdateWorkspaceDialogState
    extends ConsumerState<InsertUpdateWorkspaceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isActive = true;
  bool _isLoading = false;
  File? _tempImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workspace?.name ?? '');
    _isActive = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ref ใช้งานได้ตรงนี้
    final isEdit = widget.workspace != null;
    final workspaceId = widget.workspace?.id ?? '0';
    final imageUrl = ref.watch(workspaceImageProvider(workspaceId));

    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(20),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isEdit ? 'Edit Workspace' : 'Insert Workspace',
            style: TextStyle(
              backgroundColor: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isEdit)
            IconButton(
              onPressed:
                  _isLoading
                      ? null
                      : () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text('ยืนยันการลบ Workspace'),
                                content: const Text(
                                  'คุณแน่ใจว่าต้องการลบ workspace นี้?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: const Text('ยกเลิก'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    child: const Text(
                                      'ลบ',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          setState(() => _isLoading = true);
                          try {
                            await ref
                                .read(
                                  deleteWorkspaceControllerProvider.notifier,
                                )
                                .deleteWorkspace(id: widget.workspace!.id!);

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ลบ Workspace สำเร็จ'),
                                ),
                              );
                              Navigator.of(context).pop(true); // ปิด dialog
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        }
                      },
              icon: const Icon(Icons.delete, color: Colors.grey),
              tooltip: 'Delete Workspace',
            ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // ช่องเพิ่มรูปภาพ
              Center(
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: Colors.grey,
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
                            borderRadius: BorderRadius.circular(8),
                            child: () {
                              // Insert Mode → แสดงรูป temp ถ้ามี
                              if (_tempImage != null) {
                                return Image.file(
                                  _tempImage!,
                                  fit: BoxFit.cover,
                                  height: 210,
                                  width: 210,
                                );
                              }

                              final wsImage = widget.workspace?.image ?? '';
                              if (wsImage.isNotEmpty) {
                                return CachedNetworkImage(
                                  imageUrl: wsImage,
                                  fit: BoxFit.cover,
                                  height: 210,
                                  width: 210,
                                );
                              }

                              // 2) ถ้า edit และ server มี URL → แสดงรูปจาก server
                              if (isEdit &&
                                  imageUrl?.value != null &&
                                  imageUrl!.value!.isNotEmpty) {
                                return CachedNetworkImage(
                                  imageUrl: imageUrl.value!,
                                  fit: BoxFit.cover,
                                  height: 210,
                                  width: 210,
                                  placeholder:
                                      (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  errorWidget:
                                      (context, url, error) => const Center(
                                        child: Text('โหลดรูปไม่สำเร็จ'),
                                      ),
                                );
                              }

                              // 3) Default → ปุ่ม upload
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await _pickAndUploadWorkspaceImage(
                                        ref,
                                      ); // ← เรียกใช้ฟังก์ชันใหม่
                                    },
                                    icon: const Icon(
                                      Icons.upload,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'อัพโหลดรูปภาพ Workspace',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            }(),
                          ),
                        ),
                        if (isEdit &&
                            imageUrl?.value != null &&
                            imageUrl!.value!.isNotEmpty)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              onPressed: () async {
                                await _deleteWorkspaceImage(ref, workspaceId);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // ช่องกรอกชื่อ
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name Workspace *',
                  prefixIcon: const Icon(
                    Icons.dashboard_customize_rounded,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: TextStyle(fontSize: 20),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'กรุณากรอกชื่อ Workspace';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Switch Active
              SwitchListTile(
                title: Text(
                  'เปิดใช้งาน Workspace (Active)',
                  style: TextStyle(fontSize: 20),
                ),
                value: _isActive,
                onChanged: (val) {
                  setState(() {
                    _isActive = val;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          child:
              _isLoading
                  ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(isEdit ? 'Update' : 'Insert'),
        ),
      ],
    );
  }

  // เลือกรูป: Insert → เก็บ temp, Edit → อัพโหลดเลย
  // Future<void> _pickAndUploadWorkspaceImage(WidgetRef ref,
  //     String workspaceId, bool isEdit
  // ) async {
  //   try {
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowMultiple: false,
  //       allowedExtensions: const ['jpg', 'jpeg', 'png'],
  //       withData: true,
  //     );

  //     if (result != null && result.files.single.bytes != null) {
  //       final platformFile = result.files.single;
  //       final bytes = platformFile.bytes!;
  //       final tempDir = Directory.systemTemp;
  //       final fileName = platformFile.name;
  //       final tempFile = File('${tempDir.path}/$fileName');
  //       await tempFile.writeAsBytes(bytes);

  //       if (isEdit) {
  //         // Edit → อัพโหลดทันที
  //         final uploadedUrl = await ref
  //             .read(workspaceImageProvider(workspaceId).notifier)
  //             .uploadWorkspaceImage(tempFile); // ✅ ใช้ tempFile ที่เพิ่งสร้าง

  //         // update workspace ใน DB
  //         await ref
  //             .read(insertUpdateWorkspaceControllerProvider.notifier)
  //             .insertOrUpdateWorkspace(
  //               id: workspaceId,
  //               name: _nameController.text.trim(),
  //               active: _isActive,
  //               image: uploadedUrl, // ✅ ต้องส่ง image ด้วย
  //             );

  //         // update state
  //         ref.read(dataUserProvider.notifier).state = ref
  //             .read(dataUserProvider)
  //             .copyWith(image: uploadedUrl);

  //         if (mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('อัพโหลดรูป Workspace สำเร็จ')),
  //           );
  //         }
  //       } else {
  //         // Insert → เก็บ temp ไว้ก่อน (ยังไม่อัพโหลด)
  //         setState(() {
  //           _tempImage = tempFile;
  //         });

  //         if (mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('เลือกรูปภาพเรียบร้อย')),
  //           );
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
  //     }
  //   }
  // }

  Future<void> _pickAndUploadWorkspaceImage(WidgetRef ref) async {
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

        // ✅ อัพเดต state ให้ UI render ภาพทันที
        setState(() {
          _tempImage = tempFile;
        });

        // ✅ ถ้ามี workspaceId แล้ว (edit mode) → อัพโหลดทันที
        if (widget.workspace?.id != null) {
          final uploadedUrl = await ref
              .read(workspaceImageProvider(widget.workspace!.id!).notifier)
              .uploadWorkspaceImage(tempFile);

          // ✅ update workspace ให้ image ถูกบันทึกจริงใน DB
          await ref
              .read(insertUpdateWorkspaceControllerProvider.notifier)
              .insertOrUpdateWorkspace(
                id: widget.workspace!.id!,
                name: widget.workspace!.name ?? _nameController.text.trim(),
                active: _isActive,
                image: uploadedUrl, // << บันทึกลง DB
              );

          // update state สำหรับ UI ตอนนี้
          ref.read(dataUserProvider.notifier).state = ref
              .read(dataUserProvider)
              .copyWith(image: uploadedUrl);
        }

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('เลือกรูปภาพสำเร็จ')));
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

  Future<void> _deleteWorkspaceImage(WidgetRef ref, String workspaceId) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('ยืนยันการลบ'),
            content: const Text('คุณต้องการลบรูป Workspace หรือไม่?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('ลบ', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmDelete == true) {
      await ref
          .read(workspaceImageProvider(workspaceId).notifier)
          .deleteWorkspaceImage(workspaceId);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ลบรูป Workspace สำเร็จ')));
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      // 1) Insert workspace ก่อน (ยังไม่ส่ง image)
      final newWorkspace = await ref
          .read(insertUpdateWorkspaceControllerProvider.notifier)
          .insertOrUpdateWorkspace(
            id: widget.workspace?.id ?? '0',
            name: _nameController.text.trim(),
            active: _isActive,
            image: '',
          );

      String? uploadedUrl;

      // 2) ถ้ามี _tempImage → upload หลัง insert
      if (_tempImage != null) {
        uploadedUrl = await ref
            .read(workspaceImageProvider(newWorkspace.id!).notifier)
            .uploadWorkspaceImage(_tempImage!);

        if (uploadedUrl == null || uploadedUrl.isEmpty) {
          throw Exception('Upload รูปภาพล้มเหลว');
        }

        // 3) update workspace อีกครั้ง พร้อม image
        await ref
            .read(insertUpdateWorkspaceControllerProvider.notifier)
            .insertOrUpdateWorkspace(
              id: newWorkspace.id!,
              name: newWorkspace.name ?? _nameController.text.trim(),
              active: _isActive,
              image: uploadedUrl,
            );
      }

      // 4) update local state ให้หน้า UI แสดงภาพ
      ref.read(dataUserProvider.notifier).state = ref
          .read(dataUserProvider)
          .copyWith(image: uploadedUrl ?? newWorkspace.image);

      // 5) refresh workspace list
      await ref
          .read(workspaceControllerProvider.notifier)
          .fetchWorkspaces(newWorkspace.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึก Workspace สำเร็จ')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // }

  //   /// ฟังก์ชันเลือกภาพ (ไม่ upload ทันที)
  //   Future<void> _pickImage() async {
  //     final result = await FilePicker.platform.pickFiles(type: FileType.image);
  //     if (result != null && result.files.isNotEmpty) {
  //       setState(() {
  //         _tempImage = File(result.files.single.path!); // เก็บไฟล์ไว้เฉย ๆ
  //       });
  //     }
  //   }

  // @override
  // Widget buildTablet(
  //   BuildContext context,
  //   SizingInformation sizingInformation,
  // ) => buildDesktop(context, sizingInformation);

  // @override
  // Widget buildMobile(
  //   BuildContext context,
  //   SizingInformation sizingInformation,
  // ) => buildDesktop(context, sizingInformation);
}
