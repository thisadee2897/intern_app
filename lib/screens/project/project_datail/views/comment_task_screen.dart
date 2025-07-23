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
        if (list == null || fromIndex >= list.length || toIndex >= list.length) return;

        final item = list.removeAt(fromIndex);
        list.insert(toIndex, item);
        _refreshBoard();
      },
      onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        final fromList = groupedItems[fromGroupId];
        final toList = groupedItems[toGroupId];
        if (fromList == null || toList == null || fromIndex >= fromList.length) return;

        final item = fromList.removeAt(fromIndex);
        if (toIndex >= toList.length) {
          toList.add(item);
        } else {
          toList.insert(toIndex, item);
        }
        _refreshBoard();
      },
    );

    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await ref
        .read(taskBySprintControllerProvider(widget.projectId).notifier)
        .getTaskBySprint(widget.projectId);

    groupedItems.clear();

    for (final entry in groupOrder) {
      final id = entry.key;
      final name = entry.value;

      final filtered = tasks
          .where((e) => e.taskStatus?.id?.toString() == id)
          .map((task) => MyGroupItem(
                taskId: task.id?.toString() ?? '',
                title: task.name ?? '',
                subtitle: task.description,
              ))
          .toList();

      groupedItems[id] = filtered;
    }

    _refreshBoard();
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

    setState(() {});
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
              child: Card(
                elevation: 3,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    groupItem.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: groupItem.subtitle != null
                      ? Text(groupItem.subtitle!)
                      : null,
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
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
