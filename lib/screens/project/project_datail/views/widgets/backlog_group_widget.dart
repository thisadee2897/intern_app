// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:project/components/form_startdate_and_enddate_widget.dart';
import 'package:project/models/task_model.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/models/task_status_model.dart';
import 'package:project/models/user_login_model.dart';
import 'package:project/screens/auth/widgets/glass_container.dart';
import 'package:project/screens/project/project_datail/providers/controllers/delete_comment_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/insert_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/master_task_status_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/task_detail_controller.dart';
import 'package:project/screens/project/project_datail/views/widgets/count_work_type_widget.dart';
import 'package:project/screens/project/project_datail/views/widgets/route_observer.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'package:project/utils/extension/custom_snackbar.dart';
import 'package:project/utils/extension/date.dart';
import 'package:project/utils/extension/hex_color.dart';
import 'package:project/utils/services/local_storage_service.dart';

import 'backlog_widget.dart';

final selecttingSprintProvider = StateProvider<SprintModel?>((ref) => null);
final inputTaskNameProvider = StateProvider<String>((ref) => '');

class BacklogGroupWidget extends ConsumerStatefulWidget {
  final bool isExpanded;
  final SprintModel item;

  const BacklogGroupWidget({super.key, this.isExpanded = false, required this.item});

  @override
  ConsumerState<BacklogGroupWidget> createState() => _BacklogGroupWidgetState();
}

class _BacklogGroupWidgetState extends ConsumerState<BacklogGroupWidget> with RouteAware {
  bool isExpanding = false;
  // late TextEditingController _sprintNameController;
  // late TextEditingController _sprintGoalController;
  late TextEditingController _taskNameController;

  @override
  void initState() {
    super.initState();
    // โหลด Task หลังจาก UI ถูกสร้างเสร็จ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _sprintNameController = TextEditingController();
      // _sprintGoalController = TextEditingController();
      _taskNameController = TextEditingController();
      ref.read(inputTaskNameProvider.notifier).state = '';
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // subscribe เพื่อ track route changes
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    // ยกเลิกการติดตาม route และ dispose controllers
    routeObserver.unsubscribe(this);
    // _sprintNameController.dispose();
    // _sprintGoalController.dispose();
    _taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.item;
    final selecting = ref.watch(selecttingSprintProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        // ตรวจสอบว่าเป็นจอเล็กหรือไม่
        bool isSmallScreen = constraints.maxWidth < 600;
    return Container(
  margin: const EdgeInsets.all(5),
  padding: const EdgeInsets.all(5),
  decoration: BoxDecoration(
    color: Colors.transparent, // โปร่งใส 100%
    borderRadius: BorderRadius.circular(12), // โค้งมนเหมือน Project Screen
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1), // Shadow เบาๆ
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildHeader(isSmallScreen, data),
      if (isSmallScreen)
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _buildCountersAndButton(data),
        ),
      if (isExpanding) ...[
        if (data.tasks.isEmpty) _buildEmptyTaskMessage(),
        ListView.builder(
          itemCount: data.tasks.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            TaskModel task = data.tasks[index];
            return _buildTaskTile(task);
          },
        ),
        if (selecting == data)
          TextField(
            enabled: !ref.watch(insertOrUpdateTaskControllerProvider).isLoading,
            autofocus: true,
            onTapOutside: (event) => ref.read(selecttingSprintProvider.notifier).state = null,
            onSubmitted: (value) async {
              await onSubmittedTask(value);
            },
            decoration: InputDecoration(
              prefix: ref.watch(insertOrUpdateTaskControllerProvider).isLoading
                  ? const CircularProgressIndicator(color: Colors.blue)
                  : null,
            ),
            controller: _taskNameController,
            onChanged: (value) => ref.read(inputTaskNameProvider.notifier).state = value,
          ),
        if (selecting != data) _buildCreateButton(data),
      ],
    ],
  ),
);



      },
    );
  }

  Future<void> onSubmittedTask(String inputText) async {
    UserLoginModel userLogin = await ref.read(localStorageServiceProvider).getUserLogin();
    final taskJson = {
      "task_id": "0",
      "project_hd_id": ref.read(selectProjectIdProvider)!,
      "sprint_id": ref.read(selecttingSprintProvider)!.id,
      "master_priority_id": "1",
      "master_task_status_id": "1",
      "master_type_of_work_id": "1",
      "task_name": inputText,
      "task_description": "",
      "task_assigned_to": userLogin.user!.id,
      "task_start_date": null,
      "task_end_date": null,
      "task_is_active": true,
    };
    try {
      await ref.read(insertOrUpdateTaskControllerProvider.notifier).submit(body: taskJson);
      if (!mounted) return;
      ref.read(sprintProvider.notifier).getWithOutLoading();
      _taskNameController.clear();
      ref.read(inputTaskNameProvider.notifier).state = '';
    } catch (e) {
      if (mounted) {
  CustomSnackbar.showSnackBar(
    context: context,
    title: "ผิดพลาด",
    message: "เกิดข้อผิดพลาด: ${e.toString()}",
    contentType: ContentType.failure,color: Colors.red,
  );
}
    }
  }

  /// สร้าง Header ของกล่อง backlog/sprint
  Widget _buildHeader(bool isSmallScreen, SprintModel data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  icon: isExpanding ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more),
                  onPressed: () => setState(() => isExpanding = !isExpanding),
                  tooltip: isExpanding ? 'ย่อ' : 'ขยาย',
                ),
              ),
              // ชื่อ sprint/backlog + จำนวนงาน
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(text: widget.item.name ?? 'Backlog', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, )),
                      TextSpan(
                        text: ' (${data.tasks.length} work items)',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isSmallScreen) Flexible(child: _buildCountersAndButton(data)),
      ],
    );
  }

  /// แสดงข้อความเมื่อไม่มีงานในรายการ
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

  /// สร้าง tile สำหรับแต่ละงาน
  Widget _buildTaskTile(TaskModel task) {
    final projectHdId = ref.watch(selectProjectIdProvider)!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
  color: Colors.white.withOpacity(0.1), // 0.0-1.0 ปรับความโปร่งใส
),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        title: Text(task.name ?? '-', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        // subtitle: Text(task.description ?? '', style: const TextStyle(fontSize: 14, color: Colors.black54)),
        leading: const Icon(Icons.check_box_outlined, color: Color.fromARGB(255, 77, 100, 231), size: 20),
        // onTap: () => _navigateToCommentScreen(task),
        onTap: () {
          ref.read(showTaskDetailProvider.notifier).state = true;
          ref.read(taskDetailProvider.notifier).getTaskDetail(task.id!);
          ref.read(commentTaskProvider.notifier).getCommentTask(task.id!);
        },
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [_buildTaskStatusDropdown(task, projectHdId), Gap(8), _buildAssigneeInfo(task)]),
      ),
    );
  }

  //แสดงข้อมูลผู้รับผิดชอบเดิมๆ
  // Widget _buildAssigneeInfo(TaskModel task) {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Tooltip(
  //         message: task.assignedTo?.id ?? 'ไม่มีผู้รับผิดชอบ',
  //         child: CircleAvatar(
  //           radius: 12,
  //           backgroundColor: Colors.grey[300],
  //           backgroundImage: (task.assignedTo?.image != null && task.assignedTo!.image!.isNotEmpty) ? NetworkImage(task.assignedTo!.image!) : null,
  //           child: (task.assignedTo?.image == null || task.assignedTo!.image!.isEmpty) ? const Icon(Icons.person, size: 16, color: Colors.black) : null,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  //แสดงข้อมูลผู้รับผิดชอบอันใหม่
  //ใช้ได้แล้วเย้ๆ
  Widget _buildAssigneeInfo(TaskModel task) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: task.assignedTo?.name ?? 'ไม่มีผู้รับผิดชอบ',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              color: Colors.grey[300],
              width: 35,
              height: 35,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: task.assignedTo?.image ?? '',
                errorWidget: (context, url, error) => const Icon(Icons.person, size: 16, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
  // Tooltip(
  //         message: task.assignedTo?.name ?? 'ไม่มีผู้รับผิดชอบ',
  //         child: CircleAvatar(
  //           radius: 12,
  //           backgroundColor: Colors.grey[300],
  //           backgroundImage:
  //               userProfileImage.maybeWhen(data: (url) => url?.isNotEmpty == true ? NetworkImage(url!) : null, orElse: () => null) ??
  //               (hasLocalImage ? NetworkImage(task.assignedTo!.image!) : null),
  //           child: userProfileImage.maybeWhen(
  //             data: (url) => (url?.isNotEmpty == true || hasLocalImage) ? null : const Icon(Icons.person, size: 16, color: Colors.black),
  //             orElse: () => hasLocalImage ? null : const Icon(Icons.person, size: 16, color: Colors.black),
  //           ),
  //         ),
  //       ),

  /// Navigate ไปยังหน้า Comment
  // void _navigateToCommentScreen(TaskModel task) {
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => CommentScreen(task: task)));
  // }

  /// Dropdown สำหรับเปลี่ยนสถานะของ task
  Widget _buildTaskStatusDropdown(TaskModel task, String projectHdId) {
    final listDropdown = ref.watch(masterTaskStatusControllerProvider).value ?? [];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey)),
      constraints: const BoxConstraints(maxWidth: 120),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: task.taskStatus!.id,
          isDense: true,
          iconSize: 18,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          dropdownColor: Colors.white,
          items:
              listDropdown.map<DropdownMenuItem<String>>((status) {
                return DropdownMenuItem<String>(value: status.id, child: Text(status.name ?? 'ไม่ระบุ', style: const TextStyle(fontSize: 12)));
              }).toList(),
          onChanged: (newStatusId) => _updateTaskStatus(task, newStatusId, projectHdId),
        ),
      ),
    );
  }

  /// อัปเดตสถานะของ Task
  Future<void> _updateTaskStatus(TaskModel task, String? newStatusId, String projectHdId) async {
    if (newStatusId == null) return;
    try {
      // หา status จาก ID
      final taskStatusList = ref.read(masterTaskStatusControllerProvider).value ?? [];
      final selectedStatus = taskStatusList.firstWhere(
        (status) => status.id == newStatusId,
        orElse: () => taskStatusList.isNotEmpty ? taskStatusList.first : TaskStatusModel(),
      );
      // สร้าง Task ที่อัปเดตแล้ว
      final updatedTask = task.copyWith(taskStatus: TaskStatusModel(id: selectedStatus.id, name: selectedStatus.name));

      // ส่งข้อมูลไปยัง API
      await ref.read(insertOrUpdateTaskControllerProvider.notifier).submit(body: _mapTaskToApi(updatedTask));
      ref.read(sprintProvider.notifier).updateStatusTask(selectedStatus, updatedTask);
    } catch (e) {
      // แสดง error message
      _showErrorMessage('อัปเดตสถานะล้มเหลว: ${e.toString()}');
    }
  }

  /// แสดง error message
  void _showErrorMessage(String message) {
  if (!mounted) return;
  CustomSnackbar.showSnackBar(
    context: context,
    title: "ผิดพลาด",
    message: message,
    contentType: ContentType.failure,color: Colors.red,
  );
}

  /// แปลง TaskModel เป็น map สำหรับส่งไปยัง API
  Map<String, dynamic> _mapTaskToApi(TaskModel task) {
    final map = <String, dynamic>{
      'task_id': task.id,
      'task_name': task.name,
      'task_description': task.description,
      'master_priority_id': task.priority?.id,
      'master_task_status_id': task.taskStatus?.id,
      'master_type_of_work_id': task.typeOfWork?.id,
      'sprint_id': task.sprint?.id,
      'project_hd_id': task.projectHd?.id,
    };

    // เพิ่ม assigned_to ถ้ามี
    if (task.assignedTo?.id != null) {
      map['task_assigned_to'] = task.assignedTo!.id;
    }

    return map;
  }

  /// เมนูเพิ่มเติมของแต่ละงาน (comment, edit, delete)
  // Widget _buildTaskPopupMenu(TaskModel task, String projectHdId) {
  //   return SizedBox(
  //     width: 48,
  //     height: 48,
  //     child: PopupMenuButton<String>(
  //       tooltip: 'ตัวเลือกเพิ่มเติม',
  //       onSelected: (value) => _handleTaskMenuAction(value, task, projectHdId),
  //       itemBuilder:
  //           (context) => const [
  //             PopupMenuItem(value: 'comment', child: ListTile(leading: Icon(Icons.comment), title: Text('ดูความคิดเห็น'))),
  //             PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('แก้ไขงาน'))),
  //             PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete_outline), title: Text('ลบงาน'))),
  //           ],
  //     ),
  //   );
  // }

  /// จัดการ action ของเมนู Task
  // Future<void> _handleTaskMenuAction(String action, TaskModel task, String projectHdId) async {
  //   switch (action) {
  //     case 'comment':
  //       _navigateToCommentScreen(task);
  //       break;
  //     case 'edit':
  //       await _navigateToEditTask(task, projectHdId);
  //       break;
  //     case 'delete':
  //       await _deleteTask(task);
  //       break;
  //   }
  // }

  /// ปุ่มสำหรับสร้างงานใหม่
  Widget _buildCreateButton(SprintModel sprint) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: OutlinedButton(
        onPressed: () async {
          _taskNameController.text = ref.read(inputTaskNameProvider);
          ref.read(selecttingSprintProvider.notifier).state = sprint;
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(Icons.add, size: 18, color: Colors.white), const SizedBox(width: 4), Text('Create', style: TextStyle(color: Colors.white))],
        ),
      ),
    );
  }

  /// จัดการการสร้าง Task ใหม่

  /// แสดง Success SnackBar
   void _showSuccessSnackBar(String message) {
  if (!mounted) return;
  CustomSnackbar.showSnackBar(
    context: context,
    title: "สำเร็จ",
    message: message,
    contentType: ContentType.success,color: Colors.green,
  );
}

void _showErrorSnackBar(String message) {
  if (!mounted) return;
  CustomSnackbar.showSnackBar(
    context: context,
    title: "ผิดพลาด",
    message: message,
    contentType: ContentType.failure,color: Colors.red,
  );
}

  /// ส่วนแสดง counter และปุ่มจัดการ sprint
  Widget _buildCountersAndButton(SprintModel data) {
    final isBacklog = widget.item.id == '1';
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...data.countStatus.map((status) {
            return CountWorkTypeWidget(title: status.name ?? 'ไม่ระบุ', count: '${status.count}', color: HexColor.fromHex(status.color ?? '#CCCCCC'));
          }),
          // // แสดง counter ของแต่ละสถานะ
          // CountWorkTypeWidget(title: 'todo', count: '0 of 0'),
          // CountWorkTypeWidget(title: 'in progress', count: '0 of 0', color: Colors.lightBlue),
          // CountWorkTypeWidget(title: 'in review', count: '0 of 0', color: Colors.deepOrange),
          // CountWorkTypeWidget(title: 'done', count: '0 of 0', color: Colors.lightGreenAccent),
          const SizedBox(width: 5),
          SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ปุ่มสำหรับ Backlog
                if (isBacklog) _buildCreateSprintButton(),
                // ปุ่มสำหรับ Sprint ที่ยังไม่เริ่ม
                if (!isBacklog && widget.item.startting == false) _buildStartSprintButton(data.tasks.length),
                // ปุ่มสำหรับ Sprint ที่เริ่มแล้วแต่ยังไม่เสร็จ
                if (!isBacklog && widget.item.startting == true && widget.item.completed == false) _buildCompleteSprintButton(widget.item),
                // เมนูเพิ่มเติมสำหรับ Sprint
                if (!isBacklog) _buildSprintMoreMenu(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ปุ่มสร้าง Sprint ใหม่
  Widget _buildCreateSprintButton() {
    return ElevatedButton(
      style: _getButtonStyle(),
      onPressed: () => _handleCreateOrUpdateSprint(SprintModel(id: '0')),
      child: const Text('Create sprint', style: TextStyle(color: Color.fromARGB(255, 91, 91, 91))),
    );
  }

  /// ปุ่มเริ่ม Sprint
  Widget _buildStartSprintButton(int taskCount) {
    return ElevatedButton(
      style: _getButtonStyle(),
      onPressed: () => _handleStartSprint(taskCount),
      child: const Text('Start sprint', style: TextStyle(color: Color.fromARGB(255, 91, 91, 91))),
    );
  }

  /// ปุ่มจบ Sprint
  Widget _buildCompleteSprintButton(SprintModel item) {
    return ElevatedButton(
      style: _getButtonStyle(),
      onPressed: () => _handleCompleteSprint(item),
      child: const Text('Complete sprint', style: TextStyle(color: Color.fromARGB(255, 91, 91, 91))),
    );
    
  }

  /// Style ของปุ่ม
  ButtonStyle _getButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 251, 250, 250),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      minimumSize: const Size(0, 32),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    );
  }

  /// จัดการการสร้าง Sprint ใหม่
  Future<void> _handleCreateOrUpdateSprint(SprintModel itemSprint) async {
    // _sprintNameController.text = itemSprint.name ?? '';
    // _sprintGoalController.text = itemSprint.goal ?? '';

    // Ensure we have valid data before setting the item
    final validatedSprint = SprintModel(
      tableName: itemSprint.tableName,
      id: itemSprint.id,
      name: itemSprint.name ?? '', // Ensure name is never null
      duration: itemSprint.duration,
      satartDate: itemSprint.satartDate,
      endDate: itemSprint.endDate,
      goal: itemSprint.goal,
      completed: itemSprint.completed,
      projectHd: itemSprint.projectHd,
      createdAt: itemSprint.createdAt,
      updatedAt: itemSprint.updatedAt,
      createdBy: itemSprint.createdBy,
      updatedBy: itemSprint.updatedBy,
      active: itemSprint.active,
      startting: itemSprint.startting,
      tasks: itemSprint.tasks,
      countStatus: itemSprint.countStatus,
    );

    ref.read(insertUpdateSprintProvider.notifier).setItem(validatedSprint);
    final formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(insertUpdateSprintProvider);

            // Use Future.microtask to delay provider state modification
            if (state.hasValue) {
              Future.microtask(() {
                DateTime? startDate = state.value?.satartDate != null ? DateTime.parse(state.value!.satartDate!) : null;
                DateTime? endDate = state.value?.endDate != null ? DateTime.parse(state.value!.endDate!) : null;
                ref.read(formStartDateProvider.notifier).state = startDate;
                ref.read(formEndDateProvider.notifier).state = endDate;
              });
            }

            // Handle error state
            if (state.hasError) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text('Error'),
                content: Text('Failed to load sprint data: ${state.error}'),
                actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
              );
            }

            // Handle loading state
            if (state.isLoading) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text('Loading'),
                content: const SizedBox(width: 400, height: 200, child: Center(child: CircularProgressIndicator())),
              );
            }

           return Dialog(
  insetPadding: const EdgeInsets.all(16),
  backgroundColor: Colors.transparent,
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 600),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FloatingCard(
          padding: const EdgeInsets.all(24),
          child: Form(
    key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                '${state.value?.id == '0' ? 'Create' : 'Update'} Sprint',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              const Text('Required fields are marked with an asterisk *',
                  style: TextStyle(color: Colors.white70)),
              const Gap(10),

              // Sprint name
              const Text('Sprint goal', style: TextStyle(color: Colors.white)),
              SizedBox(
                width: 400,
                child: TextFormField(
                  initialValue: itemSprint.name ?? '',
                  onChanged: (value) {
                    if (value.trim().isNotEmpty) {
                      ref.read(insertUpdateSprintProvider.notifier).updateName(value);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter sprint name';
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: HexColor.fromHex('#001B4B'),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: HexColor.fromHex('#00C6FF'), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
              const Gap(10),

          // Start Date
 const TitleWidget(text: 'Start date'),
                    SizedBox(
                      width: 400,
                      child: FormStartDateWidget(
                        startDate: ref.watch(formStartDateProvider),
                        endDate: ref.watch(formEndDateProvider),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select start date';
                          }
                          return null;
                        },
                        onChanged: (DateTime date) {
                          ref.read(insertUpdateSprintProvider.notifier).updateStartDate(date);
                        },
                      ),
                    ),
                    const Gap(10),
                    const TitleWidget(text: 'End date'),
                    SizedBox(
                      width: 400,
                      child: FormEndDateWidget(
                        startDate: ref.watch(formStartDateProvider),
                        endDate: ref.watch(formEndDateProvider),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select end date';
                          }
                          return null;
                        },
                        onChanged: (date) {
                          ref.read(insertUpdateSprintProvider.notifier).updateEndDate(date);
                        },
                      ),
                    ),
                        // Sprint goal
              const Text('Sprint goal', style: TextStyle(color: Colors.white)),
              SizedBox(
                width: 552,
                child: TextFormField(
                  initialValue: itemSprint.goal ?? '',
                  minLines: 4,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    ref.read(insertUpdateSprintProvider.notifier).updateGoal(value);
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter sprint goal',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: HexColor.fromHex('#001B4B'),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: HexColor.fromHex('#00C6FF'), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Active Switch
              Row(
                children: [
                  Switch(
                    value: state.value?.active == true,
                    onChanged: (value) {
                      ref.read(insertUpdateSprintProvider.notifier).updateActiveStatus(value);
                    },
                    activeColor: Colors.green,
                  ),
                  Text(state.value?.active == true ? 'Active' : 'Inactive',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: HexColor.fromHex('#002B77'), width: 2),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() == true) {
                        try {
                          final value = await ref
                              .read(insertUpdateSprintProvider.notifier)
                              .insertOrUpdateSprint();
                          if (value != null) {
                            Navigator.pop(context, value);
                            CustomSnackbar.showSnackBar(
                              context: context,
                              title: "สำเร็จ",
                              message: "Sprint ${value.name} created successfully",
                              contentType: ContentType.success,
                              color: Colors.green,
                            );
                            ref.read(sprintProvider.notifier).get();
                            ref.read(insertUpdateSprintProvider.notifier).clearState();
                          }
                        } catch (e) {
                          _showErrorSnackBar('Error creating sprint: ${e.toString()}');
                        }
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: HexColor.fromHex('#003B99'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                    ),
                    child: Text('${state.value?.id == '0' ? 'Create' : 'Update'} Sprint'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  ),
),
           );

          },
        );
      },
    );
  }

  /// จัดการการเริ่ม Sprint
  Future<void> _handleStartSprint(int taskCount) async {
    final item = widget.item;
    // ตั้งค่าข้อมูลเริ่มต้น
    // _sprintNameController.text = item.name ?? '';
    // _sprintGoalController.text = item.goal ?? '';
    ref.read(formStartDateProvider.notifier).state = item.satartDate.formDateTimeJson;
    ref.read(formEndDateProvider.notifier).state = item.endDate.formDateTimeJson;

    // แสดง dialog สำหรับเริ่ม sprint
    if (!mounted) return;
    await _showStartSprintDialog(taskCount, item);
    ref.invalidate(sprintProvider);
    await ref.read(sprintProvider.notifier).get();

  }

  /// จัดการการจบ Sprint
Future<void> _handleCompleteSprint(SprintModel item) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          var nextSprint = ref.watch(selectNextSprint);
          var nextSprintList = ref.watch(dropDownSprintFormCompleteProvider);

          return Center(
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 500,
                  maxWidth: 500,
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SingleChildScrollView(
                      child: FloatingCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 70), // เว้นพื้นที่ให้รูป
                            Text(
                              'Complete Sprint "${item.name}"',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Gap(16),
                            Text(
                              'This sprint contains 0 completed work items and 10 open work items.',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const Gap(8),
                            Text(
                              'Completed work items includes everything in the last column on the board, Done.',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const Gap(8),
                            Text(
                              'Open work items includes everything from any other column on the board. Move these to a new sprint or the backlog.',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const Gap(16),
                            Text(
                              'Move open work items to next sprint or backlog',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                            ),
                            const Gap(10),
                            Material(
                              color: Colors.transparent,
                              child: nextSprintList.when(
                                data: (data) {
                                  return DropdownButtonFormField<SprintModel>(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: HexColor.fromHex('#001B4B'),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: HexColor.fromHex('#00C6FF'), width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Colors.white, width: 2),
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    isExpanded: true,
                                    value: nextSprint,
                                    items: data
                                        .map((item) => DropdownMenuItem<SprintModel>(
                                              value: item,
                                              child: Text(item.name ?? 'No name', style: const TextStyle(fontSize: 14, color: Colors.white)),
                                            ))
                                        .toList(),
                                    onChanged: (item) {
                                      ref.read(selectNextSprint.notifier).state = item;
                                    },
                                  );
                                },
                                error: (_, __) => const Text('Error loading next sprint', style: TextStyle(color: Colors.red)),
                                loading: () => const Center(child: CircularProgressIndicator()),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: HexColor.fromHex('#002B77'), width: 2),
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                                  ),
                                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(width: 12),
                                FilledButton(
                                  onPressed: () async {
                                    try {
                                      await ref
                                          .read(updateSprintToCompleteProvider.notifier)
                                          .updateComplete(sprintCompleteId: item.id!, moveTaskToSprintId: nextSprint!.id!);
                                      if (!mounted) return;
                                      Navigator.pop(context);
                                      _showSuccessSnackBar('Sprint completed successfully');
                                      ref.invalidate(sprintProvider);
        await ref.read(sprintProvider.notifier).get();

                                    } catch (e) {
                                      _showErrorSnackBar('Error completing sprint: ${e.toString()}');
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: HexColor.fromHex('#003B99'),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                                  ),
                                  child: const Text('Complete', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          'assets/images/complete.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}



  /// แสดง Dialog สำหรับเริ่ม Sprint
  Future<void> _showStartSprintDialog(int taskCount, SprintModel item) async {
  final formKey = GlobalKey<FormState>();

  return showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          return Dialog(
            insetPadding: const EdgeInsets.all(16),
            backgroundColor: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FloatingCard(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header
                          Text(
                            'Start Sprint',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '$taskCount work items will be included in this sprint.',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const Text('Required fields are marked with an asterisk *',
                              style: TextStyle(color: Colors.white70)),
                          const Gap(10),

                          // Sprint name
                          const Text('Sprint name', style: TextStyle(color: Colors.white)),
                          SizedBox(
                            width: 400,
                            child: TextFormField(
                              initialValue: item.name ?? '',
                              onChanged: (value) => ref
                                  .read(insertUpdateSprintProvider.notifier)
                                  .updateName(value),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter sprint name';
                                }
                                return null;
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: HexColor.fromHex('#001B4B'),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: HexColor.fromHex('#00C6FF'), width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ),
                          const Gap(10),

                        // Start Date
 const Text('Start date', style: TextStyle(color: Colors.white)),
 SizedBox(
   width: 400,
   child: Container(
     decoration: BoxDecoration(
       color: HexColor.fromHex('#001B4B'),
       borderRadius: BorderRadius.circular(12),
       border: Border.all(color: HexColor.fromHex('#00C6FF'), width: 2), // ✅ ขอบเหมือนเพื่อน
     ),
     child: FormStartDateWidget(
       startDate: ref.watch(formStartDateProvider),
       endDate: ref.watch(formEndDateProvider),
       validator: (value) {
         if (value == null || value.isEmpty) {
           return 'Please select start date';
         }
         return null;
       },
       onChanged: (date) =>
           ref.read(formStartDateProvider.notifier).state = date,
     ),
   ),
 ),
 const Gap(10),

 // End Date
 const Text('End date', style: TextStyle(color: Colors.white)),
 SizedBox(
   width: 400,
   child: Container(
     decoration: BoxDecoration(
       color: HexColor.fromHex('#001B4B'),
       borderRadius: BorderRadius.circular(12),
       border: Border.all(color: HexColor.fromHex('#00C6FF'), width: 2), // ✅ ขอบเหมือนเพื่อน
     ),
     child: FormEndDateWidget(
       startDate: ref.watch(formStartDateProvider),
       endDate: ref.watch(formEndDateProvider),
       validator: (value) {
         if (value == null || value.isEmpty) {
           return 'Please select end date';
         }
         return null;
       },
       onChanged: (date) =>
           ref.read(formEndDateProvider.notifier).state = date,
            ),
  ),
),
                        const Gap(10),

                        // Sprint goal
                        const Text('Sprint goal', style: TextStyle(color: Colors.white)),
                        SizedBox(
                          width: 552,
                          child: TextFormField(
                            initialValue: item.goal ?? '',
                            minLines: 4,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            onChanged: (value) => ref
                                .read(insertUpdateSprintProvider.notifier)
                                .updateGoal(value),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter sprint goal',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: HexColor.fromHex('#001B4B'),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: HexColor.fromHex('#00C6FF'), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.white, width: 2),
                              ),
     ),
   ),
 ),
                           const SizedBox(height: 24),

                           // Actions
                           Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               OutlinedButton(
                                 onPressed: () => Navigator.pop(context),
                                 style: OutlinedButton.styleFrom(
                                   side: BorderSide(
                                       color: HexColor.fromHex('#002B77'), width: 2),
                                   backgroundColor: Colors.transparent,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(12),
                                   ),
                                   padding: const EdgeInsets.symmetric(
                                       vertical: 16, horizontal: 28),
                                 ),
                                 child: const Text('Cancel',
                                     style: TextStyle(color: Colors.white)),
                               ),
                               const SizedBox(width: 12),
                               FilledButton(
                                 onPressed: () => _performStartSprint(formKey, item),
                                 style: FilledButton.styleFrom(
                                   backgroundColor: HexColor.fromHex('#003B99'),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(12),
                                   ),
                                   padding: const EdgeInsets.symmetric(
                                       vertical: 16, horizontal: 28),
                                 ),
                                 child: const Text('Start'),
                               ),
                             ],
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             ),
           );
        },
      );
    },
  );
}


  /// ดำเนินการเริ่ม Sprint
  Future<void> _performStartSprint(GlobalKey<FormState> formKey, SprintModel item) async {
    final formState = formKey.currentState;
    if (formState == null) {
      _showErrorSnackBar('เกิดข้อผิดพลาดของแบบฟอร์ม กรุณาลองใหม่');
      return;
    }
    if (!formState.validate()) {
      _showErrorSnackBar('กรุณากรอกข้อมูลให้ครบถ้วน');
      return;
    }
    // ป้องกัน id ว่าง และช่วย debug
    final sprintId = item.id ?? widget.item.id;
    if (sprintId == null || sprintId.isEmpty) {
      _showErrorSnackBar('ไม่พบ Sprint ID สำหรับเริ่ม Sprint');
      return;
    }
    final startD = ref.read(formStartDateProvider);
    final endD = ref.read(formEndDateProvider);
    if (startD == null || endD == null) {
      _showErrorSnackBar('กรุณาเลือกวันที่เริ่มต้นและสิ้นสุด');
      return;
    }
    debugPrint('[StartSprint] id=$sprintId name=${item.name} startDate=$startD endDate=$endD');
    try {
      await ref.read(insertUpdateSprintProvider.notifier).startSprint(sprintId, item.goal ?? '', item.name ?? '');

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();
      _showSuccessSnackBar('Sprint started successfully');
    } catch (e) {
      if (!mounted) return;

      _showErrorSnackBar('Error starting sprint: ${e.toString()}');
    }
  }

  /// เมนูเพิ่มเติมสำหรับ Sprint
  Widget _buildSprintMoreMenu() {
    return SizedBox(
      width: 48,
      height: 48,
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_horiz, color: Colors.grey),
        tooltip: 'ตัวเลือกเพิ่มเติม',
        // onSelected: _handleSprintMenuAction,
        itemBuilder:
            (context) => [
              PopupMenuItem(
                onTap: () => _handleCreateOrUpdateSprint(widget.item),
                value: 'edit',
                child: ListTile(leading: Icon(Icons.edit, size: 20, color: Colors.grey), title: Text('edit sprint')),
              ),
              PopupMenuItem(
                onTap: _handleDeleteSprint,
                value: 'delete',
                child: ListTile(leading: Icon(Icons.delete_outline, size: 20, color: Colors.grey), title: Text('delete sprint')),
              ),
            ],
      ),
    );
  }

  // /// จัดการ action ของเมนู Sprint
  // Future<void> _handleSprintMenuAction(String value) async {
  //   switch (value) {
  //     case 'edit':
  //       await _handleEditSprint();
  //       break;
  //     case 'delete':
  //       await _handleDeleteSprint();
  //       break;
  //   }
  // }

  /// จัดการการลบ Sprint
  Future<void> _handleDeleteSprint() async {
    final confirm = await _showDeleteSprintConfirmDialog();

    if (confirm == true && widget.item.id != null) {
      try {
        await ref.read(sprintProvider.notifier).delete(widget.item.id!);
        ref.invalidate(sprintProvider);
        await ref.read(sprintProvider.notifier).get();

        if (!mounted) return;

        _showSuccessSnackBar('ลบ Sprint สำเร็จ');
      } catch (e) {
        if (!mounted) return;

        _showErrorSnackBar('เกิดข้อผิดพลาด: ${e.toString()}');
      }
    }
  }

  /// แสดง Dialog ยืนยันการลบ Sprint
  Future<bool?> _showDeleteSprintConfirmDialog() {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: FloatingCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  'ยืนยันการลบ',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'คุณต้องการลบ Sprint "${widget.item.name}" ใช่หรือไม่?',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF002B77), width: 2),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                      ),
                      child: const Text('ยกเลิก', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                      ),
                      child: const Text('ลบ', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

}

/// Widget สำหรับแสดง Title พร้อม * สำหรับ required field
class TitleWidget extends StatelessWidget {
  final String text;
  const TitleWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.black54),
        children: const [TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))],
      ),
    );
  }
}
