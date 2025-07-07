import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/screens/project/project_update/provider/controllers/project_updateController.dart';

class ProjectUpdateScreen extends ConsumerStatefulWidget {
  final dynamic project;
  const ProjectUpdateScreen({super.key, required this.project});

  @override
  ConsumerState<ProjectUpdateScreen> createState() => _ProjectUpdateScreenState();
}

class _ProjectUpdateScreenState extends ConsumerState<ProjectUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedLeadId;

  final List<Map<String, String>> leadList = [
    {'id': '1', 'name': 'Administrator'},
    {'id': '2', 'name': 'Nattapong'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.project["categoryId"] != null) {
      _selectedCategoryId = widget.project["categoryId"].toString();
    }
    if (widget.project["leadId"] != null) {
      _selectedLeadId = widget.project["leadId"].toString();
    }
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
      'id': "0",
      'name': _nameController.text.trim(),
      'key': _keyController.text.trim(),
      'description': _descriptionController.text.trim(),
      'project_category_id': _selectedCategoryId,
      'lead_id': _selectedLeadId,
    };

    await ref.read(projectUpdateControllerProvider.notifier).submitProjectHD(body: body);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectUpdateControllerProvider);
    final categoryAsyncValue = ref.watch(categoryListProvider('1')); // Workspace ID (ใส่ตามจริง)

    return Scaffold(
      appBar: AppBar(title: const Text('อัปเดตโปรเจกต์')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'ชื่อโปรเจกต์'),
                validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกชื่อโปรเจกต์' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _keyController,
                decoration: const InputDecoration(labelText: 'รหัสโปรเจกต์ (key)'),
                validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกรหัสโปรเจกต์' : null,
              ),
              const SizedBox(height: 16),

              // 🔽 Category dropdown
              categoryAsyncValue.when(
                data: (categories) {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'หมวดหมู่'),
                    value: _selectedCategoryId,
                    items: categories.map((cat) {
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

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'หัวหน้าโปรเจกต์'),
                value: _selectedLeadId,
                items: leadList.map((user) {
                  return DropdownMenuItem<String>(
                    value: user['id'],
                    child: Text(user['name']!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedLeadId = value),
                validator: (value) => value == null ? 'กรุณาเลือกหัวหน้าโปรเจกต์' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'คำอธิบาย'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('เกิดข้อผิดพลาด: $e', style: const TextStyle(color: Colors.red)),
                data: (_) => ElevatedButton(
                  onPressed: _submit,
                  child: const Text('บันทึกข้อมูล'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
