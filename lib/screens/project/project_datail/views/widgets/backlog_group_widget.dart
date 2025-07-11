// backlog_group_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/screens/project/project_datail/views/widgets/count_work_type_widget.dart';
import 'package:project/screens/project/sprint/views/delete_sprint_dialog.dart';
import 'package:project/screens/project/sprint/views/delete_sprint_screen.dart'; // ใช้งานได้ ถ้าต้องการขึ้นหน้า Delete Sprint
import 'package:project/screens/project/sprint/views/widgets/insert_update_sprint.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'package:project/utils/extension/context_extension.dart';

class BacklogGroupWidget extends ConsumerStatefulWidget {
  final bool isExpanded;
  final SprintModel? item;
  const BacklogGroupWidget({super.key, this.isExpanded = false, this.item});

  @override
  ConsumerState<BacklogGroupWidget> createState() => _BacklogGroupWidgetState();
}

class _BacklogGroupWidgetState extends ConsumerState<BacklogGroupWidget> {
  bool isExpanding = false;

  @override
  void initState() {
    isExpanding = widget.isExpanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 600;

        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              isExpanding
                                  ? const Icon(Icons.expand_less)
                                  : const Icon(Icons.expand_more),
                          onPressed: () {
                            setState(() {
                              isExpanding = !isExpanding;
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                            widget.item?.name ?? 'Backlog',
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isSmallScreen)
                    Flexible(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        alignment: WrapAlignment.end,
                        children: _buildCountersAndButton(),
                      ),
                    ),
                ],
              ),

              if (isSmallScreen)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: _buildCountersAndButton(),
                  ),
                ),

              if (isExpanding)
                ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(
                        Icons.check_circle_outline,
                        color: context.primaryColor,
                      ),
                      title: Text("Work Item ${index + 1}"),
                      trailing: SizedBox(
                        width: isSmallScreen ? constraints.maxWidth * 0.5 : 300,
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            SizedBox(
                              width: 120,
                              child: DropdownButtonFormField(
                                isDense: true,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                ),
                                value: 'Todo',
                                items:
                                    <String>[
                                      'Todo',
                                      'In Progress',
                                      'In Review',
                                      'Done',
                                    ].map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (newValue) {},
                              ),
                            ),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey[300],
                              child: const Icon(
                                Icons.person_outline,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildCountersAndButton() {
    return [
      CountWorkTypeWidget(title: 'todo', count: '0 of 0'),
      CountWorkTypeWidget(
        title: 'in progress',
        count: '0 of 0',
        color: Colors.lightBlue,
      ),
      CountWorkTypeWidget(
        title: 'in review',
        count: '0 of 0',
        color: Colors.deepOrange,
      ),
      CountWorkTypeWidget(
        title: 'done',
        count: '0 of 0',
        color: Colors.lightGreenAccent,
      ),

      Row(crossAxisAlignment: CrossAxisAlignment.end),
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue,
          side: BorderSide(color: Colors.blue),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InsertUpdateSprint()),
          );
        },
        child: const Text("Create Sprint"),
      ),

      //  ปุ่ม Delete Sprint
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
        onPressed:
            widget.item == null
                ? null
                : () async {
                  final isDeleted = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DeleteSprintDialog(
                            // ถ้าใช้ DeleteSprintScreen ก็เปลี่ยนเป็น DeleteSprintScreen
                            sprintId: widget.item!.id ?? '',
                            sprintName: widget.item!.name ?? '',
                          ),
                    ),
                  );

                  if (isDeleted == true) {
                    // invalidate และ get() ใหม่ เพื่อให้ Sprint list หายจริง
                    ref.invalidate(sprintProvider);
                    await ref.read(sprintProvider.notifier).get();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ลบ Sprint สำเร็จ')),
                      );
                    }
                  }
                },
        child: const Text("Delete Sprint"),
      ),
    ];
  }
}
