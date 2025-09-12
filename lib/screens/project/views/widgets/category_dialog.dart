// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/components/export.dart';
import 'package:project/models/category_model.dart';
import 'package:project/screens/auth/widgets/glass_container.dart';
import 'package:project/screens/project/category/providers/controllers/category_form_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/utils/extension/hex_color.dart';

final categoryDataForm = StateProvider<CategoryModel>((ref) => CategoryModel());

class AddCategoryDialog extends ConsumerStatefulWidget {
  final String workspaceId;
  final CategoryModel category;
  const AddCategoryDialog({super.key, required this.workspaceId, required this.category});

  @override
  ConsumerState<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<AddCategoryDialog> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();

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
    final isEdit = ref.watch(categoryDataForm).id != '0';

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: FloatingCard(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isEdit ? 'แก้ไขหมวดหมู่' : 'เพิ่มหมวดหมู่',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Name field
                      TextFormField(
                        controller: _nameController,
                        onChanged: (value) {
                          ref.read(categoryNameProvider.notifier).state = value;
                          // Debounce the validation to avoid rapid provider updates
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted && value == ref.read(categoryNameProvider)) {
                              // ignore: unused_result
                              ref.refresh(checkTextCategoryUniqueNameProvider);
                            }
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'ชื่อหมวดหมู่',
                          errorText: ref.watch(categoryNameErrorProvider),
                          filled: true,
                          fillColor: HexColor.fromHex('#001B4B'),
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF667eea))),
                        ),
                        style: const TextStyle(color: Colors.white),
                        autofocus: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'กรุณากรอกชื่อหมวดหมู่';
                          if (ref.watch(checkTextCategoryUniqueNameProvider) == false)
                            return 'ชื่อหมวดหมู่นี้มีอยู่แล้ว';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Description field
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'คำอธิบาย',
                          filled: true,
                          fillColor: HexColor.fromHex('#001B4B'),
                          labelStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF667eea))),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 12),

                      // Active switch
                      Row(
                        children: [
                          Switch(
                            value: ref.watch(categoryDataForm).active ?? true,
                            onChanged: (value) {
                              ref.read(categoryDataForm.notifier).state =
                                  ref.read(categoryDataForm).copyWith(active: value);
                            },
                          ),
                          const Text('เปิดใช้งาน', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: HexColor.fromHex('#002B77'), width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            ),
                            child: const Text('ยกเลิก', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final item = ref.read(categoryDataForm);
                                  await ref
                                      .read(insertOrUpdateCategoryProvider.notifier)
                                      .insertOrUpdateCategory({
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
                                          children: [
                                            const Icon(Icons.error, color: Colors.white),
                                            const SizedBox(width: 8),
                                            Expanded(
                                                child: Text('เกิดข้อผิดพลาด: $e')),
                                          ],
                                        ),
                                        backgroundColor: Colors.red.shade600,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: HexColor.fromHex('#003B99'),
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(isEdit ? 'แก้ไข' : 'เพิ่ม',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
