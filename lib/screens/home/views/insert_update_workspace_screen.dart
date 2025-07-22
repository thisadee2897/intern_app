import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/home/providers/controllers/insert_update_workspace_controllers.dart';

class InsertUpdateWorkspaceScreen extends BaseStatefulWidget {
  final WorkspaceModel? workspace; // null = insert, not null = update
  const InsertUpdateWorkspaceScreen({super.key, this.workspace});

  @override
  BaseState<InsertUpdateWorkspaceScreen> createState() =>
      _InsertUpdateWorkspaceScreenState();
}

class _InsertUpdateWorkspaceScreenState
    extends BaseState<InsertUpdateWorkspaceScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workspace?.name ?? '');
    // _isActive = widget.workspace?.active ?? true;  // กำหนดค่าเริ่มต้นจาก model ถ้ามี
    _isActive = true; // ตั้งค่า default เป็น true เสมอ (แก้ไขหรือเพิ่มก็ได้)
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

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'แก้ไข Workspace' : 'เพิ่ม Workspace ใหม่'),
        backgroundColor: const Color.fromARGB(255, 24, 87, 118),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ช่องกรอกชื่อ
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อ Workspace *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.workspace_premium),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'กรุณากรอกชื่อ Workspace';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ปุ่มเปิดปิด Active
              SwitchListTile(
                title: const Text('เปิดใช้งาน Workspace (Active)'),
                value: _isActive,
                onChanged: (val) {
                  setState(() {
                    _isActive = val;
                  });
                },
              ),

              const SizedBox(height: 32),

              // ปุ่มบันทึก
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('ยกเลิก'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                isEdit ? 'อัปเดต Workspace' : 'เพิ่ม Workspace',
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

      _showSuccessSnackBar(
        widget.workspace == null
            ? 'เพิ่ม Workspace เรียบร้อย'
            : 'อัปเดต Workspace เรียบร้อย',
      );

      Navigator.of(
        context,
      ).pop(true); // ส่งกลับ true เพื่อบอกให้รีเฟรชหน้าก่อนหน้า
    } catch (e) {
      _showErrorSnackBar('เกิดข้อผิดพลาด: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(msg),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
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
