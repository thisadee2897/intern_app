import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/project/category/providers/controllers/category_form_controller.dart';

class CategoryAddScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  const CategoryAddScreen({super.key, required this.workspaceId});

  @override
  ConsumerState<CategoryAddScreen> createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends ConsumerState<CategoryAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มหมวดหมู่')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'ชื่อหมวดหมู่'),
                validator:
                    (val) =>
                        (val == null || val.trim().isEmpty)
                            ? 'กรุณากรอกชื่อหมวดหมู่'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'รายละเอียด'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Active'),
                value: isActive,
                onChanged: (val) => setState(() => isActive = val),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final body = {
                    'table_name': 'project_category', // ✅ เพิ่มตรงนี้
                    'id': '0', //ถ้าเป็นการเพิ่มใหม่ ให้ใช้ '0' 
                    'name': nameController.text.trim(),
                    'description': descriptionController.text.trim(),
                    'active': isActive,
                    'master_workspace_id': widget.workspaceId,
                  };
                  print(body);

                  try {
                    await ref
                        .read(categoryFormControllerProvider.notifier)
                        .insertOrUpdateCategory(body);

                    if (mounted) {
                      Navigator.pop(context, true); // ส่ง true กลับให้ refresh
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('เพิ่มหมวดหมู่สำเร็จ')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('เพิ่มหมวดหมู่ล้มเหลว: $e')),
                      );
                    }
                  }
                },
                child: const Text('บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
