import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:project/components/form_startdate_and_enddate_widget.dart';
import 'package:project/models/task_model.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/models/task_status_model.dart';
import 'package:project/screens/project/project_datail/providers/controllers/delete_task_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/insert_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/master_task_status_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/task_controller.dart';
import 'package:project/screens/project/project_datail/views/widgets/count_work_type_widget.dart';
import 'package:project/screens/project/project_datail/views/widgets/detil_task_screen.dart';
import 'package:project/screens/project/project_datail/views/widgets/route_observer.dart';
import 'package:project/screens/project/project_datail/views/widgets/task_screen.dart';
import 'package:project/screens/project/sprint/views/widgets/insert_update_sprint.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'package:project/utils/extension/date.dart';

final formStartDateProvider = StateProvider<DateTime?>((ref) => null);
final formEndDateProvider = StateProvider<DateTime?>((ref) => null);

// Widget สำหรับแสดงกลุ่มงานใน Backlog หรือ Sprint
class BacklogGroupWidget extends ConsumerStatefulWidget {
  final bool isExpanded;
  final SprintModel? item;

  const BacklogGroupWidget({super.key, this.isExpanded = false, this.item});

  @override
  ConsumerState<BacklogGroupWidget> createState() => _BacklogGroupWidgetState();
}

class _BacklogGroupWidgetState extends ConsumerState<BacklogGroupWidget> with RouteAware {
  bool isExpanding = false;
  bool _isHovering = false;
  final TextEditingController _sprintNameController = TextEditingController();
  final TextEditingController _sprintGoalController = TextEditingController();
  GlobalKey<FormState> _formStartSprintKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // โหลด Task หลังจาก UI ถูกสร้างเสร็จ
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTasks());
  }

  void _loadTasks() {
    // โหลดรายการงานตาม projectHdId
    final projectHdId = ref.read(selectProjectIdProvider)!;
    ref.read(taskBySprintControllerProvider(projectHdId).notifier).fetch();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // subscribe เพื่อ track route changes
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    // ยกเลิกการติดตาม route
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // เมื่อกลับมาจากหน้าอื่น โหลด Task ใหม่
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTasks());
  }

  @override
  Widget build(BuildContext context) {
    // ดึงค่า project และ sprint ที่เกี่ยวข้อง
    final projectHdId = ref.watch(selectProjectIdProvider)!;
    final sprintId = widget.item?.id ?? '0';
    // ดึงสถานะของ task และ task status
    final taskState = ref.watch(taskBySprintControllerProvider(projectHdId));
    final taskStatusState = ref.watch(masterTaskStatusControllerProvider);

    // filter task ที่อยู่ใน sprint ปัจจุบัน
    final List<TaskModel> taskList = taskState.when(
      data: (tasks) => tasks.where((task) => task.sprint?.id == sprintId).toList(),
      loading: () => [],
      error: (_, __) => [],
    );

    // ดึง list ของสถานะทั้งหมด
    final List<TaskStatusModel> taskStatusList = taskStatusState.maybeWhen(data: (list) => list, orElse: () => []);

    return LayoutBuilder(
      builder: (context, constraints) {
        // ตรวจสอบว่าเป็นจอเล็กหรือไม่
        bool isSmallScreen = constraints.maxWidth < 600;

        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isSmallScreen, taskList.length),
              if (isSmallScreen) Padding(padding: const EdgeInsets.only(top: 10), child: _buildCountersAndButton(taskList.length)),
              if (isExpanding) ...[
                if (taskList.isEmpty) _buildEmptyTaskMessage(),
                ...taskList.map((task) => _buildTaskTile(task, projectHdId, taskStatusList)),
                const Divider(thickness: 1, height: 25),
                _buildCreateButton(),
              ],
            ],
          ),
        );
      },
    );
  }

  // Header ของกล่อง backlog/sprint
  Widget _buildHeader(bool isSmallScreen, int taskCount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              IconButton(
                icon: isExpanding ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more),
                onPressed: () => setState(() => isExpanding = !isExpanding),
              ),
              // ชื่อ sprint/backlog + จำนวนงาน
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(text: widget.item?.name ?? 'Backlog', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      TextSpan(
                        text: ' ($taskCount work items)',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 71, 71, 71)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isSmallScreen) Flexible(child: _buildCountersAndButton(taskCount)),
      ],
    );
  }

  // แสดงข้อความเมื่อไม่มีงานในรายการ
  Widget _buildEmptyTaskMessage() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.assignment_outlined, size: 35, color: Colors.grey[600]),
            const SizedBox(height: 8),
            Text('ไม่มีงานในรายการ', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
            const SizedBox(height: 4),
            Text('กดปุ่ม + เพื่อเพิ่มงานใหม่', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  // สร้าง tile สำหรับแต่ละงาน
  Widget _buildTaskTile(TaskModel task, String projectHdId, List<TaskStatusModel> taskStatusList) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        title: Text(task.name ?? '-', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        subtitle: Text(task.description ?? '', style: const TextStyle(fontSize: 14, color: Colors.black54)),
        leading: const Icon(Icons.check_box, color: Color.fromARGB(255, 77, 100, 231), size: 20),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CommentScreen(task: task))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTaskStatusDropdown(task, projectHdId, taskStatusList),
            const SizedBox(width: 8),

            // ชื่อของผู้รับผิดชอบ หรือ "-"
            Text(task.assignedTo?.name ?? '-', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w100)),
            const SizedBox(width: 4),

            // รูปโปรไฟล์ หรือไอคอนคนถ้าไม่มีรูป
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey[300],
              backgroundImage: (task.assignedTo?.image != null && task.assignedTo!.image!.isNotEmpty) ? NetworkImage(task.assignedTo!.image!) : null,
              child: (task.assignedTo?.image == null || task.assignedTo!.image!.isEmpty) ? const Icon(Icons.person, size: 16, color: Colors.black) : null,
            ),

            const SizedBox(width: 8),

            _buildTaskPopupMenu(task, projectHdId),
          ],
        ),
      ),
    );
  }

  // Dropdown สำหรับเปลี่ยนสถานะของ task
  Widget _buildTaskStatusDropdown(TaskModel task, String projectHdId, List<TaskStatusModel> taskStatusList) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey)),
      constraints: const BoxConstraints(maxWidth: 120),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: task.taskStatus?.name?.toUpperCase() ?? 'TO DO',
          isDense: true,
          iconSize: 18,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          dropdownColor: Colors.white,
          items: const [
            DropdownMenuItem(value: 'TO DO', child: Text('TO DO')),
            DropdownMenuItem(value: 'IN PROGRESS', child: Text('IN PROGRESS')),
            DropdownMenuItem(value: 'IN REVIEW', child: Text('IN REVIEW')),
            DropdownMenuItem(value: 'DONE', child: Text('DONE')),
          ],
          onChanged: (newValue) async {
            if (newValue == null) return;
            final selectedStatus = taskStatusList.firstWhere((status) => status.name?.toUpperCase() == newValue, orElse: () => taskStatusList.first);

            final updatedTask = task.copyWith(taskStatus: TaskStatusModel(id: selectedStatus.id, name: selectedStatus.name));

            try {
              await ref.read(insertOrUpdateTaskControllerProvider.notifier).submit(body: _mapTaskToApi(updatedTask));
              ref.invalidate(taskBySprintControllerProvider(projectHdId));
              await ref.read(taskBySprintControllerProvider(projectHdId).notifier).fetch();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('อัปเดตสถานะล้มเหลว: ${e.toString()}'), backgroundColor: Colors.red));
            }
          },
        ),
      ),
    );
  }

  // แปลง TaskModel เป็น map สำหรับส่งไปยัง API
  Map<String, dynamic> _mapTaskToApi(TaskModel task) {
    final map = {
      'task_id': task.id,
      'task_name': task.name,
      'task_description': task.description,
      'master_priority_id': task.priority?.id,
      'master_task_status_id': task.taskStatus?.id,
      'master_type_of_work_id': task.typeOfWork?.id,
      'sprint_id': task.sprint?.id,
      'project_hd_id': task.projectHd?.id,
    };
    if (task.assignedTo?.id != null) map['task_assigned_to'] = task.assignedTo!.id;
    return map;
  }

  // เมนูเพิ่มเติมของแต่ละงาน (comment, edit, delete)
  Widget _buildTaskPopupMenu(TaskModel task, String projectHdId) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'comment') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CommentScreen(task: task)));
        } else if (value == 'edit') {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen(projectHdId: projectHdId, sprintId: widget.item?.id, task: task)),
          );
          if (result == true) _loadTasks();
        } else if (value == 'delete') {
          _deleteTask(task);
        }
      },
      itemBuilder:
          (context) => const [
            PopupMenuItem(value: 'comment', child: ListTile(leading: Icon(Icons.comment), title: Text('ดูความคิดเห็น'))),
            PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('แก้ไขงาน'))),
            PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete_outline), title: Text('ลบงาน'))),
          ],
    );
  }

  // ปุ่มสำหรับสร้างงานใหม่
  Widget _buildCreateButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () async {
          String? projectHDId = ref.read(selectProjectIdProvider);
          if (projectHDId == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('โปรดเลือกโปรเจกต์ก่อน')));
            return;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("projectHDId: $projectHDId - widget.item?.id: ${widget.item?.id}")));
          }
          // print("projectHdId---------> $projectHdId");
          // print("widget.item?.id---------> ${widget.item?.id}");
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen(projectHdId: projectHDId, sprintId: widget.item?.id)));
          if (result == true) _loadTasks();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(Icons.add, size: 18, color: _isHovering ? Colors.blue[700] : Colors.grey[700]),
              const SizedBox(width: 4),
              Text('Create', style: TextStyle(color: _isHovering ? Colors.blue[700] : Colors.grey[800])),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสำหรับ ลบ Task พร้อม dialog ยืนยัน
  Future<void> _deleteTask(TaskModel task) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext dialogContext) => AlertDialog(
            title: const Text('ยืนยันการลบ'),
            content: Text('คุณต้องการลบงาน "${task.name}" หรือไม่?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('ยกเลิก')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
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
                SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
                SizedBox(width: 16),
                Text('กำลังลบงาน...'),
              ],
            ),
            duration: Duration(seconds: 1),
          ),
        );

        await ref.read(deleteTaskControllerProvider.notifier).deleteTask(task.id ?? '');

        if (mounted) {
          _loadTasks();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('ลบงาน "${task.name}" สำเร็จ'), backgroundColor: Colors.green, duration: const Duration(seconds: 2)));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาดในการลบงาน: ${e.toString()}'), backgroundColor: Colors.red, duration: const Duration(seconds: 3)),
          );
        }
      }
    }
  }

  // ส่วนแสดง counter และปุ่มจัดการ sprint
  Widget _buildCountersAndButton(int taskCount) {
    final isBacklog = widget.item!.id == '1';

    return Align(
      alignment: Alignment.centerRight, // ดันทุกอย่างไปขวาสุด
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CountWorkTypeWidget(title: 'todo', count: '0 of 0'),
          CountWorkTypeWidget(title: 'in progress', count: '0 of 0', color: Colors.lightBlue),
          CountWorkTypeWidget(title: 'in review', count: '0 of 0', color: Colors.deepOrange),
          CountWorkTypeWidget(title: 'done', count: '0 of 0', color: Colors.lightGreenAccent),
          const SizedBox(width: 5),

          // อันนี้ไว้เว้นระยะจากปุ่มถัดไป (เช่น Add Sprint หรือ More)
          if (isBacklog)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 251, 250, 250),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                minimumSize: const Size(0, 32),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              ),
              onPressed: () async {
                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertUpdateSprint()));
                if (result == true) {
                  await ref.read(sprintProvider.notifier).get();
                  ref.invalidate(sprintProvider);
                }
              },
              child: const Text('Create sprint', style: TextStyle(color: Color.fromARGB(255, 91, 91, 91))),
            ),

          if (!isBacklog && widget.item!.startting == false)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 251, 250, 250),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                minimumSize: const Size(0, 32),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              ),
              onPressed: () async {
                var item = widget.item;
                if (item == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('โปรดเลือก Sprint ก่อน')));
                  return;
                }
                _sprintNameController.text = item.name ?? '';
                _sprintGoalController.text = item.goal ?? '';
                ref.read(formStartDateProvider.notifier).state = item.satartDate.formDateTimeJson;
                ref.read(formEndDateProvider.notifier).state = item.endDate.formDateTimeJson;
                // Open dialog เพื่อเริ่ม sprint
                showDialog(
                  context: context,
                  builder: (context) {
                    return Consumer(
                      builder: (context, ref, child) {
                        DateTime? startDate = ref.watch(formStartDateProvider);
                        DateTime? endDate = ref.watch(formEndDateProvider);
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Start Sprint'),
                          content: Form(
                            key: _formStartSprintKey,
                            child: Column(
                              spacing: 4,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('$taskCount work items will be included in this sprint.'),
                                const Text('Required fields are marked with an asterisk *'),
                                Gap(10),
                                // Text('Sprint name'),
                                TitleWidget(text: 'Sprint name'),
                                SizedBox(
                                  width: 400,
                                  child: TextFormField(
                                    controller: _sprintNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter sprint name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Gap(10),
                                TitleWidget(text: 'Start date'),
                                SizedBox(
                                  width: 400,
                                  child: FormStartDateWidget(
                                    startDate: startDate,
                                    endDate: endDate,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select start date';
                                      }
                                      return null;
                                    },
                                    onChanged: (DateTime date) => ref.read(formStartDateProvider.notifier).state = date,
                                  ),
                                ),
                                Gap(10),
                                TitleWidget(text: 'End date'),
                                SizedBox(
                                  width: 400,
                                  child: FormEndDateWidget(
                                    startDate: startDate,
                                    endDate: endDate,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select start date';
                                      }
                                      return null;
                                    },
                                    onChanged: (date) => ref.read(formEndDateProvider.notifier).state = date,
                                  ),
                                ),
                                Text('Sprint goal'),
                                SizedBox(
                                  width: 552,
                                  child: TextFormField(
                                    controller: _sprintGoalController,
                                    minLines: 4, // เริ่มต้นสูง 4 บรรทัด
                                    maxLines: null, // ขยายอัตโนมัติเมื่อพิมพ์เพิ่ม
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      hintText: 'Enter sprint goal',
                                      hintStyle: TextStyle(color: Colors.grey[400]),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                            FilledButton(
                              onPressed: () async {
                                if (!_formStartSprintKey.currentState!.validate()) {
                                  return; // ถ้าไม่ผ่านการตรวจสอบ validation ให้หยุดที่นี่
                                }
                                try {
                                  await ref
                                      .read(insertUpdateSprintProvider.notifier)
                                      .startSprint(
                                        item.id!,
                                        _sprintGoalController.text.isEmpty ? null : _sprintGoalController.text,
                                        _sprintNameController.text.isEmpty ? item.name! : _sprintNameController.text,
                                      );
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sprint started successfully')));
                                  }
                                } catch (e,stx) {
                                  print('Error starting sprint: $stx');
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error starting sprint: ${e.toString()}')));
                                  }
                                  return; // ถ้าเกิดข้อผิดพลาด ให้หยุดที่นี่
                                }
                              },
                              child: const Text('Start'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: const Text('Start sprint', style: TextStyle(color: Color.fromARGB(255, 91, 91, 91))),
            ),
          if (!isBacklog && widget.item!.startting == true && widget.item!.completed == false)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 251, 250, 250),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                minimumSize: const Size(0, 32),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              ),
              onPressed: () async {
                // final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertUpdateSprint()));
                // if (result == true) {
                //   await ref.read(sprintProvider.notifier).get();
                //   ref.invalidate(sprintProvider);
                // }
              },
              child: const Text('Complete sprint', style: TextStyle(color: Color.fromARGB(255, 91, 91, 91))),
            ),
          if (!isBacklog)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, color: Colors.grey),
              onSelected: (value) async {
                if (value == 'edit') {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => InsertUpdateSprint(sprint: widget.item)));
                  if (result == true) {
                    await ref.read(sprintProvider.notifier).get();
                    ref.invalidate(sprintProvider);
                  }
                } else if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('ยืนยันการลบ'),
                          content: Text('คุณต้องการลบ Sprint "${widget.item!.name}" ใช่หรือไม่?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ยกเลิก')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('ลบ'),
                            ),
                          ],
                        ),
                  );
                  if (confirm == true) {
                    await ref.read(sprintProvider.notifier).delete(widget.item!.id!);
                    ref.invalidate(sprintProvider);
                    await ref.read(sprintProvider.notifier).get();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ลบ Sprint สำเร็จ')));
                    }
                  }
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit, size: 20, color: Colors.grey), title: Text('edit sprint'))),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(leading: Icon(Icons.delete_outline, size: 20, color: Colors.grey), title: Text('delete sprint')),
                    ),
                  ],
            ),
        ],
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  final String text;
  const TitleWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(color: Colors.black54),
        children: [TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))],
      ),
    );
  }
}
