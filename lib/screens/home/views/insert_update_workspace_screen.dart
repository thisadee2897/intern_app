import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/components/export.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/home/providers/controllers/delete_workspace_controllers.dart';
import 'package:project/screens/home/providers/controllers/insert_update_workspace_controllers.dart';
import 'package:project/screens/home/providers/controllers/image_workspace_controllers.dart';
import 'package:project/screens/project/category/providers/controllers/workspace_controller.dart';

class InsertUpdateWorkspaceDialog extends BaseStatefulWidget {
  final WorkspaceModel? workspace; // null = insert, not null = update
  const InsertUpdateWorkspaceDialog({super.key, this.workspace});

  @override
  BaseState<InsertUpdateWorkspaceDialog> createState() =>
      _InsertUpdateWorkspaceDialogState();
}

class _InsertUpdateWorkspaceDialogState
    extends BaseState<InsertUpdateWorkspaceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isActive = true;
  bool _isLoading = false;
  File? _tempImage; // สำหรับ insert mode เก็บไฟล์ก่อนสร้าง workspace

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workspace?.name ?? '');
    _isActive = true; // ดึงค่า active ของ workspace จริง
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget buildDesktop(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    final isEdit = widget.workspace != null;
    final double baseFontSize =
        MediaQuery.of(context).size.width < 600 ? 14 : 16;

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
              fontSize: baseFontSize + 4,
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
                              if (!isEdit && _tempImage != null) {
                                return Image.file(
                                  _tempImage!,
                                  fit: BoxFit.cover,
                                  height: 210,
                                  width: 210,
                                );
                              }

                              // Edit Mode → แสดงรูปจาก server ถ้ามี
                              if (isEdit &&
                                  imageUrl?.value != null &&
                                  imageUrl!.value!.isNotEmpty) {
                                return CachedNetworkImage(
                                  imageUrl: imageUrl.value!,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  errorWidget:
                                      (context, url, error) => const Center(
                                        child: Text('โหลดรูปไม่สำเร็จ'),
                                      ),
                                  height: 210,
                                  width: 210,
                                );
                              }

                              // Default → ปุ่มอัพโหลด
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await _pickAndUploadWorkspaceImage(
                                        ref,
                                        workspaceId,
                                        isEdit,
                                      );
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
                style: TextStyle(fontSize: baseFontSize),
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
                  style: TextStyle(fontSize: baseFontSize),
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
  Future<void> _pickAndUploadWorkspaceImage(
    WidgetRef ref,
    String workspaceId,
    bool isEdit,
  ) async {
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

        if (isEdit) {
          // Edit → อัพโหลดทันที
          await ref
              .read(workspaceImageProvider(workspaceId).notifier)
              .uploadWorkspaceImage(tempFile);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('อัพโหลดรูป Workspace สำเร็จ')),
            );
          }
        } else {
          // Insert → เก็บ temp ไว้ก่อน
          setState(() {
            _tempImage = tempFile;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('เลือกรูปภาพเรียบร้อย')),
            );
          }
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
          .deleteWorkspaceImage();

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
      final newWorkspace = await ref
          .read(insertUpdateWorkspaceControllerProvider.notifier)
          .insertOrUpdateWorkspace(
            id: widget.workspace?.id ?? '0',
            name: _nameController.text.trim(),
            active: _isActive,
          );

      // Insert → upload temp image
      if (widget.workspace == null && _tempImage != null) {
        await ref
            .read(workspaceImageProvider(newWorkspace.id!).notifier)
            .uploadWorkspaceImage(_tempImage!);
      }

      if (mounted) {
        // แสดง SnackBar หลังอัปเดต/สร้าง workspace
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.workspace == null
                  ? 'สร้าง Workspace สำเร็จ'
                  : 'อัปเดต Workspace สำเร็จ',
            ),
          ),
        );
      }

      // Refresh list
      await ref
          .read(workspaceControllerProvider.notifier)
          .fetchWorkspaces(newWorkspace.id!);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget buildTablet(
    BuildContext context,
    SizingInformation sizingInformation,
  ) => buildDesktop(context, sizingInformation);

  @override
  Widget buildMobile(
    BuildContext context,
    SizingInformation sizingInformation,
  ) => buildDesktop(context, sizingInformation);
}
