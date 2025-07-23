import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appflowy_board/appflowy_board.dart';
import 'package:project/screens/project/project_datail/providers/controllers/task_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/task_status_controller.dart';

class CommentTaskScreen extends ConsumerStatefulWidget {
  final String projectId;

  const CommentTaskScreen({super.key, required this.projectId});

  @override
  ConsumerState<CommentTaskScreen> createState() => _CommentTaskScreenState();
}

class _CommentTaskScreenState extends ConsumerState<CommentTaskScreen> {
  late AppFlowyBoardController boardController;
  Map<String, List<MyGroupItem>> groupedItems = {};
  // กำหนดลำดับ group และชื่อ group ที่ต้องการ
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
        debugPrint('Moved item in group $groupId from $fromIndex to $toIndex');
      },
      onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        debugPrint('Moved item from group $fromGroupId to $toGroupId');
        // Move in groupedItems
        final fromList = groupedItems[fromGroupId];
        final toList = groupedItems[toGroupId];
        if (fromList == null || toList == null) return;
        if (fromIndex < 0 || fromIndex >= fromList.length) return;
        final item = fromList.removeAt(fromIndex);
        if (toIndex > toList.length) {
          toList.add(item);
        } else {
          toList.insert(toIndex, item);
        }
        // Sync boardController
        boardController.clear();
        for (final entry in groupOrder) {
          final id = entry.key;
          final name = entry.value;
          boardController.addGroup(
            AppFlowyGroupData(id: id, name: name, items: groupedItems[id] ?? []),
          );
        }
        setState(() {});
      },
    );

    Future.microtask(() async {
      final tasks = await ref
          .read(taskBySprintControllerProvider(widget.projectId).notifier)
          .getTaskBySprint(widget.projectId);
      final statuses = await ref.read(taskStatusControllerProvider.future);

      boardController.clear();
      groupedItems.clear();

      // สร้าง group ตามลำดับ groupOrder และใส่ task จริงในแต่ละ group
      for (final entry in groupOrder) {
        final id = entry.key;
        final name = entry.value;
        final filteredTasks = tasks
            .where((task) => task.taskStatus?.id?.toString() == id)
            .map((task) => MyGroupItem(
                  taskId: task.id?.toString() ?? '',
                  title: task.name ?? '',
                  subtitle: task.description,
                ))
            .toList();
        groupedItems[id] = filteredTasks;
        boardController.addGroup(
          AppFlowyGroupData(id: id, name: name, items: filteredTasks),
        );
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(taskBySprintControllerProvider(widget.projectId));
    final statusAsync = ref.watch(taskStatusControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Task Board")),
      body: taskAsync.when(
        data: (_) => AppFlowyBoard(
          controller: boardController,
          cardBuilder: (context, groupId, groupItem) {
            if (groupItem is! MyGroupItem) return const SizedBox.shrink();
            final item = groupItem;
            return Padding(
              key: ValueKey(item.id),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), // เพิ่ม margin ซ้าย-ขวา
              child: Card(
                elevation: 3,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      item.subtitle != null ? Text(item.subtitle!) : null,
                  leading: const Icon(Icons.task_alt),
                ),
              ),
            );
          },
          headerBuilder: (context, groupData) {
            final name = groupOrder.firstWhere(
              (entry) => entry.key == groupData.id,
              orElse: () => MapEntry(groupData.id, groupData.id),
            ).value;
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), // เพิ่ม margin ซ้าย-ขวา
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("(${groupData.items.length})"),
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

  MyGroupItem({
    required this.taskId,
    required this.title,
    this.subtitle,
  });

  @override
  String get id => taskId;
}
