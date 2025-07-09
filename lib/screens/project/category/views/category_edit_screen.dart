import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/category_model.dart';
import 'package:project/screens/project/category/providers/controllers/category_form_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';

class CategoryEditScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  const CategoryEditScreen({super.key, required this.workspaceId});

  @override
  ConsumerState<CategoryEditScreen> createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends ConsumerState<CategoryEditScreen> {
  CategoryModel? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryListProvider(widget.workspaceId)).value ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('แก้ไขหมวดหมู่')),
      body: categories.isEmpty
          ? const Center(child: Text('ไม่มีหมวดหมู่'))
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return ListTile(
                  title: Text(cat.name ?? '-'),
                  subtitle: Text(cat.description ?? ''),
                  trailing: Icon(cat.active == true ? Icons.check_circle : Icons.cancel,
                      color: cat.active == true ? Colors.green : Colors.red),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryEditFormScreen(
                          workspaceId: widget.workspaceId,
                          category: cat,
                        ),
                      ),
                    );

                    if (result == true) {
                      ref.invalidate(categoryListProvider(widget.workspaceId));
                      setState(() {});
                    }
                  },
                );
              },
            ),
    );
  }
}

// หน้าฟอร์มแก้ไขแยกอีกไฟล์เล็ก ๆ
class CategoryEditFormScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  final CategoryModel category;

  const CategoryEditFormScreen({
    super.key,
    required this.workspaceId,
    required this.category,
  });

  @override
  ConsumerState<CategoryEditFormScreen> createState() => _CategoryEditFormScreenState();
}

class _CategoryEditFormScreenState extends ConsumerState<CategoryEditFormScreen> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late bool isActive;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category.name ?? '');
    descriptionController = TextEditingController(text: widget.category.description ?? '');
    isActive = widget.category.active ?? true;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('แก้ไขหมวดหมู่')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'ชื่อหมวดหมู่'),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'กรุณากรอกชื่อหมวดหมู่' : null,
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
                    'id': widget.category.id,
                    'name': nameController.text.trim(),
                    'description': descriptionController.text.trim(),
                    'active': isActive,
                    'master_workspace_id': widget.workspaceId,
                  };

                  try {
                    await ref.read(categoryFormControllerProvider.notifier).insertOrUpdateCategory(body);

                    if (mounted) {
                      Navigator.pop(context, true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('แก้ไขหมวดหมู่สำเร็จ')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('แก้ไขหมวดหมู่ล้มเหลว: $e')),
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
