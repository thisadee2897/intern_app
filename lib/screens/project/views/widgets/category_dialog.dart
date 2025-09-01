// Dialog class สำหรับเพิ่ม Category
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/models/category_model.dart';
import 'package:project/screens/project/category/providers/controllers/category_form_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';

final categoryDataForm = StateProvider<CategoryModel>((ref) => CategoryModel());

class AddCategoryDialog extends ConsumerStatefulWidget {
  final String workspaceId;
  final CategoryModel category;
  const AddCategoryDialog({super.key, required this.workspaceId, required this.category});

  @override
  ConsumerState<AddCategoryDialog> createState() => AddCategoryDialogState();
}

class AddCategoryDialogState extends ConsumerState<AddCategoryDialog> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  // key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _animationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameController.text = widget.category.name ?? '';
      _descriptionController.text = widget.category.description ?? '';
      ref.read(categoryDataForm.notifier).state = widget.category;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                ref.watch(categoryDataForm).id == '0' ? 'เพิ่มหมวดหมู่' : 'แก้ไขหมวดหมู่',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    onChanged: (value) {
                      ref.read(categoryNameProvider.notifier).state = value;
                      // ignore: unused_result
                      ref.refresh(checkTextCategoryUniqueNameProvider);
                    },
                    decoration: InputDecoration(
                      labelText: 'ชื่อหมวดหมู่',
                      errorText: ref.watch(categoryNameErrorProvider),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF667eea))),
                    ),
                    autofocus: true,
                   // การตรวจสอบความถูกต้องของข้อมูล
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อหมวดหมู่';
                      }
                      if (ref.watch(checkTextCategoryUniqueNameProvider) == false) {
                        return 'ชื่อหมวดหมู่นี้มีอยู่แล้ว';
                      }
                      return null;
                    },
                  ),
                  //description
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'คำอธิบาย',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF667eea))),
                    ),
                  ),
                  //active
                  const SizedBox(height: 12),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Switch(
                        value: ref.watch(categoryDataForm).active ?? true,
                        onChanged: (value) {
                          ref.read(categoryDataForm.notifier).state = ref.read(categoryDataForm).copyWith(active: value);
                        },
                      ),
                      const Text('เปิดใช้งาน'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('ยกเลิก', style: TextStyle(color: Colors.grey.shade600))),
            Container(
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]), borderRadius: BorderRadius.circular(8)),
              child: TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      CategoryModel item = ref.read(categoryDataForm);
                      await ref.read(insertOrUpdateCategoryProvider.notifier).insertOrUpdateCategory({
                        'id': item.id ?? '0',
                        'name': _nameController.text.trim(),
                        'description': _descriptionController.text.trim(),
                        'active': item.active ?? true,
                        'master_workspace_id': widget.workspaceId,
                      });
                      Navigator.pop(context, true);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [const Icon(Icons.error, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text('เกิดข้อผิดพลาด: $e'))],
                            ),
                            backgroundColor: Colors.red.shade600,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text('เพิ่ม', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
