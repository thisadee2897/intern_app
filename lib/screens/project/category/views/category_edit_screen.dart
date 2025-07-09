import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/models/category_model.dart';
import 'package:project/screens/project/category/providers/controllers/category_form_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';

class CategoryEditScreen extends BaseStatefulWidget {
  final String workspaceId;
  const CategoryEditScreen({super.key, required this.workspaceId});

  @override
  BaseState<CategoryEditScreen> createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends BaseState<CategoryEditScreen> {
  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return Consumer(
      builder: (context, ref, child) {
        final categories = ref.watch(categoryListProvider(widget.workspaceId)).value ?? [];

        return Scaffold(
          backgroundColor: const Color(0xFFEFF3FC),
          appBar: AppBar(
            title: const Text('แก้ไขหมวดหมู่', style: TextStyle(color: Color(0xFF2E3A59))),
            backgroundColor: const Color(0xFFEFF3FC),
            elevation: 0,
            iconTheme: const IconThemeData(color: Color(0xFF2E3A59)),
          ),
          body: categories.isEmpty
              ? const Center(child: Text('ไม่มีหมวดหมู่', style: TextStyle(color: Color(0xFF2E3A59))))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        title: Text(cat.name ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(cat.description ?? ''),
                        trailing: Icon(
                          cat.active == true ? Icons.check_circle : Icons.cancel,
                          color: cat.active == true ? Colors.green : Colors.red,
                        ),
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
                          }
                        },
                      ),
                    );
                  },
                ),
        );
      },
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

class CategoryEditFormScreen extends BaseStatefulWidget {
  final String workspaceId;
  final CategoryModel category;

  const CategoryEditFormScreen({
    super.key,
    required this.workspaceId,
    required this.category,
  });

  @override
  BaseState<CategoryEditFormScreen> createState() => _CategoryEditFormScreenState();
}

class _CategoryEditFormScreenState extends BaseState<CategoryEditFormScreen> {
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
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขหมวดหมู่'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.pexels.com/photos/314726/pexels-photo-314726.jpeg'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 600,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('รายละเอียด', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        _buildTextField('ชื่อหมวดหมู่', nameController, Icons.library_books_outlined, validator: (val) => (val == null || val.trim().isEmpty) ? 'กรุณากรอกชื่อหมวดหมู่' : null),
                        const SizedBox(height: 16),
                        _buildTextField('รายละเอียด', descriptionController, Icons.description, maxLines: 3),
                        const SizedBox(height: 16),
                        SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Active'),
                        value: isActive,
                        onChanged: (val) => setState(() => isActive = val),
                      ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _onSubmit(context),
                            icon: const Icon(Icons.save),
                            label: const Text('บันทึก', style: TextStyle(fontSize: 16)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ส่วน Tablet / Mobile ใส่ไว้เฉยๆ
  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Tablet View', style: Theme.of(context).textTheme.titleLarge));
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return Center(child: Text('Mobile View', style: Theme.of(context).textTheme.titleLarge));
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {FormFieldValidator<String>? validator, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
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
  }
}



  