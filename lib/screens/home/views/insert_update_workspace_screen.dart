import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart'; // ต้อง import ถ้าใช้ DioException
import 'package:project/components/export.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/home/providers/controllers/delete_workspace_controllers.dart';
import 'package:project/screens/home/providers/controllers/insert_update_workspace_controllers.dart';
import 'package:project/screens/home/providers/controllers/image_workspace_controllers.dart';
import 'package:project/utils/extension/custom_snackbar.dart';

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
  bool _isSubmitting = false;
  bool _isDeletingWorkspace = false;
  bool _isDeletingImage = false;
  File? _tempImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workspace?.name ?? '');
    _isActive = true;
    final workspaceId = widget.workspace?.id ?? '0';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(workspaceImageProvider(workspaceId).notifier)
          .setInitialImage(widget.workspace?.image);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// ✅ ฟังก์ชันดึงข้อความ error ให้เหลือสั้น ๆ
  String _extractErrorMessage(dynamic error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map) {
        if (data['message'] != null) {
          return data['message'];
        } else if (data['detail'] != null) {
          return data['detail']; // ✅ รองรับ field detail
        }
      }

      return data?.toString() ?? error.message ?? 'Unknown error';
    }
    return error.toString();
  }

  Future<void> _showErrorDialog(String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.error, color: Colors.red.shade600, size: 40),
                const SizedBox(width: 20),

                const Text('เกิดข้อผิดพลาด'),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ตกลง'),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteWorkspace() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('ยืนยันการลบ Workspace'),
            content: const Text('คุณแน่ใจว่าต้องการลบ workspace นี้?'),
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

    if (confirm != true) return;

    setState(() => _isDeletingWorkspace = true);

    try {
      await ref
          .read(deleteWorkspaceControllerProvider.notifier)
          .deleteWorkspace(id: widget.workspace!.id!);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      await _showErrorDialog(_extractErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isDeletingWorkspace = false);
    }
  }

  Future<void> _deleteWorkspaceImage(String workspaceId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('ยืนยันการลบรูป'),
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

    if (confirm != true) return;

    setState(() => _isDeletingImage = true);

    try {
      final imageNotifier = ref.read(
        workspaceImageProvider(workspaceId).notifier,
      );

      if (widget.workspace == null) {
        setState(() => _tempImage = null);
        imageNotifier.setInitialImage(null);
      } else {
        await imageNotifier.deleteWorkspaceImage();
        await ref
            .read(insertUpdateWorkspaceControllerProvider.notifier)
            .insertOrUpdateWorkspace(
              id: widget.workspace!.id!,
              name: _nameController.text.trim(),
              active: _isActive,
              image: null,
            );
        imageNotifier.setInitialImage(null);
      }
    } catch (e) {
      await _showErrorDialog(_extractErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isDeletingImage = false);
    }
  }

  Future<void> _pickAndUploadWorkspaceImage(String workspaceId) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result == null || result.files.single.bytes == null) return;

      final file = File(
        '${Directory.systemTemp.path}/${result.files.single.name}',
      );
      await file.writeAsBytes(result.files.single.bytes!);

      if (widget.workspace != null) {
        await ref
            .read(workspaceImageProvider(workspaceId).notifier)
            .uploadWorkspaceImage(file);
      } else {
        setState(() => _tempImage = file);
      }

      if (mounted) {
  CustomSnackbar.showSnackBar(
    context: context,
    title: "สำเร็จ",
    message: "เลือกรูปภาพเรียบร้อย",
    contentType: ContentType.success,
    color: Colors.green,
  );
}
   } catch (e) {
  if (mounted) {
    CustomSnackbar.showSnackBar(
      context: context,
      title: "ผิดพลาด",
      message: _extractErrorMessage(e),
      contentType: ContentType.failure,
      color: Colors.red,
    );
  }
}
  }

 Future<void> _handleSubmit(String workspaceId) async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isSubmitting = true);

  try {
    String? imageUrl;

    if (_tempImage != null) {
      await ref
          .read(workspaceImageProvider(workspaceId).notifier)
          .uploadWorkspaceImage(_tempImage!);

      imageUrl = ref.read(workspaceImageProvider(workspaceId)).value;
      _tempImage = null;
    } else {
      imageUrl = ref.read(workspaceImageProvider(workspaceId)).value;
    }

    final isUpdate = widget.workspace != null;

    await ref
        .read(insertUpdateWorkspaceControllerProvider.notifier)
        .insertOrUpdateWorkspace(
          id: widget.workspace?.id ?? workspaceId,
          name: _nameController.text.trim(),
          active: _isActive,
          image: imageUrl,
        );

    if (mounted) {
      CustomSnackbar.showSnackBar(
        context: context,
        title: "สำเร็จ",
        message: isUpdate ? "อัปเดต Workspace สำเร็จ" : "สร้าง Workspace สำเร็จ",
        contentType: ContentType.success,
        color: Colors.green,
      );
      Navigator.of(context).pop(true);
    }
  } catch (e) {
    if (mounted) {
      CustomSnackbar.showSnackBar(
        context: context,
        title: "ผิดพลาด",
        message: _extractErrorMessage(e),
        contentType: ContentType.failure,
        color: Colors.red,
      );
    }
  } finally {
    if (mounted) setState(() => _isSubmitting = false);
  }
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
              onPressed: _isDeletingWorkspace ? null : _deleteWorkspace,
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
                                        : () =>
                                            _deleteWorkspaceImage(workspaceId),
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
                  validator:
                      (val) =>
                          (val == null || val.isEmpty)
                              ? 'กรุณากรอกชื่อ Workspace'
                              : null,
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text(
                    'เปิดใช้งาน Workspace (Active)',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: _isActive,
                  onChanged: (val) => setState(() => _isActive = val),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
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
}
