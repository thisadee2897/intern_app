// comment_task_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appflowy_board/appflowy_board.dart';
import 'package:project/controllers/assignee_controller.dart';
import 'package:project/controllers/priority_controller.dart';
import 'package:project/controllers/type_of_work_controller.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/models/task_status_model.dart';
import 'package:project/screens/project/project_datail/providers/controllers/task_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/insert_controller.dart';

import 'package:project/screens/project/project_datail/providers/controllers/task_status_controller.dart';
import 'package:project/screens/project/project_datail/views/widgets/task_comment_detail.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'package:project/utils/extension/hex_color.dart';

final sprintListProvider = sprintProvider;
final showTaskDetailProvider = StateProvider<bool>((ref) => false);
final selectedTaskIdProvider = StateProvider<String?>((ref) => null);

class CommentTaskScreen extends ConsumerStatefulWidget {
  final String projectId;

  const CommentTaskScreen({super.key, required this.projectId});

  @override
  ConsumerState<CommentTaskScreen> createState() => _CommentTaskScreenState();
}

class _CommentTaskScreenState extends ConsumerState<CommentTaskScreen> {
  late AppFlowyBoardController boardController;
  final Map<String, List<MyGroupItem>> groupedItems = {};
  List<TaskStatusModel> statusList = [];
  final double panelWidth = 450;

  @override
  void initState() {
    super.initState();
    super.initState();

    // Prefetch dropdown data providers
    Future.microtask(() {
      ref.read(listAssignProvider.notifier).get();
      ref.read(listPriorityProvider.notifier).get();
      ref.read(listTypeOfWorkProvider.notifier).get();
    });

    boardController = AppFlowyBoardController(
      onMoveGroupItem: (groupId, fromIndex, toIndex) {
        final list = groupedItems[groupId];
        if (list == null || fromIndex >= list.length || toIndex > list.length) return;
        final item = list.removeAt(fromIndex);
        list.insert(toIndex, item);
        _refreshBoard();
      },
      onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) async {
        final fromList = groupedItems[fromGroupId];
        final toList = groupedItems[toGroupId];
        if (fromList == null || toList == null || fromIndex >= fromList.length) return;
        final item = fromList.removeAt(fromIndex);
        if (toIndex > toList.length) {
          toList.add(item);
        } else {
          toList.insert(toIndex, item);
        }

        try {
          await ref.read(insertOrUpdateTaskControllerProvider.notifier).submit(
            body: {
              "task_id": item.taskId,
              "project_hd_id": widget.projectId,
              "sprint_id": item.sprintId ?? "0",
              "master_priority_id": item.priorityId ?? "1",
              "master_task_status_id": toGroupId,
              "master_type_of_work_id": item.typeOfWorkId ?? "1",
              "task_name": item.title,
              "task_description": item.subtitle ?? "",
              "task_assigned_to": item.assignedToId ?? "0",
              "task_start_date": item.startDate,
              "task_end_date": item.endDate,
              "task_is_active": true,
            },
          );
          ref.invalidate(taskBySprintControllerProvider(widget.projectId));
        } catch (e) {
          print("❌ อัปเดต status ผิดพลาด: $e");
        }

        _refreshBoard();
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(taskStatusControllerProvider.notifier).fetch();
      await ref.read(sprintListProvider.notifier).get();
      await _loadTasks();
    });
  }

  Future<void> _loadTasks() async {
    try {
      await ref.read(taskBySprintControllerProvider(widget.projectId).notifier).fetch();
      final tasksState = ref.read(taskBySprintControllerProvider(widget.projectId));
      final tasks = tasksState.maybeWhen(data: (data) => data, orElse: () => <dynamic>[]);

      if (!mounted) return;
      final statusState = ref.read(taskStatusControllerProvider);
      statusList = statusState.maybeWhen(data: (data) => data, orElse: () => []);
      groupedItems.clear();

      for (final status in statusList) {
        final id = status.id ?? '';
        final filtered = tasks.where((e) => e.taskStatus?.id?.toString() == id).map(
          (task) => MyGroupItem(
            taskId: task.id?.toString() ?? '',
            title: task.name ?? '',
            subtitle: task.description,
            sprintId: task.sprint?.id?.toString(),
            priorityId: task.priority?.id?.toString(),
            typeOfWorkId: task.typeOfWork?.id?.toString(),
            assignedToId: task.assignedTo?.id?.toString(),
            startDate: task.taskStartDate,
            endDate: task.taskEndDate,
          ),
        ).toList();

        groupedItems[id] = filtered;
      }

      _refreshBoard();
    } catch (e) {
      print('❌ Error loading tasks: $e');
    }
  }

  void _refreshBoard() {
    boardController.clear();
    for (final status in statusList) {
      final id = status.id ?? '';
      final name = status.name ?? '';
      final items = groupedItems[id] ?? [];
      boardController.addGroup(AppFlowyGroupData(id: id, name: name, items: List.from(items)));
    }
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _showTaskDetailPanel(String taskId) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Task Detail',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: panelWidth,
              height: double.infinity,
              child: TaskCommentDetail(
                taskId: taskId,
                onTaskUpdated: () async {
                  ref.invalidate(taskBySprintControllerProvider(widget.projectId));
                  await _loadTasks();
                },
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeInOut)),
          child: child,
        );
      },
    );
  }

  Future<void> _showAddTaskDialog(String statusId) async {
    final nameController = TextEditingController();
    final sprintAsync = ref.watch(sprintListProvider);
    List<SprintModel> sprintList = [];
    sprintAsync.maybeWhen(data: (data) => sprintList = data, orElse: () {});
    String? selectedSprintId;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('เพิ่มงานใหม่'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'ชื่องาน'),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'เลือก Sprint'),
                  value: selectedSprintId,
                  items: sprintList.map((sprint) {
                    return DropdownMenuItem(
                      value: sprint.id,
                      child: Text(sprint.name ?? 'ไม่มีชื่อ Sprint'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setStateDialog(() {
                      selectedSprintId = val;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('ยกเลิก'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('กรุณากรอกชื่องาน')),
                    );
                    return;
                  }
                  if (selectedSprintId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('กรุณาเลือก Sprint')),
                    );
                    return;
                  }
                  Navigator.of(context).pop(true);
                },
                child: const Text('เพิ่ม'),
              ),
            ],
          );
        });
      },
    );

    if (result == true) {
      try {
        await ref.read(insertOrUpdateTaskControllerProvider.notifier).submit(
          body: {
            "task_id": "0",
            "project_hd_id": widget.projectId,
            "sprint_id": selectedSprintId ?? "0",
            "master_priority_id": "1",
            "master_task_status_id": statusId,
            "master_type_of_work_id": "1",
            "task_name": nameController.text.trim(),
            "task_description": "",
            "task_assigned_to": "0",
            "task_start_date": null,
            "task_end_date": null,
            "task_is_active": true,
          },
        );
        await _loadTasks();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เพิ่มงานสำเร็จ')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(taskBySprintControllerProvider(widget.projectId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: taskAsync.when(
        data: (_) => AppFlowyBoard(
          config: AppFlowyBoardConfig(
            groupCornerRadius: 18,
            groupBodyPadding: const EdgeInsets.all(8.0),
            groupBackgroundColor: HexColor.fromHex('#F7F8FC'),
            stretchGroupHeight: false,
          ),
          controller: boardController,
          cardBuilder: (context, groupId, groupItem) {
            if (groupItem is! MyGroupItem) return const SizedBox.shrink();
            return Padding(
              key: ValueKey(groupItem.id),
              padding: const EdgeInsets.all(0),
              child: InkWell(
                onTap: () => _showTaskDetailPanel(groupItem.taskId),
                child: AppFlowyGroupCard(
                  key: ValueKey(groupItem.id),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: Text(groupItem.title),
                    ),
                  ),
                ),
              ),
            );
          },
          headerBuilder: (context, groupData) {
            final status = statusList.firstWhere(
              (s) => s.id == groupData.id,
              orElse: () => const TaskStatusModel(name: '', color: "#CCCCCC"),
            );
            final groupColor = HexColor.fromHex(status.color ?? '#CCCCCC');
            final name = status.name ?? groupData.id;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: HexColor.fromHex('#F7F8FC'),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: groupColor, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: groupColor.darken())),
                  Text("(${groupData.items.length})",
                      style: TextStyle(
                          color: groupColor.darken().withOpacity(0.7))),
                ],
              ),
            );
          },
          footerBuilder: (context, groupData) {
            return Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: InkWell(
                onTap: () => _showAddTaskDialog(groupData.id),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: HexColor.fromHex('#A3E635'), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, size: 18, color: Color(0xFF22C55E)),
                      SizedBox(width: 6),
                      Text(
                        'New',
                        style: TextStyle(
                          color: Color(0xFF22C55E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          groupConstraints: const BoxConstraints.tightFor(width: 280),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading tasks: $err')),
      ),
    );
  }
}

class MyGroupItem extends AppFlowyGroupItem {
  final String taskId;
  final String title;
  final String? subtitle;
  final String? sprintId;
  final String? priorityId;
  final String? typeOfWorkId;
  final String? assignedToId;
  final String? startDate;
  final String? endDate;

  MyGroupItem({
    required this.taskId,
    required this.title,
    this.subtitle,
    this.sprintId,
    this.priorityId,
    this.typeOfWorkId,
    this.assignedToId,
    this.startDate,
    this.endDate,
  });

  @override
  String get id => taskId;
}

class AppFlowyColumnItemCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? sprintId;
  final String? priorityId;
  final String? typeOfWorkId;
  final String? assignedToId;
  final String? startDate;
  final String? endDate;

  const AppFlowyColumnItemCard({
    super.key,
    required this.title,
    this.subtitle,
    this.sprintId,
    this.priorityId,
    this.typeOfWorkId,
    this.assignedToId,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.task_alt),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: subtitle != null ? Text(subtitle!) : null,
      ),
    );
  }
}

extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
