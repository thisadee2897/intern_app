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
  bool _isSubmitting = false; // สำหรับปุ่ม Insert/Update
  bool _isDeletingWorkspace = false; // สำหรับปุ่ม Delete Workspace
  bool _isDeletingImage = false;
  File? _tempImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workspace?.name ?? '');
    _isActive = true;
    final workspaceId = widget.workspace?.id ?? '0';

    if (widget.workspace == null) {
      _tempImage = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(workspaceImageProvider(workspaceId).notifier)
            .setInitialImage(null);
      });
    } else if (widget.workspace!.image != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(workspaceImageProvider(workspaceId).notifier)
            .setInitialImage(widget.workspace!.image);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.workspace != null;
    final workspaceId = widget.workspace?.id ?? '0';
    final imageState = ref.watch(workspaceImageProvider(workspaceId));

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isEdit ? 'Edit Workspace' : 'Insert Workspace',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              tooltip: 'Delete Workspace',
              onPressed:
                  _isDeletingWorkspace
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
                                        () => Navigator.pop(context, false),
                                    child: const Text('ยกเลิก'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text(
                                      'ลบ',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );
                        if (confirm != true) {
                          return; // ใช้ return ภายใน block {}
                        }

                        setState(() {
                          _isDeletingWorkspace = true; // ใส่ {} ให้ชัดเจน
                        });

                        try {
                          await ref
                              .read(deleteWorkspaceControllerProvider.notifier)
                              .deleteWorkspace(id: widget.workspace!.id!);

                          if (mounted) {
                            Navigator.pop(context, true); // block {}
                          }
                        } catch (e) {
                          if (mounted) {
                            // block {} ครอบ ScaffoldMessenger
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isDeletingWorkspace = false; // block {}
                            });
                          }
                        }
                      },
            ),
        ],
      ),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:
                                _tempImage != null
                                    ? Image.file(
                                      _tempImage!,
                                      width: 220,
                                      height: 220,
                                      fit: BoxFit.cover,
                                    )
                                    : imageState.when(
                                      data: (url) {
                                        if (url != null && url.isNotEmpty) {
                                          return CachedNetworkImage(
                                            imageUrl: url,
                                            fit: BoxFit.cover,
                                            width: 220,
                                            height: 220,
                                            placeholder:
                                                (c, u) => const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                            errorWidget:
                                                (c, u, e) =>
                                                    _buildUploadPlaceholder(
                                                      workspaceId,
                                                    ),
                                          );
                                        } else {
                                          return _buildUploadPlaceholder(
                                            workspaceId,
                                          );
                                        }
                                      },
                                      loading:
                                          () => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                      error:
                                          (e, st) => _buildUploadPlaceholder(
                                            workspaceId,
                                          ),
                                    ),
                          ),
                          if (_tempImage != null ||
                              (imageState.value?.isNotEmpty ?? false))
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                                onPressed:
                                    _isDeletingImage
                                        ? null
                                        : () async {
                                          await _deleteWorkspaceImage(
                                            workspaceId,
                                          );
                                        },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name Workspace *',
                    labelStyle: TextStyle(color: Colors.grey),

                    prefixIcon: Icon(
                      Icons.dashboard_customize_rounded,
                      color: Colors.blue,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  validator: (val) {
                    return (val == null || val.isEmpty)
                        ? 'กรุณากรอกชื่อ Workspace'
                        : null;
                  },
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text(
                    'เปิดใช้งาน Workspace (Active)',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: _isActive,
                  onChanged: (val) {
                    setState(() {
                      _isActive = val; // block {}
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false); // block {}
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : () => _handleSubmit(workspaceId),
          child:
              _isSubmitting
                  ? const SizedBox(
                    width: 20,
                    height: 20,
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

  Widget _buildUploadPlaceholder(String workspaceId) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.upload, size: 40),
            onPressed: () => _pickAndUploadWorkspaceImage(workspaceId),
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload Image\n(support file types: jpg, png)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadWorkspaceImage(String workspaceId) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result == null || result.files.single.bytes == null) {
        return;
      }
      final file = File(
        '${Directory.systemTemp.path}/${result.files.single.name}',
      );
      await file.writeAsBytes(result.files.single.bytes!);
      if (widget.workspace != null) {
        await ref
            .read(workspaceImageProvider(workspaceId).notifier)
            .uploadWorkspaceImage(file);
      } else {
        setState(() {
          _tempImage = file;
        });
      }

      // ✅ ใส่ block {} ครอบ ScaffoldMessenger
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('เลือกรูปภาพเรียบร้อย')));
      }
    } catch (e) {
      // ✅ ใส่ block {} ครอบ ScaffoldMessenger
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
      }
    }
  }

  Future<void> _handleSubmit(String workspaceId) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      String? imageUrl;

      if (_tempImage != null) {
        // Upload รูป
        await ref
            .read(workspaceImageProvider(workspaceId).notifier)
            .uploadWorkspaceImage(_tempImage!);

        // อ่านค่า URL หลัง upload เสร็จ
        imageUrl = ref.read(workspaceImageProvider(workspaceId)).value;
        _tempImage = null;
      } else {
        imageUrl = ref.read(workspaceImageProvider(workspaceId)).value;
      }

      // Insert หรือ Update
      await ref
          .read(insertUpdateWorkspaceControllerProvider.notifier)
          .insertOrUpdateWorkspace(
            id: widget.workspace?.id ?? workspaceId,
            name: _nameController.text.trim(),
            active: _isActive,
            image: imageUrl,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('บันทึก Workspace สำเร็จ')),
        );
        Navigator.of(context).pop(true); // ปิด Dialog
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false); // ปลดปุ่ม
    }
  }

  Future<void> _deleteWorkspaceImage(String workspaceId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('ยืนยันการลบ'),
            content: const Text('คุณต้องการลบรูป Workspace หรือไม่?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('ลบ', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
    if (confirm != true) {
      return;
    }
    setState(() {
      _isDeletingImage = true;
    });
    try {
      final imageNotifier = ref.read(
        workspaceImageProvider(workspaceId).notifier,
      );
      if (_tempImage != null) {
        _tempImage = null;
      } else if (widget.workspace != null &&
          (imageNotifier.state.value?.isNotEmpty ?? false)) {
        await imageNotifier.deleteWorkspaceImage();
        await ref
            .read(insertUpdateWorkspaceControllerProvider.notifier)
            .insertOrUpdateWorkspace(
              id: widget.workspace!.id!,
              name: _nameController.text.trim(),
              active: _isActive,
              image: null,
            );
      }
      imageNotifier.setInitialImage(null);
      ref.invalidate(workspaceControllerProvider);

      // ✅ ใส่ block {} ครอบ ScaffoldMessenger
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ลบรูป Workspace สำเร็จ')));
      }
    } catch (e) {
      // ✅ ใส่ block {} ครอบ ScaffoldMessenger
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาดในการลบรูป: $e')));
      }
    } finally {
      setState(() {
        _isDeletingImage = false;
      });
    }
  }
}
