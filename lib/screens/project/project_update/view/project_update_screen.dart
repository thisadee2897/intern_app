import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/screens/project/project_update/provider/controllers/project_updateController.dart';

class ProjectUpdateScreen extends BaseStatefulWidget {
  final dynamic project;
  const ProjectUpdateScreen({super.key, required this.project});

  @override
  ConsumerState<ProjectUpdateScreen> createState() => _ProjectUpdateScreenState();
}

class _ProjectUpdateScreenState extends BaseState<ProjectUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategoryId;
  final String _defaultLeadId = '1';
  bool _isHovering = false; // เพิ่มสำหรับ hover effect

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
      'id': "0",
      'name': _nameController.text.trim(),
      'key': _keyController.text.trim(),
      'description': _descriptionController.text.trim(),
      'project_category_id': _selectedCategoryId,
      'lead_id': _defaultLeadId,
    };

    await ref.read(projectUpdateControllerProvider.notifier).submitProjectHD(body: body);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ บันทึกข้อมูลเรียบร้อย'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 24, left: 24, right: 24),
        ),
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    final state = ref.watch(projectUpdateControllerProvider);
    final categoryAsyncValue = ref.watch(categoryListProvider('1'));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('อัปเดตโปรเจกต์',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.pexels.com/photos/314726/pexels-photo-314726.jpeg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'รายละเอียดโปรเจกต์',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'ชื่อโปรเจกต์',
                        prefixIcon: const Icon(Icons.title, color: Colors.black),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: const Color(0xFFF6F8FB),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'กรุณากรอกชื่อโปรเจกต์'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _keyController,
                      decoration: InputDecoration(
                        labelText: 'รหัสโปรเจกต์ (key)',
                        prefixIcon: const Icon(Icons.vpn_key, color: Colors.black),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: const Color(0xFFF6F8FB),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'กรุณากรอกรหัสโปรเจกต์'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    categoryAsyncValue.when(
                      data: (categories) {
                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'หมวดหมู่',
                            prefixIcon: const Icon(Icons.category, color: Colors.black),
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
                          validator: (value) =>
                              value == null ? 'กรุณาเลือกหมวดหมู่' : null,
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) =>
                          Text('โหลดหมวดหมู่ล้มเหลว: $error'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'คำอธิบาย',
                        prefixIcon: const Icon(Icons.description, color: Colors.black),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: const Color(0xFFF6F8FB),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 28),
                    state.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          'เกิดข้อผิดพลาด: $e',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      data: (_) => MouseRegion(
                        onEnter: (_) => setState(() => _isHovering = true),
                        onExit: (_) => setState(() => _isHovering = false),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: _isHovering ? 1.03 : 1.0,
                          child: ElevatedButton.icon(
                            onPressed: _submit,
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: const Text(
                              'บันทึกข้อมูล',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(fontSize: 16),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
