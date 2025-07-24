import 'package:flutter/material.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appflowy_board/appflowy_board.dart';
import 'package:project/screens/project/project_datail/providers/controllers/task_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/insert_controller.dart';

class CommentTaskScreen extends ConsumerStatefulWidget {
  final String projectId;

  const CommentTaskScreen({super.key, required this.projectId});

  @override
  ConsumerState<CommentTaskScreen> createState() => _CommentTaskScreenState();
}

class _CommentTaskScreenState extends ConsumerState<CommentTaskScreen> {
  late AppFlowyBoardController boardController;
  final Map<String, List<MyGroupItem>> groupedItems = {};

  final List<MapEntry<String, String>> groupOrder = const [
    MapEntry('1', 'TODO'),
    MapEntry('2', 'IN PROGRESS'),
    MapEntry('3', 'REVIEW'),
    MapEntry('4', 'DONE'),
  ];

  @override
  void initState() {
    super.initState();

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
          await ref.read(insertOrUpdateTaskControllerProvider.notifier).submit(body: {
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
          });

          ref.invalidate(taskBySprintControllerProvider(widget.projectId));
        } catch (e) {
          print("❌ อัปเดต status ผิดพลาด: $e");
        }

        _refreshBoard();
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  Future<void> _loadTasks() async {
    try {
      await ref.read(taskBySprintControllerProvider(widget.projectId).notifier).fetch();
      final tasksState = ref.read(taskBySprintControllerProvider(widget.projectId));

      final tasks = tasksState.maybeWhen(
        data: (data) => data,
        orElse: () => <dynamic>[],
      );

      if (!mounted) return;

      groupedItems.clear();

      for (final entry in groupOrder) {
        final id = entry.key;
        final filtered = tasks
            .where((e) => e.taskStatus?.id?.toString() == id)
            .map((task) => MyGroupItem(
                  taskId: task.id?.toString() ?? '',
                  title: task.name ?? '',
                  subtitle: task.description,
                  sprintId: task.sprint?.id?.toString(),
                  priorityId: task.priority?.id?.toString(),
                  typeOfWorkId: task.typeOfWork?.id?.toString(),
                  assignedToId: task.assignedTo?.id?.toString(),
                  startDate: task.taskStartDate,
                  endDate: task.taskEndDate,
                ))
            .toList();

        groupedItems[id] = filtered;
      }

      _refreshBoard();
    } catch (e) {
      print('❌ Error loading tasks: $e');
    }
  }

  void _refreshBoard() {
    boardController.clear();

    for (final entry in groupOrder) {
      final id = entry.key;
      final name = entry.value;
      final items = groupedItems[id] ?? [];

      boardController.addGroup(
        AppFlowyGroupData(id: id, name: name, items: List.from(items)),
      );
    }

    if (!mounted) return;
    setState(() {});
  }

  Color _colorForGroup(String groupId) {
    switch (groupId) {
      case '1':
        return Colors.red.shade300;
      case '2':
        return Colors.orange.shade300;
      case '3':
        return Colors.blue.shade300;
      case '4':
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(taskBySprintControllerProvider(widget.projectId));

    return Scaffold(
      appBar: AppBar(title: const Text("Task Board")),
      body: taskAsync.when(
        data: (_) => AppFlowyBoard(
          controller: boardController,
          cardBuilder: (context, groupId, groupItem) {
            if (groupItem is! MyGroupItem) return const SizedBox.shrink();

            return Padding(
              key: ValueKey(groupItem.id),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: AppFlowyColumnItemCard(
                title: groupItem.title,
                subtitle: groupItem.subtitle,
                sprintId: groupItem.sprintId,
                priorityId: groupItem.priorityId,
                typeOfWorkId: groupItem.typeOfWorkId,
                assignedToId: groupItem.assignedToId,
                startDate: groupItem.startDate,
                endDate: groupItem.endDate,
              ),
            );
          },
          headerBuilder: (context, groupData) {
            final name = groupOrder.firstWhere(
              (entry) => entry.key == groupData.id,
              orElse: () => MapEntry(groupData.id, groupData.id),
            ).value;

            final groupColor = _colorForGroup(groupData.id);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: groupColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: groupColor, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: groupColor.darken(),
                    ),
                  ),
                  Text(
                    "(${groupData.items.length})",
                    style: TextStyle(
                      color: groupColor.darken().withOpacity(0.7),
                    ),
                  ),
                ],
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
    required this.title,
    this.subtitle,
    this.sprintId,
    this.priorityId,
    this.typeOfWorkId,
    this.assignedToId,
    this.startDate,
    this.endDate,
    Key? key,
  }) : super(key: key);

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

/// Extension เพื่อปรับความเข้มสี (darken)
extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
