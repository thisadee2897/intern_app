import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
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

/// Provider สำหรับจัดการวันที่เริ่มต้น Sprint
final formStartDateProvider = StateProvider<DateTime?>((ref) => null);

/// Provider สำหรับจัดการวันที่สิ้นสุด Sprint
final formEndDateProvider = StateProvider<DateTime?>((ref) => null);

/// Widget สำหรับแสดงกลุ่มงานใน Backlog หรือ Sprint
/// รองรับการแสดงผลแบบ responsive และจัดการ state ด้วย Riverpod
class BacklogGroupWidget extends ConsumerStatefulWidget {
  /// กำหนดว่า widget นี้ควรขยายแสดงงานหรือไม่
  final bool isExpanded;
  
  /// ข้อมูล Sprint ที่จะแสดง (null หมายถึง Backlog)
  final SprintModel? item;

  const BacklogGroupWidget({
    super.key, 
    this.isExpanded = false, 
    this.item,
  });

  @override
  ConsumerState<BacklogGroupWidget> createState() => _BacklogGroupWidgetState();
}

class _BacklogGroupWidgetState extends ConsumerState<BacklogGroupWidget> 
    with RouteAware {
  /// ควบคุมการขยาย/ย่อของ widget
  bool isExpanding = false;
  
  /// ติดตามสถานะ hover ของปุ่ม
  bool _isHovering = false;
  
  /// Controller สำหรับชื่อ Sprint
  final TextEditingController _sprintNameController = TextEditingController();
  
  /// Controller สำหรับเป้าหมาย Sprint
  final TextEditingController _sprintGoalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // โหลด Task หลังจาก UI ถูกสร้างเสร็จ
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTasks());
  }

  /// โหลดรายการงานตาม projectHdId
  void _loadTasks() {
    final projectHdId = ref.read(selectProjectIdProvider);
    if (projectHdId != null) {
      ref.read(taskBySprintControllerProvider(projectHdId).notifier).fetch();
    }
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
    _sprintNameController.dispose();
    _sprintGoalController.dispose();
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
    final projectHdId = ref.watch(selectProjectIdProvider);
    final sprintId = widget.item?.id ?? '0';
    
    // ตรวจสอบว่ามี projectHdId หรือไม่
    if (projectHdId == null) {
      return const Center(
        child: Text('กรุณาเลือกโปรเจกต์ก่อน'),
      );
    }

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
    final List<TaskStatusModel> taskStatusList = taskStatusState.maybeWhen(
      data: (list) => list, 
      orElse: () => [],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // ตรวจสอบว่าเป็นจอเล็กหรือไม่
        bool isSmallScreen = constraints.maxWidth < 600;
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey[100], 
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isSmallScreen, taskList.length),
              if (isSmallScreen) 
                Padding(
                  padding: const EdgeInsets.only(top: 10), 
                  child: _buildCountersAndButton(taskList.length),
                ),
              if (isExpanding) ...[
                if (taskList.isEmpty) 
                  _buildEmptyTaskMessage(),
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

  /// สร้าง Header ของกล่อง backlog/sprint
  Widget _buildHeader(bool isSmallScreen, int taskCount) {
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
                  icon: isExpanding 
                    ? const Icon(Icons.expand_less) 
                    : const Icon(Icons.expand_more),
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
                      TextSpan(
                        text: widget.item?.name ?? 'Backlog', 
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' ($taskCount work items)',
                        style: const TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.bold, 
                          color: Color.fromARGB(255, 71, 71, 71),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isSmallScreen) 
          Flexible(child: _buildCountersAndButton(taskCount)),
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
            Icon(
              Icons.assignment_outlined, 
              size: 35, 
              color: Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              'ไม่มีงานในรายการ', 
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 4),
            Text(
              'กดปุ่ม + เพื่อเพิ่มงานใหม่', 
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  /// สร้าง tile สำหรับแต่ละงาน
  Widget _buildTaskTile(TaskModel task, String projectHdId, List<TaskStatusModel> taskStatusList) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 4, 
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        title: Text(
          task.name ?? '-', 
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        subtitle: Text(
          task.description ?? '', 
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        leading: const Icon(
          Icons.check_box, 
          color: Color.fromARGB(255, 77, 100, 231), 
          size: 20,
        ),
        onTap: () => _navigateToCommentScreen(task),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTaskStatusDropdown(task, projectHdId, taskStatusList),
            const SizedBox(width: 8),
            _buildAssigneeInfo(task),
            const SizedBox(width: 8),
            _buildTaskPopupMenu(task, projectHdId),
          ],
        ),
      ),
    );
  }

  /// แสดงข้อมูลผู้รับผิดชอบ
  Widget _buildAssigneeInfo(TaskModel task) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ชื่อของผู้รับผิดชอบ หรือ "-"
        Text(
          task.assignedTo?.name ?? '-', 
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
        ),
        const SizedBox(width: 4),
        // รูปโปรไฟล์ หรือไอคอนคนถ้าไม่มีรูป
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.grey[300],
          backgroundImage: (task.assignedTo?.image != null && task.assignedTo!.image!.isNotEmpty) 
            ? NetworkImage(task.assignedTo!.image!) 
            : null,
          child: (task.assignedTo?.image == null || task.assignedTo!.image!.isEmpty) 
            ? const Icon(Icons.person, size: 16, color: Colors.black) 
            : null,
        ),
      ],
    );
  }

  /// Navigate ไปยังหน้า Comment
  void _navigateToCommentScreen(TaskModel task) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => CommentScreen(task: task)),
    );
  }

  /// Dropdown สำหรับเปลี่ยนสถานะของ task
  Widget _buildTaskStatusDropdown(TaskModel task, String projectHdId, List<TaskStatusModel> taskStatusList) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200], 
        borderRadius: BorderRadius.circular(4), 
        border: Border.all(color: Colors.grey),
      ),
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
          onChanged: (newValue) => _updateTaskStatus(task, newValue, projectHdId, taskStatusList),
        ),
      ),
    );
  }

  /// อัปเดตสถานะของ Task
  Future<void> _updateTaskStatus(
    TaskModel task, 
    String? newValue, 
    String projectHdId, 
    List<TaskStatusModel> taskStatusList,
  ) async {
    if (newValue == null) return;
    
    try {
      // หาสถานะที่เลือก
      final selectedStatus = taskStatusList.firstWhere(
        (status) => status.name?.toUpperCase() == newValue, 
        orElse: () => taskStatusList.isNotEmpty ? taskStatusList.first : TaskStatusModel(),
      );

      // สร้าง Task ที่อัปเดตแล้ว
      final updatedTask = task.copyWith(
        taskStatus: TaskStatusModel(
          id: selectedStatus.id, 
          name: selectedStatus.name,
        ),
      );

      // ส่งข้อมูลไปยัง API
      await ref.read(insertOrUpdateTaskControllerProvider.notifier).submit(
        body: _mapTaskToApi(updatedTask),
      );
      
      // รีเฟรช data
      ref.invalidate(taskBySprintControllerProvider(projectHdId));
      await ref.read(taskBySprintControllerProvider(projectHdId).notifier).fetch();
      
    } catch (e) {
      // แสดง error message
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('อัปเดตสถานะล้มเหลว: ${e.toString()}'), 
          backgroundColor: Colors.red,
        ),
      );
    }
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
  Widget _buildTaskPopupMenu(TaskModel task, String projectHdId) {
    return SizedBox(
      width: 48,
      height: 48,
      child: PopupMenuButton<String>(
        tooltip: 'ตัวเลือกเพิ่มเติม',
        onSelected: (value) => _handleTaskMenuAction(value, task, projectHdId),
        itemBuilder: (context) => const [
          PopupMenuItem(
            value: 'comment', 
            child: ListTile(
              leading: Icon(Icons.comment), 
              title: Text('ดูความคิดเห็น'),
            ),
          ),
          PopupMenuItem(
            value: 'edit', 
            child: ListTile(
              leading: Icon(Icons.edit), 
              title: Text('แก้ไขงาน'),
            ),
          ),
        PopupMenuItem(
          value: 'delete', 
          child: ListTile(
            leading: Icon(Icons.delete_outline), 
            title: Text('ลบงาน'),
          ),
        ),
      ],
      ),
    );
  }

  /// จัดการ action ของเมนู Task
  Future<void> _handleTaskMenuAction(String action, TaskModel task, String projectHdId) async {
    switch (action) {
      case 'comment':
        _navigateToCommentScreen(task);
        break;
      case 'edit':
        await _navigateToEditTask(task, projectHdId);
        break;
      case 'delete':
        await _deleteTask(task);
        break;
    }
  }

  /// Navigate ไปยังหน้าแก้ไข Task
  Future<void> _navigateToEditTask(TaskModel task, String projectHdId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(
          projectHdId: projectHdId, 
          sprintId: widget.item?.id, 
          task: task,
        ),
      ),
    );
    
    if (result == true) {
      _loadTasks();
    }
  }

  /// ปุ่มสำหรับสร้างงานใหม่
  Widget _buildCreateButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: _handleCreateTask,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.add, 
                size: 18, 
                color: _isHovering ? Colors.blue[700] : Colors.grey[700],
              ),
              const SizedBox(width: 4),
              Text(
                'Create', 
                style: TextStyle(
                  color: _isHovering ? Colors.blue[700] : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// จัดการการสร้าง Task ใหม่
  Future<void> _handleCreateTask() async {
    final projectHDId = ref.read(selectProjectIdProvider);
    
    if (projectHDId == null) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('โปรดเลือกโปรเจกต์ก่อน')),
      );
      return;
    }

    final result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(
          projectHdId: projectHDId, 
          sprintId: widget.item?.id,
        ),
      ),
    );
    
    if (result == true && mounted) {
      _loadTasks();
    }
  }

  /// ฟังก์ชันสำหรับลบ Task พร้อม dialog ยืนยัน
  Future<void> _deleteTask(TaskModel task) async {
    final confirm = await _showDeleteConfirmDialog(task);

    if (confirm == true && mounted) {
      await _performDeleteTask(task);
    }
  }

  /// แสดง Dialog ยืนยันการลบ
  Future<bool?> _showDeleteConfirmDialog(TaskModel task) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
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
  }

  /// ดำเนินการลบ Task
  Future<void> _performDeleteTask(TaskModel task) async {
    try {
      // แสดง loading snackbar
      _showLoadingSnackBar('กำลังลบงาน...');

      // ลบ Task
      await ref.read(deleteTaskControllerProvider.notifier).deleteTask(task.id ?? '');

      if (mounted) {
        // รีเฟรช data
        _loadTasks();
        
        // ซ่อน loading และแสดงความสำเร็จ
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _showSuccessSnackBar('ลบงาน "${task.name}" สำเร็จ');
      }
    } catch (e) {
      if (mounted) {
        // ซ่อน loading และแสดง error
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _showErrorSnackBar('เกิดข้อผิดพลาดในการลบงาน: ${e.toString()}');
      }
    }
  }

  /// แสดง Loading SnackBar
  void _showLoadingSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20, 
              height: 20, 
              child: CircularProgressIndicator(
                strokeWidth: 2, 
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// แสดง Success SnackBar
  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        backgroundColor: Colors.green, 
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// แสดง Error SnackBar
  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        backgroundColor: Colors.red, 
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// ส่วนแสดง counter และปุ่มจัดการ sprint
  Widget _buildCountersAndButton(int taskCount) {
    final isBacklog = widget.item?.id == '1';

    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // แสดง counter ของแต่ละสถานะ
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
          const SizedBox(width: 5),

          // ปุ่มสำหรับ Backlog
          if (isBacklog) _buildCreateSprintButton(),

          // ปุ่มสำหรับ Sprint ที่ยังไม่เริ่ม
          if (!isBacklog && widget.item?.startting == false) 
            _buildStartSprintButton(taskCount),

          // ปุ่มสำหรับ Sprint ที่เริ่มแล้วแต่ยังไม่เสร็จ
          if (!isBacklog && widget.item?.startting == true && widget.item?.completed == false)
            _buildCompleteSprintButton(),

          // เมนูเพิ่มเติมสำหรับ Sprint
          if (!isBacklog) _buildSprintMoreMenu(),
        ],
      ),
    );
  }

  /// ปุ่มสร้าง Sprint ใหม่
  Widget _buildCreateSprintButton() {
    return ElevatedButton(
      style: _getButtonStyle(),
      onPressed: _handleCreateSprint,
      child: const Text(
        'Create sprint', 
        style: TextStyle(color: Color.fromARGB(255, 91, 91, 91)),
      ),
    );
  }

  /// ปุ่มเริ่ม Sprint
  Widget _buildStartSprintButton(int taskCount) {
    return ElevatedButton(
      style: _getButtonStyle(),
      onPressed: () => _handleStartSprint(taskCount),
      child: const Text(
        'Start sprint', 
        style: TextStyle(color: Color.fromARGB(255, 91, 91, 91)),
      ),
    );
  }

  /// ปุ่มจบ Sprint
  Widget _buildCompleteSprintButton() {
    return ElevatedButton(
      style: _getButtonStyle(),
      onPressed: _handleCompleteSprint,
      child: const Text(
        'Complete sprint', 
        style: TextStyle(color: Color.fromARGB(255, 91, 91, 91)),
      ),
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
  Future<void> _handleCreateSprint() async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const InsertUpdateSprint()),
    );
    
    if (result == true) {
      await ref.read(sprintProvider.notifier).get();
      ref.invalidate(sprintProvider);
    }
  }

  /// จัดการการเริ่ม Sprint
  Future<void> _handleStartSprint(int taskCount) async {
    final item = widget.item;
    if (item == null) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('โปรดเลือก Sprint ก่อน')),
      );
      return;
    }

    // ตั้งค่าข้อมูลเริ่มต้น
    _sprintNameController.text = item.name ?? '';
    _sprintGoalController.text = item.goal ?? '';
    ref.read(formStartDateProvider.notifier).state = item.satartDate.formDateTimeJson;
    ref.read(formEndDateProvider.notifier).state = item.endDate.formDateTimeJson;

    // แสดง dialog สำหรับเริ่ม sprint
    if (mounted) {
      await _showStartSprintDialog(taskCount, item);
    }
  }

  /// จัดการการจบ Sprint
  Future<void> _handleCompleteSprint() async {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ฟีเจอร์นี้ยังไม่เปิดใช้งาน')),
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
            DateTime? startDate = ref.watch(formStartDateProvider);
            DateTime? endDate = ref.watch(formEndDateProvider);
            
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Start Sprint'),
              content: Form(
                key: formKey,
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$taskCount work items will be included in this sprint.'),
                    const Text('Required fields are marked with an asterisk *'),
                    const Gap(10),
                    const TitleWidget(text: 'Sprint name'),
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
                    const Gap(10),
                    const TitleWidget(text: 'Start date'),
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
                    const Gap(10),
                    const TitleWidget(text: 'End date'),
                    SizedBox(
                      width: 400,
                      child: FormEndDateWidget(
                        startDate: startDate,
                        endDate: endDate,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select end date';
                          }
                          return null;
                        },
                        onChanged: (date) => ref.read(formEndDateProvider.notifier).state = date,
                      ),
                    ),
                    const Text('Sprint goal'),
                    SizedBox(
                      width: 552,
                      child: TextFormField(
                        controller: _sprintGoalController,
                        minLines: 4,
                        maxLines: null,
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
                TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => _performStartSprint(formKey, item),
                  child: const Text('Start'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// ดำเนินการเริ่ม Sprint
  Future<void> _performStartSprint(GlobalKey<FormState> formKey, SprintModel item) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref.read(insertUpdateSprintProvider.notifier).startSprint(
        item.id!,
        _sprintGoalController.text.isEmpty ? null : _sprintGoalController.text,
        _sprintNameController.text.isEmpty ? item.name! : _sprintNameController.text,
      );
      
      if (!mounted) return;
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sprint started successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting sprint: ${e.toString()}')),
      );
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
        onSelected: _handleSprintMenuAction,
        itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'edit', 
          child: ListTile(
            leading: Icon(Icons.edit, size: 20, color: Colors.grey), 
            title: Text('edit sprint'),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete_outline, size: 20, color: Colors.grey), 
            title: Text('delete sprint'),
          ),
        ),
      ],
      ),
    );
  }

  /// จัดการ action ของเมนู Sprint
  Future<void> _handleSprintMenuAction(String value) async {
    switch (value) {
      case 'edit':
        await _handleEditSprint();
        break;
      case 'delete':
        await _handleDeleteSprint();
        break;
    }
  }

  /// จัดการการแก้ไข Sprint
  Future<void> _handleEditSprint() async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => InsertUpdateSprint(sprint: widget.item),
      ),
    );
    
    if (result == true) {
      await ref.read(sprintProvider.notifier).get();
      ref.invalidate(sprintProvider);
    }
  }

  /// จัดการการลบ Sprint
  Future<void> _handleDeleteSprint() async {
    final confirm = await _showDeleteSprintConfirmDialog();
    
    if (confirm == true && widget.item?.id != null) {
      try {
        await ref.read(sprintProvider.notifier).delete(widget.item!.id!);
        ref.invalidate(sprintProvider);
        await ref.read(sprintProvider.notifier).get();
        
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ลบ Sprint สำเร็จ')),
        );
      } catch (e) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: ${e.toString()}')),
        );
      }
    }
  }

  /// แสดง Dialog ยืนยันการลบ Sprint
  Future<bool?> _showDeleteSprintConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบ Sprint "${widget.item!.name}" ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ลบ'),
          ),
        ],
      ),
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
        children: const [
          TextSpan(
            text: ' *', 
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
