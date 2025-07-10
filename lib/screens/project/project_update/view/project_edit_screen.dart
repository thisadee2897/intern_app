import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/screens/project/project_update/provider/controllers/delete_projectController.dart';
import 'package:project/screens/project/project_update/provider/controllers/project_updateController.dart';

class ProjectEditScreen extends BaseStatefulWidget {
  final dynamic project;
  const ProjectEditScreen({super.key, required this.project});

  @override
  BaseState<ProjectEditScreen> createState() => _ProjectEditScreenState();
}

class _ProjectEditScreenState extends BaseState<ProjectEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _keyController;
  late TextEditingController _descriptionController;

  String? _selectedCategoryId;
  final String _defaultLeadId = '1';
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name ?? '');
    _keyController = TextEditingController(text: widget.project.key ?? '');
    _descriptionController = TextEditingController(text: widget.project.description ?? '');
    _selectedCategoryId = widget.project.categoryId ?? widget.project.projectCategoryId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _keyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      'id': widget.project.id.toString(),
      'name': _nameController.text.trim(),
      'key': _keyController.text.trim(),
      'description': _descriptionController.text.trim(),
      'project_category_id': _selectedCategoryId,
      'lead_id': _defaultLeadId,
    };

    await ref.read(projectUpdateControllerProvider.notifier).submitProjectHD(body: body);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ แก้ไขโปรเจกต์เรียบร้อยแล้ว'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop(true);
    }
  }

  void _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบโปรเจกต์นี้? การกระทำนี้ไม่สามารถย้อนกลับได้'),
        actions: [
          TextButton(
            child: const Text('ยกเลิก'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ตกลง'),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(deleteProjectHDControllerProvider.notifier).deleteProject(widget.project.id.toString());

        if (mounted) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ ลบโปรเจกต์เรียบร้อยแล้ว')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ ล้มเหลว: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    final categoryAsyncValue = ref.watch(categoryListProvider('1'));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('เเก้ไขโปรเจกต์', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage('https://images.pexels.com/photos/314726/pexels-photo-314726.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.15), BlendMode.darken),
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.88),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text(
                        'รายละเอียดโปรเจกต์',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'ชื่อโปรเจกต์',
                          prefixIcon: const Icon(Icons.title),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: const Color(0xFFF6F8FB),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกชื่อโปรเจกต์' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _keyController,
                        decoration: InputDecoration(
                          labelText: 'รหัสโปรเจกต์ (key)',
                          prefixIcon: const Icon(Icons.vpn_key),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: const Color(0xFFF6F8FB),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกรหัสโปรเจกต์' : null,
                      ),
                      const SizedBox(height: 20),
                      categoryAsyncValue.when(
                        data: (categories) {
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'หมวดหมู่',
                              prefixIcon: const Icon(Icons.category),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: const Color(0xFFF6F8FB),
                            ),
                            value: _selectedCategoryId,
                            items: categories.map<DropdownMenuItem<String>>((cat) {
                              return DropdownMenuItem<String>(
                                value: cat.id,
                                child: Text(cat.name ?? '-'),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _selectedCategoryId = value),
                            validator: (value) => value == null ? 'กรุณาเลือกหมวดหมู่' : null,
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, _) => Text('โหลดหมวดหมู่ล้มเหลว: $error'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'คำอธิบาย',
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: const Color(0xFFF6F8FB),
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 32),
                      MouseRegion(
                        onEnter: (_) => setState(() => _isHovering = true),
                        onExit: (_) => setState(() => _isHovering = false),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: _isHovering ? 1.05 : 1.0,
                          child: ElevatedButton.icon(
                            onPressed: _submit,
                            icon: const Icon(Icons.save),
                            label: const Text('อัปเดตโปรเจกต์', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              backgroundColor: const Color.fromARGB(255, 245, 245, 248),
                              elevation: 8,
                              shadowColor: Colors.blueAccent.shade200,
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    tooltip: 'ลบโปรเจกต์',
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: _confirmDelete,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Tablet View', style: Theme.of(context).textTheme.titleLarge));
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Mobile View', style: Theme.of(context).textTheme.titleLarge));
  }
}
