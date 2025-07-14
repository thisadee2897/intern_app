import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/screens/project/project_datail/views/widgets/count_work_type_widget.dart';
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
                        spacing: 4,
                        runSpacing: 4,
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
                    spacing: 4,
                    runSpacing: 4,
                    children: _buildCountersAndButton(),
                  ),
                ),

              if (isExpanding)
                ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 18,
                                color: context.primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "Work Item ${index + 1}",
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 13 : 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              // Dropdown
                              Expanded(
                                flex: 5,
                                child: DropdownButtonFormField(
                                  isDense: true,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 3,
                                    ),
                                  ),
                                  value: 'Todo',
                                  items:
                                      [
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
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 10 : 12,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (newValue) {},
                                ),
                              ),
                              const SizedBox(width: 6),

                              // Avatar
                              CircleAvatar(
                                radius: isSmallScreen ? 11 : 12,
                                backgroundColor: Colors.grey[300],
                                child: Icon(
                                  Icons.person_outline,
                                  size: isSmallScreen ? 13 : 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 6),

                              // More icon
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  Icons.more_vert,
                                  size: isSmallScreen ? 20 : 20,
                                  color: Colors.grey,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
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




  // แสดงชื่อ Create, Update Sprint ที่ปุ่มกดใช้ชุดนี้

  //   List<Widget> _buildCountersAndButton() {
  //   return [

  //       CountWorkTypeWidget(title: 'todo', count: '0 of 0'),
  //       CountWorkTypeWidget(
  //         title: 'in progress',
  //         count: '0 of 0',
  //         color: Colors.lightBlue,
  //       ),
  //       CountWorkTypeWidget(
  //         title: 'in review',
  //         count: '0 of 0',
  //         color: Colors.deepOrange,
  //       ),
  //       CountWorkTypeWidget(
  //         title: 'done',
  //         count: '0 of 0',
  //         color: Colors.lightGreenAccent,
  //       ),

  //     // ---- ✅ ปุ่ม CREATE SPRINT ----
  //     OutlinedButton.icon(
  //       icon: const Icon(Icons.add),
  //       label: const Text("Create Sprint"),
  //       onPressed: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const InsertUpdateSprint(),
  //           ),
  //         );
  //       },
  //       style: OutlinedButton.styleFrom(
  //         foregroundColor: Colors.blue,
  //         side: const BorderSide(color: Colors.blue),
  //       ),
  //     ),

  //     // ---- ✅ ปุ่ม EDIT SPRINT ----
  //     if (widget.item != null)
  //       OutlinedButton.icon(
  //         icon: const Icon(Icons.edit),
  //         label: const Text("Edit Sprint"),
  //         onPressed: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) =>
  //                   InsertUpdateSprint(sprint: widget.item),
  //             ),
  //           );
  //         },
  //         style: OutlinedButton.styleFrom(
  //           foregroundColor: Colors.orange,
  //           side: const BorderSide(color: Colors.orange),
  //         ),
  //       ),

  //     // ---- ✅ ปุ่ม DELETE SPRINT ----
  //     IconButton(
  //       icon: const Icon(Icons.delete_outline, color: Colors.red),
  //       tooltip: 'Delete Sprint',
  //       onPressed: widget.item == null
  //           ? null
  //           : () async {
  //               final confirm = await showDialog<bool>(
  //                 context: context,
  //                 builder: (context) => AlertDialog(
  //                   title: const Text('ยืนยันการลบ'),
  //                   content: Text(
  //                       'คุณต้องการลบ Sprint "${widget.item!.name}" ใช่หรือไม่?'),
  //                   actions: [
  //                     TextButton(
  //                         onPressed: () => Navigator.pop(context, false),
  //                         child: const Text('ยกเลิก')),
  //                     ElevatedButton(
  //                         onPressed: () => Navigator.pop(context, true),
  //                         child: const Text('ลบ')),
  //                   ],
  //                 ),
  //               );

  //               if (confirm == true) {
  //                 await ref
  //                     .read(sprintProvider.notifier)
  //                     .delete(widget.item!.id!);
  //                 ref.invalidate(sprintProvider);
  //                 await ref.read(sprintProvider.notifier).get();

  //                 if (context.mounted) {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                         content: Text('ลบ Sprint สำเร็จ')),
  //                   );
  //                 }
  //               }
  //             },
  //     ),
  //   ];
  // }

  // แสดงแค่ icon โชว์ชื่อปุ่มเวลาเมาส์ไปโดน
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

      //  ปุ่ม CREATE SPRINT (IconButton + Tooltip)
      Tooltip(
        message: 'Create Sprint',
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.blue),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InsertUpdateSprint(),
              ),
            );
          },
        ),
      ),

      //  ปุ่ม EDIT SPRINT (IconButton + Tooltip)
      if (widget.item != null)
        Tooltip(
          message: 'Edit Sprint',
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.orange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InsertUpdateSprint(sprint: widget.item),
                ),
              );
            },
          ),
        ),

      // ✅ ปุ่ม DELETE SPRINT (IconButton + Tooltip) -- คุณมีแล้ว
      Tooltip(
        message: 'Delete Sprint',
        child: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed:
              widget.item == null
                  ? null
                  : () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('ยืนยันการลบ'),
                            content: Text(
                              'คุณต้องการลบ Sprint "${widget.item!.name}" ใช่หรือไม่?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('ยกเลิก'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('ลบ'),
                              ),
                            ],
                          ),
                    );

                    if (confirm == true) {
                      await ref
                          .read(sprintProvider.notifier)
                          .delete(widget.item!.id!);
                      ref.invalidate(sprintProvider);
                      await ref.read(sprintProvider.notifier).get();

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ลบ Sprint สำเร็จ')),
                        );
                      }
                    }
                  },
        ),
      ),
    ];
  }
}
