import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/category_model.dart';
import 'package:project/models/project_h_d_model.dart';

class InsertOrUpdateProjectHD extends ConsumerStatefulWidget {
  final ProjectHDModel? projectHDModel;
  final CategoryModel category;
  const InsertOrUpdateProjectHD({super.key, required this.category, this.projectHDModel});

  @override
  ConsumerState<InsertOrUpdateProjectHD> createState() => _InsertOrUpdateProjectHDState();
}

class _InsertOrUpdateProjectHDState extends ConsumerState<InsertOrUpdateProjectHD> {
  // {
  //     "id": "0",
  //     "name": "Project Alphadasdasd",
  //     "key": "PAw",
  //     "description": "This is a sample project description.",
  //     "project_category_id": "2",
  //     "lead_id": "1",
  //     "active": true
  // }
  late TextEditingController _projectNameController;
  late TextEditingController _projectKeyController;
  late TextEditingController _projectDescriptionController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _projectNameController = TextEditingController(text: widget.projectHDModel?.name ?? '');
      _projectKeyController = TextEditingController(text: widget.projectHDModel?.key ?? '');
      _projectDescriptionController = TextEditingController(text: widget.projectHDModel?.description ?? '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('เพิ่มโปรเจค'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
        ],
        ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
            FilledButton(onPressed: () {}, child: const Text('เพิ่ม')),
          ],
        );
      },
    );
  }
}
