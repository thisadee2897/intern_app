import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/home/providers/controllers/delete_workspace_controllers.dart';
import 'package:project/screens/home/providers/controllers/insert_update_workspace_controllers.dart';

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
  Widget buildDesktop(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    final isEdit = widget.workspace != null;
    final double baseFontSize =
        MediaQuery.of(context).size.width < 600 ? 14 : 16;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isEdit ? 'Edit Workspace' : 'Insert Workspace',
            style: TextStyle(fontSize: baseFontSize + 4),
          ),
          if (isEdit) // แสดงปุ่มลบเฉพาะตอนแก้ไข
            IconButton(
              tooltip: 'Delete Workspace',
              icon: const Icon(Icons.delete, color: Colors.grey),
              iconSize: 16,
              onPressed:
                  _isLoading
                      ? null
                      : () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                  'คุณต้องการลบ Workspace นี้หรือไม่?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          try {
                            setState(() => _isLoading = true);

                            // เรียก API ลบ workspace
                            await ref
                                .read(
                                  deleteWorkspaceControllerProvider.notifier,
                                )
                                .deleteWorkspace(id: widget.workspace!.id!);

                            if (!mounted) return;
                            Navigator.of(context).pop(
                              true,
                            ); // ส่ง true กลับไปบอกว่ามีการเปลี่ยนแปลง
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('ลบไม่สำเร็จ: $e')),
                            );
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        }
                      },
            ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400, // กำหนดความกว้าง dialog
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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

              // ปุ่มเปิดปิด Active
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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(insertUpdateWorkspaceControllerProvider.notifier)
          .insertOrUpdateWorkspace(
            id: widget.workspace?.id ?? '0',
            name: _nameController.text.trim(),
            active: _isActive,
          );
      if (!mounted) return;

      Navigator.of(context).pop(true); // ส่ง true กลับไปบอกว่าบันทึกแล้ว
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
