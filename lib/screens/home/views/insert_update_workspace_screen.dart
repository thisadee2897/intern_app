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

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    final double baseFontSize = isSmallScreen ? 14 : 16;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Workspace' : 'Insert Workspace',
          style: TextStyle(fontSize: baseFontSize + 10),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ช่องกรอกชื่อ
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name Workspace *',
                  prefixIcon: const Icon(Icons.dashboard_customize_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.indigo,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.2,
                    ),
                  ),
                  hoverColor: Colors.indigo.withOpacity(0.05),
                ),
                style: TextStyle(fontSize: baseFontSize),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'กรุณากรอกชื่อ Workspace';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

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
              const SizedBox(height: 25),

              // ปุ่มบันทึก
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 243, 242, 242), // สีพื้นหลังปุ่ม
                        foregroundColor: const Color.fromARGB(199, 230, 33, 66), // สีตัวอักษร
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width < 500 ? 12 : 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 243, 242, 242), // สีพื้นหลังปุ่ม
                        foregroundColor: const Color.fromARGB(199, 78, 90, 222), // สีตัวอักษร
                      ),
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
                              : Text(
                                isEdit
                                    ? 'Update Workspace'
                                    : 'Insert Workspace',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width < 500
                                          ? 12
                                          : 16,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
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
          if (!mounted) return; // <--- เพิ่มบรรทัดนี้

      _showSuccessSnackBar(
        widget.workspace == null
            ? 'Insert Workspace เรียบร้อย'
            : 'Update Workspace เรียบร้อย',
      );

      Navigator.of(
        context,
      ).pop(true); // ส่งกลับ true เพื่อบอกให้รีเฟรชหน้าก่อนหน้า
    } catch (e) {
      if (!mounted) return; // <--- เพิ่มบรรทัดนี้
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
        backgroundColor: const Color.fromARGB(255, 11, 41, 66),
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
