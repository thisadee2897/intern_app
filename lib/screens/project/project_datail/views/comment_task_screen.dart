// comment_task_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appflowy_board/appflowy_board.dart';
import 'package:project/controllers/assignee_controller.dart';
import 'package:project/controllers/priority_controller.dart';
import 'package:project/controllers/task_status_controller.dart';
import 'package:project/controllers/type_of_work_controller.dart';
import 'package:project/models/task_status_model.dart';
import 'package:project/screens/auth/widgets/glass_container.dart';
import 'package:project/screens/project/project_datail/providers/controllers/sprint_in_borad_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/task_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/insert_controller.dart';

import 'package:project/screens/project/project_datail/providers/controllers/task_status_controller.dart';
import 'package:project/screens/project/project_datail/views/widgets/task_comment_detail.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'package:project/utils/extension/custom_snackbar.dart';
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
      ref.read(listTaskStatusProvider.notifier).get();
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

    // ✅ รอโหลด Task ใหม่ก่อนรีเฟรช Board
    await _loadTasks(); 

  } catch (e) 
  {
  }
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

      print('[CommentTaskScreen] Loaded ${tasks.length} tasks for project ${widget.projectId}');
      for (var t in tasks) {
        print('Task: ${t.name}, status: ${t.taskStatus?.id}, sprint: ${t.sprint?.id}');
      }

      if (!mounted) return;
      final statusState = ref.read(taskStatusControllerProvider);
      statusList = statusState.maybeWhen(data: (data) => data, orElse: () => []);
      print('[CommentTaskScreen] statusList: ${statusList.map((s) => '${s.id}:${s.name}').toList()}');
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
        print('[CommentTaskScreen] status $id (${status.name}) mapped ${filtered.length} tasks');
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
  String? selectedSprintId;

  // โหลด Sprint ผ่าน controller
  await ref.read(sprintStartedControllerProvider(widget.projectId).notifier).fetch();
  final sprintAsync = ref.watch(sprintStartedControllerProvider(widget.projectId));

  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setStateDialog) {
        return Dialog(
  insetPadding: const EdgeInsets.all(16),
  backgroundColor: Colors.transparent,
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 400),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FloatingCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'เพิ่มงานใหม่',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // ชื่องาน
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'ชื่องาน',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: HexColor.fromHex('#001B4B'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: HexColor.fromHex('#00C6FF')),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),

              // Dropdown เลือก Sprint
              sprintAsync.when(
                data: (sprintList) => DropdownButtonFormField<String>(
                  value: selectedSprintId,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'เลือก Sprint',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: HexColor.fromHex('#001B4B'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: HexColor.fromHex('#00C6FF')),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                  items: sprintList
                      .map((sprint) => DropdownMenuItem(
                            value: sprint.id,
                            child: Text(
                              sprint.name ?? 'ไม่มีชื่อ Sprint',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setStateDialog(() {
                      selectedSprintId = val;
                    });
                  },
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator(color: Colors.white)),
                error: (err, _) => Text('Error loading sprint: $err',
                    style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: HexColor.fromHex('#002B77'), width: 2),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 28),
                    ),
                    child: const Text('ยกเลิก', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () {
                      if (nameController.text.trim().isEmpty) {
                        CustomSnackbar.showSnackBar(
                          context: context,
                          title: 'ข้อมูลไม่ครบ',
                          message: 'กรุณากรอกชื่องาน',
                          contentType: ContentType.warning,
                          color: Colors.orange,
                        );
                        return;
                      }
                      if (selectedSprintId == null) {
                        CustomSnackbar.showSnackBar(
                          context: context,
                          title: 'ข้อมูลไม่ครบ',
                          message: 'กรุณาเลือก Sprint',
                          contentType: ContentType.warning,
                          color: Colors.orange,
                        );
                        return;
                      }
                      Navigator.of(context).pop(true);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: HexColor.fromHex('#003B99'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 28),
                    ),
                    child: const Text('เพิ่ม',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);

      });
    },
  );

  if (result == true) {
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
   CustomSnackbar.showSnackBar(
  context: context,
  title: 'สำเร็จ',
  message: 'เพิ่มงานเรียบร้อยแล้ว',
  contentType: ContentType.success,
  color: Colors.green,
);
  }
}

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(taskBySprintControllerProvider(widget.projectId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: taskAsync.when(
        data: (_) => AppFlowyBoard(
          config: AppFlowyBoardConfig(
            groupCornerRadius: 18,
            groupBodyPadding: const EdgeInsets.all(8.0),
             groupBackgroundColor: const Color.fromARGB(255, 248, 242, 242).withOpacity(0.05),
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
      child: Material(
        color: Colors.transparent,
        elevation: 0, // ลดเงา แต่ยังมี ripple
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05), // โปร่งใสเล็กน้อย
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            groupItem.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
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
  color: HexColor.fromHex('#F7F8FC').withOpacity(0.1), // โปร่งใส
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
          color: Colors.white.withOpacity(0.1), // โปร่งใส
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
         groupConstraints: BoxConstraints.tightFor(
  width: MediaQuery.of(context).size.width / 5,
),
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
