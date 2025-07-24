import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/task_model.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/screens/project/project_datail/providers/controllers/delete_task_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/task_controller.dart';
import 'package:project/screens/project/project_datail/views/widgets/count_work_type_widget.dart';
import 'package:project/screens/project/project_datail/views/widgets/detil_task_screen.dart';
import 'package:project/screens/project/project_datail/views/widgets/route_observer.dart';
import 'package:project/screens/project/project_datail/views/widgets/task_screen.dart';
import 'package:project/screens/project/sprint/views/widgets/insert_update_sprint.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';

class BacklogGroupWidget extends ConsumerStatefulWidget {
  final bool isExpanded;
  final SprintModel? item;

  const BacklogGroupWidget({super.key, this.isExpanded = false, this.item});

  @override
  ConsumerState<BacklogGroupWidget> createState() => _BacklogGroupWidgetState();
}

class _BacklogGroupWidgetState extends ConsumerState<BacklogGroupWidget>
    with RouteAware {
  bool isExpanding = false;

  @override
  void initState() {
    super.initState();
    isExpanding = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTasks());
  }

  void _loadTasks() {
    final projectHdId = widget.item?.projectHd?.id ?? "1";
    ref.invalidate(taskBySprintControllerProvider(projectHdId));
    ref.read(taskBySprintControllerProvider(projectHdId).notifier).fetch();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTasks());
  }

  @override
  Widget build(BuildContext context) {
    final projectHdId = widget.item?.projectHd?.id ?? "1";
    final sprintId = widget.item?.id ?? 'backlog';

    final taskState = ref.watch(taskBySprintControllerProvider(projectHdId));
    final List<TaskModel> taskList = taskState.when(
      data:
          (tasks) =>
              tasks.where((task) => task.sprint?.id == sprintId).toList(),
      loading: () => [],
      error: (_, __) => [],
    );

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              isExpanding
                                  ? const Icon(Icons.expand_less)
                                  : const Icon(Icons.expand_more),
                          onPressed:
                              () => setState(() => isExpanding = !isExpanding),
                        ),
                        Expanded(
                          child: Text(
                            widget.item?.name ?? 'Backlog',
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          tooltip: 'เพิ่มงาน',
                          color: Colors.blueAccent,
                          visualDensity: VisualDensity.compact,
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AddTaskScreen(
                                      projectHdId: projectHdId,
                                      sprintId: widget.item?.id,
                                    ),
                              ),
                            );
                            if (result == true) {
                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) => _loadTasks(),
                              );
                            }
                          },
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
              if (isExpanding) ...[
                if (taskList.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ไม่มีงานในรายการ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'กดปุ่ม + เพื่อเพิ่มงานใหม่',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ...taskList.map(
                  (task) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Text(
                        task.name ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(task.description ?? ''),
                      leading: const Icon(
                        Icons.task_alt_rounded,
                        color: Colors.indigo,
                      ),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommentScreen(task: task),
                            ),
                          ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'comment') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CommentScreen(task: task),
                              ),
                            );
                          } else if (value == 'edit') {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => AddTaskScreen(
                                      projectHdId: projectHdId,
                                      sprintId: widget.item?.id,
                                      task: task,
                                    ),
                              ),
                            );
                            if (result == true) _loadTasks();
                          } else if (value == 'delete') {
                            _deleteTask(task);
                          }
                        },
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem(
                                value: 'comment',
                                child: ListTile(
                                  leading: Icon(Icons.comment),
                                  title: Text('ดูความคิดเห็น'),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('แก้ไขงาน'),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(Icons.delete_outline),
                                  title: Text('ลบงาน'),
                                ),
                              ),
                            ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteTask(TaskModel task) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext dialogContext) => AlertDialog(
            title: const Text('ยืนยันการลบ'),
            content: Text('คุณต้องการลบงาน "${task.name}" หรือไม่?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('ยกเลิก'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('ลบ'),
              ),
            ],
          ),
    );

    if (confirm == true && mounted) {
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Text('กำลังลบงาน...'),
              ],
            ),
            duration: Duration(seconds: 1),
          ),
        );

        await ref
            .read(deleteTaskControllerProvider.notifier)
            .deleteTask(task.id ?? '');

        if (mounted) {
          _loadTasks();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ลบงาน "${task.name}" สำเร็จ'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาดในการลบงาน: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
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
      _buildButtonsRow(),
    ];
  }

  Widget _buildButtonsRow() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: 'Create Sprint',
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.blue),
              iconSize: 18,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InsertUpdateSprint(),
                  ),
                );
                if (result == true) {
                  await ref.read(sprintProvider.notifier).get();
                  ref.invalidate(sprintProvider);
                }
              },
            ),
          ),
          if (widget.item != null)
            Tooltip(
              message: 'Edit Sprint',
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                iconSize: 18,
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => InsertUpdateSprint(sprint: widget.item),
                    ),
                  );
                  if (result == true) {
                    await ref.read(sprintProvider.notifier).get();
                    ref.invalidate(sprintProvider);
                  }
                },
              ),
            ),
          Tooltip(
            message: 'Delete Sprint',
            child: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              iconSize: 18,
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
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text('ยกเลิก'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed:
                                        () => Navigator.pop(context, true),
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
        ],
      ),
    );
  }
}
