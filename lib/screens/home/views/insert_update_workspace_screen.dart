import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/auth/widgets/glass_container.dart';
import 'package:project/screens/home/providers/controllers/delete_workspace_controllers.dart';
import 'package:project/screens/home/providers/controllers/insert_update_workspace_controllers.dart';
import 'package:project/screens/home/providers/controllers/image_workspace_controllers.dart';
import 'package:project/utils/extension/custom_snackbar.dart';
import 'package:project/utils/extension/hex_color.dart';

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

  String _extractErrorMessage(dynamic error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        if (data['message'] != null) return data['message'];
        if (data['detail'] != null) return data['detail'];
      }
      return data?.toString() ?? error.message ?? 'Unknown error';
    }
    return error.toString();
  }

  // ใช้ FloatingCard แทน AlertDialog
  Future<void> _showErrorDialog(String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: FloatingCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade600, size: 40),
                  const SizedBox(width: 16),
                  const Text('เกิดข้อผิดพลาด',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              Text(message, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    const Text('ตกลง', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Confirm Dialog แบบ FloatingCard
  Future<bool?> _showConfirmDialog({
  required String title,
  required String content,
  String confirmText = 'ตกลง',
  Color confirmColor = Colors.red,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24), // ลดขอบ
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320), // ลดความกว้าง
        child: FloatingCard(
          padding: const EdgeInsets.all(20), // ลด padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 12),
              Text(content, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: HexColor.fromHex('#002B77'), width: 2),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                    ),
                    child: const Text('ยกเลิก', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: confirmColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                    ),
                    child: Text(confirmText,
                        style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  Future<void> _deleteWorkspace() async {
    final confirm = await _showConfirmDialog(
      title: 'ยืนยันการลบ Workspace',
      content: 'คุณแน่ใจว่าต้องการลบ workspace นี้?',
      confirmText: 'ลบ',
      confirmColor: Colors.red,
    );
    if (confirm != true) return;

    setState(() => _isDeletingWorkspace = true);
    try {
      await ref
          .read(deleteWorkspaceControllerProvider.notifier)
          .deleteWorkspace(id: widget.workspace!.id!);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      await _showErrorDialog(_extractErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isDeletingWorkspace = false);
    }
  }

  Future<void> _deleteWorkspaceImage(String workspaceId) async {
    final confirm = await _showConfirmDialog(
      title: 'ยืนยันการลบรูป',
      content: 'คุณต้องการลบรูป Workspace หรือไม่?',
      confirmText: 'ลบ',
      confirmColor: Colors.red,
    );
    if (confirm != true) return;

    setState(() => _isDeletingImage = true);
    try {
      final imageNotifier = ref.read(workspaceImageProvider(workspaceId).notifier);
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

      if (mounted)
        CustomSnackbar.showSnackBar(
          context: context,
          title: "สำเร็จ",
          message: "เลือกรูปภาพเรียบร้อย",
          contentType: ContentType.success,
          color: Colors.green,
        );
    } catch (e) {
      if (mounted)
        CustomSnackbar.showSnackBar(
          context: context,
          title: "ผิดพลาด",
          message: _extractErrorMessage(e),
          contentType: ContentType.failure,
          color: Colors.red,
        );
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
          message:
              isUpdate ? "อัปเดต Workspace สำเร็จ" : "สร้าง Workspace สำเร็จ",
          contentType: ContentType.success,
          color: Colors.green,
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted)
        CustomSnackbar.showSnackBar(
          context: context,
          title: "ผิดพลาด",
          message: _extractErrorMessage(e),
          contentType: ContentType.failure,
          color: Colors.red,
        );
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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: FloatingCard(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEdit ? 'Edit Workspace' : 'Insert Workspace',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (isEdit)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Color.fromARGB(255, 224, 33, 33)),
                          tooltip: 'Delete Workspace',
                          onPressed:
                              _isDeletingWorkspace ? null : _deleteWorkspace,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Image Upload
                  Center(
                    child: DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        color: Colors.white70,
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
                              child: _tempImage != null
                                  ? Image.file(
                                      _tempImage!,
                                      width: 220,
                                      height: 220,
                                      fit: BoxFit.cover,
                                    )
                                  : imageState.when(
                                      data: (url) => (url != null && url.isNotEmpty)
                                          ? CachedNetworkImage(
                                              imageUrl: url,
                                              fit: BoxFit.cover,
                                              width: 220,
                                              height: 220,
                                              placeholder: (c, u) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget: (c, u, e) =>
                                                  _buildUploadPlaceholder(
                                                workspaceId,
                                              ),
                                            )
                                          : _buildUploadPlaceholder(workspaceId),
                                      loading: () => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      error: (e, st) =>
                                          _buildUploadPlaceholder(workspaceId),
                                    ),
                            ),
                            if (_tempImage != null ||
                                (imageState.value?.isNotEmpty ?? false))
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 236, 50, 50),
                                  ),
                                  onPressed: _isDeletingImage
                                      ? null
                                      : () => _deleteWorkspaceImage(workspaceId),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name Workspace
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Name Workspace *',
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(
                        Icons.dashboard_customize_rounded,
                        color: Colors.blue,
                      ),
                      filled: true,
                      fillColor: HexColor.fromHex('#001B4B'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: HexColor.fromHex('#00C6FF'),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (val) =>
                        (val == null || val.isEmpty)
                            ? 'กรุณากรอกชื่อ Workspace'
                            : null,
                  ),
                  const SizedBox(height: 20),

                  // Active Switch
                  SwitchListTile(
                    title: const Text(
                      'เปิดใช้งาน Workspace (Active)',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    value: _isActive,
                    onChanged: (val) => setState(() => _isActive = val),
                  ),

                  const SizedBox(height: 24),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: HexColor.fromHex('#002B77'),
                            width: 2,
                          ),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 28,
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed:
                            _isSubmitting ? null : () => _handleSubmit(workspaceId),
                        style: FilledButton.styleFrom(
                          backgroundColor: HexColor.fromHex('#003B99'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 28,
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isEdit ? 'Update' : 'Insert',
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
    );
  }
}
