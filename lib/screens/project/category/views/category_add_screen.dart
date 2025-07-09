import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/project/category/providers/controllers/category_form_controller.dart';

class CategoryAddScreen extends BaseStatefulWidget {
  final String workspaceId;
  const CategoryAddScreen({super.key, required this.workspaceId});

  @override
  BaseState<CategoryAddScreen> createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends BaseState<CategoryAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isActive = true;

  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มหมวดหมู่')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.pexels.com/photos/314726/pexels-photo-314726.jpeg'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        width: double.infinity,
        //color: Colors.grey.shade100, // 🔧 พื้นหลังหน้า Desktop
        padding: const EdgeInsets.all(32),
        child: Center(
          child: SizedBox(
            width: 600,
            height: 550,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รายละเอียดหมวดหมู่',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'ชื่อหมวดหมู่',
                          prefixIcon: const Icon(Icons.library_books_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'กรุณากรอกชื่อหมวดหมู่'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'รายละเอียด',
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Active'),
                        value: isActive,
                        onChanged: (val) => setState(() => isActive = val),
                      ),
                      const SizedBox(height: 32),
                      Consumer(
                        builder: (context, ref, _) => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              final body = {
                                'table_name': 'project_category',
                                'id': '0',
                                'name': nameController.text.trim(),
                                'description': descriptionController.text.trim(),
                                'active': isActive,
                                'master_workspace_id': widget.workspaceId,
                              };

                              try {
                                await ref
                                    .read(categoryFormControllerProvider.notifier)
                                    .insertOrUpdateCategory(body);

                                if (mounted) {
                                  Navigator.pop(context, true);
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
                            icon: const Icon(Icons.save),
                            label: const Text('บันทึก', style: TextStyle(fontSize: 16)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
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
    );
  }

  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return Center(
      child: Text('Tablet View', style: Theme.of(context).textTheme.titleLarge),
    );
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return Center(
      child: Text('Mobile View', style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
