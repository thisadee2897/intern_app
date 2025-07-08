import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/category_model.dart';
import 'package:project/screens/project/category/providers/controllers/category_form_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';

class CategoryFormScreen extends ConsumerStatefulWidget {
  const CategoryFormScreen({super.key});

  @override
  ConsumerState<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends ConsumerState<CategoryFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('จัดการหมวดหมู่')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('เพิ่มหมวดหมู่'),
              onPressed: () {
                _showCategoryFormDialog(context);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('แก้ไขหมวดหมู่'),
              onPressed: () {
                _showSelectCategoryDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔧 Dialog สำหรับเพิ่ม/แก้ไข Category
  void _showCategoryFormDialog(
    BuildContext context, [
    CategoryModel? category,
  ]) {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: category?.name ?? '');
    final descriptionController = TextEditingController(
      text: category?.description ?? '',
    );
    bool isActive = category?.active ?? true;

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 400,
            height: 500,
            child: AlertDialog(
              title: Text(category == null ? 'เพิ่มหมวดหมู่' : 'แก้ไขหมวดหมู่'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'ชื่อหมวดหมู่',
                        ),
                        validator:
                            (val) =>
                                (val == null || val.trim().isEmpty)
                                    ? 'กรุณากรอกชื่อหมวดหมู่'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'รายละเอียด',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return SwitchListTile(
                            title: const Text('Active'),
                            value: isActive,
                            onChanged: (val) => setState(() => isActive = val),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                // ยกเลิก
                TextButton(
                  onPressed:
                      () => Navigator.of(context, rootNavigator: true).pop(),
                  child: const Text('ยกเลิก'),
                ),

                // บันทึก
                ElevatedButton(
                  onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

    //final workspaceId = ref.watch(workspaceProvider).id;

                    final body = {
                      if (category?.id != null) 'id': category!.id,
                      'name': nameController.text.trim(),
                      'description': descriptionController.text.trim(),
                      'active': isActive,
                      'master_workspace_id': '1', // แนะนำให้ใช้ Provider
                    };

                    try {
                      await ref
                          .read(categoryFormControllerProvider.notifier)
                          .insertOrUpdateCategory(body);

                      if (mounted) {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop(true); // ✅ ส่งผลลัพธ์กลับ
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('บันทึกสำเร็จ')),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('บันทึกล้มเหลว: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('บันทึก'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🔧 Dialog สำหรับเลือกหมวดหมู่ที่จะแก้ไข
  void _showSelectCategoryDialog(BuildContext context) {
    final categories = ref.read(categoryListProvider('1')).value ?? [];

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('เลือกหมวดหมู่ที่จะแก้ไข'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child:
                categories.isEmpty
                    ? const Center(child: Text('ไม่มีหมวดหมู่'))
                    : ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return ListTile(
                          title: Text(cat.name ?? '-'),
                          onTap: () async {
                            Navigator.pop(context); // ปิด dialog เลือกก่อน
                            await Future.delayed(
                              const Duration(milliseconds: 200),
                            ); // ✅ รอ dialog ปิด

                            if (!mounted) return; // ✅ ตรวจสอบก่อนใช้ context

                            _showCategoryFormDialog(
                              context,
                              cat,
                            ); // เปิด dialog แก้ไข
                          },
                        );
                      },
                    ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('ยกเลิก'),
            ),
          ],
        );
      },
    );
  }
}
