import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/category_model.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/screens/project/project_datail/providers/controllers/category_controller.dart';
import 'package:project/screens/project/project_update/provider/controllers/project_update_controller.dart';

final dataProjectHDProvider = StateProvider<ProjectHDModel>((ref) => ProjectHDModel(id: '0', name: '', key: '', description: '', active: true));

class InsertOrUpdateProjectHD extends ConsumerStatefulWidget {
  final ProjectHDModel projectHDModel;
  final CategoryModel category;
  const InsertOrUpdateProjectHD({super.key, required this.category, required this.projectHDModel});

  @override
  ConsumerState<InsertOrUpdateProjectHD> createState() => _InsertOrUpdateProjectHDState();
}

class _InsertOrUpdateProjectHDState extends ConsumerState<InsertOrUpdateProjectHD> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectKeyController = TextEditingController();
  final TextEditingController _projectDescriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _projectNameController.text = widget.projectHDModel.name ?? '';
      _projectKeyController.text = widget.projectHDModel.key ?? '';
      _projectDescriptionController.text = widget.projectHDModel.description ?? '';
      ref.read(dataProjectHDProvider.notifier).state = widget.projectHDModel;
    });
    super.initState();
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectKeyController.dispose();
    _projectDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(widget.projectHDModel.id == '0' ? 'เพิ่มโปรเจค' : 'แก้ไขโปรเจค'),
          content: SizedBox(
            width: 400,
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //name
                  TextField(
                    controller: _projectNameController,
                    decoration: const InputDecoration(labelText: 'ชื่อโปรเจค', hintText: 'ชื่อโปรเจค'),
                    onChanged: (value) {
                      // ref.read(dataProjectHDProvider.notifier).state = ref.read(dataProjectHDProvider).copyWith(name: value);
                    },
                  ),
                  //key
                  TextField(
                    controller: _projectKeyController,
                    decoration: const InputDecoration(labelText: 'Key โปรเจค', hintText: 'Key โปรเจค'),
                    onChanged: (value) {
                      // ref.read(dataProjectHDProvider.notifier).state = ref.read(dataProjectHDProvider).copyWith(key: value);
                    },
                  ),
                  //description
                  TextField(
                    maxLines: 3,
                    controller: _projectDescriptionController,
                    decoration: const InputDecoration(labelText: 'คำอธิบายโปรเจค', hintText: 'คำอธิบายโปรเจค'),
                    onChanged: (value) {
                      // ref.read(dataProjectHDProvider.notifier).state = ref.read(dataProjectHDProvider).copyWith(description: value);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
            FilledButton(onPressed: _submit, child: Text(widget.projectHDModel.id == '0' ? 'เพิ่มโปรเจค' : 'แก้ไขโปรเจค')),
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      var item = ref.read(dataProjectHDProvider);
    final body = {
      'id': item.id,
      'name': _projectNameController.text.trim(),
      'key': _projectKeyController.text.trim(),
      'description': _projectDescriptionController.text.trim(),
      'project_category_id': widget.category.id,
      'lead_id': item.leader!.id,
    };

    await ref.read(projectUpdateControllerProvider.notifier).submitProjectHD(body: body);
    ref.read(categoryProvider.notifier).getCategory(widget.category.workspaceId!);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.projectHDModel.id == '0' ? 'เพิ่มโปรเจคสำเร็จ' : 'แก้ไขโปรเจคสำเร็จ'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop(true);
    }
    }catch (e,stx) {
      print('Error: $e, StackTrace: $stx');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
