//gantt_chart_widget.dart
import 'package:project/controllers/assignee_controller.dart';
import 'package:project/controllers/priority_controller.dart';
import 'package:project/controllers/task_status_controller.dart';
import 'package:project/controllers/type_of_work_controller.dart';
import 'package:project/screens/auth/providers/controllers/auth_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/sprint_in_borad_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/insert_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/utils/extension/context_extension.dart';
import 'package:project/utils/extension/custom_snackbar.dart';
import 'package:project/utils/extension/hex_color.dart';
import '../../models/gantt_models.dart';
import '../../providers/controllers/gantt_data_controller.dart';
import '../../utils/date_helpers.dart';
import 'package:project/screens/project/project_datail/views/widgets/task_comment_detail.dart';
import 'package:smart_date_field_picker/smart_date_field_picker.dart';
// ...existing code...

class GanttChartWidget extends ConsumerStatefulWidget {
  final String projectId;
  final List<SprintModel> ganttData;
  final bool readOnly;
  const GanttChartWidget(
    this.ganttData, {
    required this.projectId,
    this.readOnly = false,
    super.key,
  });

  @override
  ConsumerState<GanttChartWidget> createState() => _GanttChartWidgetState();
}

class _GanttChartWidgetState extends ConsumerState<GanttChartWidget> {
  // Slide panel แสดงรายละเอียด Task แบบเดียวกับ CommentTaskScreen
  void _showTaskDetailPanel(String taskId, {bool readOnly = false}) {
    showGeneralDialog(
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
              width: 450,
              height: double.infinity,
              child: TaskCommentDetail(
                taskId: taskId,
                readOnly: readOnly,
                onTaskUpdated: () async {
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

  Future<void> _showAddTaskDialog(String sprintId) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;
    final startDateController = OverlayPortalController();
    final endDateController = OverlayPortalController();

    // 👤 ดึง user id ที่ login อยู่
    final currentUserId = ref.read(loginProvider).value?.user?.id.toString();

    // state เก็บ assignee ที่เลือก
    String? selectedAssigneeId = currentUserId;

    // โหลด list assignee
    final assigneeList = ref.read(listAssignProvider).value ?? [];

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 28,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'เพิ่มงานใหม่',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 🔤 Task Name
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'ชื่อ Task *',
                          border: OutlineInputBorder(),
                        ),
                        autofocus: true,
                      ),
                      const SizedBox(height: 16),

                      // 👤 Dropdown เลือก Assignee
                      DropdownButtonFormField<String>(
                        value: selectedAssigneeId,
                        decoration: const InputDecoration(
                          labelText: 'Assignee',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            assigneeList.map<DropdownMenuItem<String>>((user) {
                              return DropdownMenuItem<String>(
                                value: user.id.toString(),
                                child: Text(user.name ?? ''),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedAssigneeId = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // 📅 Start & End Date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Date',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              SmartDateFieldPicker(
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    left: 12,
                                    right: 40,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                initialDate: startDate,
                                controller: startDateController,
                                onDateSelected: (date) {
                                  setStateDialog(() {
                                    startDate = date;
                                    if (endDate != null &&
                                        startDate != null &&
                                        endDate!.isBefore(startDate!)) {
                                      endDate = null;
                                    }
                                  });
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Text(
                            'End Date',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              SmartDateFieldPicker(
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    left: 12,
                                    right: 40,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                initialDate: endDate,
                                controller: endDateController,
                                enabled: startDate != null,
                                firstDate: startDate?.add(
                                  const Duration(days: 1),
                                ),
                                onDateSelected: (date) {
                                  setStateDialog(() {
                                    endDate = date;
                                  });
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 📝 Description
                      TextField(
                        controller: descController,
                        decoration: const InputDecoration(
                          labelText: 'รายละเอียดงาน',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),

                      // ✅ Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0071BC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              if (nameController.text.trim().isEmpty) {
                                if (mounted) {
                                  CustomSnackbar.showSnackBar(
                                    context: context,
                                    title: "แจ้งเตือน",
                                    message: "กรุณากรอกชื่องาน",
                                    contentType: ContentType.warning,
                                    color: Colors.orange,
                                  );
                                }
                                return;
                              }

                              if (startDate == null) {
                                if (mounted) {
                                  CustomSnackbar.showSnackBar(
                                    context: context,
                                    title: "แจ้งเตือน",
                                    message: "กรุณาเลือกวันที่เริ่ม",
                                    contentType: ContentType.warning,
                                    color: Colors.orange,
                                  );
                                }
                                return;
                              }

                              if (endDate == null) {
                                if (mounted) {
                                  CustomSnackbar.showSnackBar(
                                    context: context,
                                    title: "แจ้งเตือน",
                                    message: "กรุณาเลือกวันที่สิ้นสุด",
                                    contentType: ContentType.warning,
                                    color: Colors.orange,
                                  );
                                }
                                return;
                              }

                              Navigator.of(context).pop(true);
                            },

                            child: const Text(
                              'Start',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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
      },
    );

    // 📤 ส่งข้อมูลถ้ากด Save
    if (result == true) {
      final body = {
        "task_id": "0",
        "project_hd_id": widget.projectId,
        "sprint_id": sprintId,
        "master_priority_id": "1",
        "master_task_status_id": "1",
        "master_type_of_work_id": "1",
        "task_name": nameController.text.trim(),
        "task_description": descController.text.trim(),
        "task_assigned_to":
            selectedAssigneeId ?? currentUserId, // ✅ default เป็น login id
        "task_start_date": DateHelpers.format(startDate!, 'yyyy-MM-dd'),
        "task_end_date": DateHelpers.format(endDate!, 'yyyy-MM-dd'),
        "task_is_active": true,
      };

      print('[GanttChartWidget] Submit body: $body');
      await ref
          .read(insertOrUpdateTaskControllerProvider.notifier)
          .submit(body: body);

      final state = ref.read(insertOrUpdateTaskControllerProvider);
      if (mounted) {
        if (state.hasError) {
          CustomSnackbar.showSnackBar(
            context: context,
            title: "เกิดข้อผิดพลาด",
            message: "${state.error}",
            contentType: ContentType.failure,
            color: Colors.red,
          );
        } else {
          CustomSnackbar.showSnackBar(
            context: context,
            title: "สำเร็จ",
            message: "เพิ่มงานสำเร็จ",
            contentType: ContentType.success,
            color: Colors.green,
          );
        }
      }
      await _loadTasks();
    }
  }

  Future<void> _loadTasks() async {
    ref.invalidate(ganttDataProvider);
    await ref.read(ganttDataProvider.notifier).get();
    setState(() {});
  }

  static const double dayWidth = 35.0;
  static const double sprintRowHeaderHeight = 30.0;
  static const double taskRowHeight = 20.0;
  static const double sprintSidebarWidth = 300.0;
  late ScrollController _sidebarVerticalController;
  late ScrollController _taskVerticalController;
  late ScrollController _headerHorizontalController;
  late ScrollController _taskHorizontalController;
  bool _isSyncingVertical = false;
  bool _isSyncingHorizontal = false;
  @override
  void initState() {
    super.initState();
    // Prefetch dropdown providers for use in dialogs
    Future.microtask(() {
      ref.read(listAssignProvider.notifier).get();
      ref.read(listPriorityProvider.notifier).get();
      ref.read(listTypeOfWorkProvider.notifier).get();
      ref.read(listTaskStatusProvider.notifier).get();
      final container = ProviderScope.containerOf(context, listen: false);
      container
          .read(sprintStartedControllerProvider(widget.projectId).notifier)
          .fetch();
    });

    _sidebarVerticalController = ScrollController();
    _taskVerticalController = ScrollController();
    _headerHorizontalController = ScrollController();
    _taskHorizontalController = ScrollController();

    // Sync แนวตั้ง
    _sidebarVerticalController.addListener(() {
      if (_isSyncingVertical) return;
      _isSyncingVertical = true;
      _taskVerticalController.jumpTo(
        _sidebarVerticalController.position.pixels,
      );
      _isSyncingVertical = false;
    });
    _taskVerticalController.addListener(() {
      if (_isSyncingVertical) return;
      _isSyncingVertical = true;
      _sidebarVerticalController.jumpTo(
        _taskVerticalController.position.pixels,
      );
      _isSyncingVertical = false;
    });

    // Sync แนวนอน
    _headerHorizontalController.addListener(() {
      if (_isSyncingHorizontal) return;
      _isSyncingHorizontal = true;
      _taskHorizontalController.jumpTo(
        _headerHorizontalController.position.pixels,
      );
      _isSyncingHorizontal = false;
    });
    _taskHorizontalController.addListener(() {
      if (_isSyncingHorizontal) return;
      _isSyncingHorizontal = true;
      _headerHorizontalController.jumpTo(
        _taskHorizontalController.position.pixels,
      );
      _isSyncingHorizontal = false;
    });
  }

  @override
  void dispose() {
    _sidebarVerticalController.dispose();
    _taskVerticalController.dispose();
    _headerHorizontalController.dispose();
    _taskHorizontalController.dispose();
    super.dispose();
  }

  List<DateTime> _getDateRange(DateTime startDate, DateTime endDate) {
    final range = <DateTime>[];
    var currentDate = startDate;
    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      range.add(currentDate);
      currentDate = DateHelpers.addDays(currentDate, 1);
    }
    return range;
  }

  List<MonthInfo> _getMonths(List<DateTime> dateRange) {
    if (dateRange.isEmpty) return [];

    final monthMap = <String, int>{};
    for (final date in dateRange) {
      final monthKey = DateHelpers.format(date, 'MMM yyyy');
      monthMap[monthKey] = (monthMap[monthKey] ?? 0) + 1;
    }

    return monthMap.entries
        .map((entry) => MonthInfo(name: entry.key, dayCount: entry.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ganttData = [...widget.ganttData]..sort((a, b) {
      final aHasTasks = a.tasks.isNotEmpty;
      final bHasTasks = b.tasks.isNotEmpty;
      if (aHasTasks == bHasTasks)
        return 0; // ถ้ามี/ไม่มี เท่ากัน ให้คงลำดับเดิม
      return aHasTasks ? -1 : 1; // Sprint ที่มี Task ขึ้นก่อน
    });

    // รวมทุก task ทุกสถานะ (รวม complete) ในแต่ละ sprint
    List<DateTime> allDates = [
      ...ganttData.expand(
        (sprint) => sprint.tasks
        // ไม่ filter สถานะ
        .map(
          (task) =>
              DateTime.parse(task.taskStartDate ?? DateTime.now().toString()),
        ),
      ),
      ...ganttData.expand(
        (sprint) => sprint.tasks.map(
          (task) =>
              DateTime.parse(task.taskEndDate ?? DateTime.now().toString()),
        ),
      ),
    ];

    final DateTime chartStartDate, chartEndDate;
    if (allDates.isEmpty) {
      final today = DateHelpers.startOfToday();
      chartStartDate = DateHelpers.addDays(today, -15);
      chartEndDate = DateHelpers.addDays(today, 30);
    } else {
      final minDate = allDates.reduce((a, b) => a.isBefore(b) ? a : b);
      final maxDate = allDates.reduce((a, b) => a.isAfter(b) ? a : b);
      chartStartDate = DateHelpers.addDays(minDate, -3);
      chartEndDate = DateHelpers.addDays(maxDate, 45);
    }

    final dateRange = _getDateRange(chartStartDate, chartEndDate);
    final months = _getMonths(dateRange);
    final today = DateHelpers.startOfToday();
    final todayPosition =
        DateHelpers.differenceInDays(today, chartStartDate) * dayWidth;
    return Column(
      children: [
        _buildHeader(months, dateRange),
        Expanded(
          child: Row(
            children: [
              _buildSidebar(ganttData),
              // show gantt chart tasks
              Expanded(
                child: Scrollbar(
                  controller: _taskHorizontalController,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: _taskHorizontalController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: dateRange.length * dayWidth,
                      child: Stack(
                        children: [
                          // Timeline ทั้งหมด
                          ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            controller: _taskVerticalController,
                            itemCount: ganttData.length,
                            itemBuilder: (context, index) {
                              final sprint = ganttData[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: context.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                ),
                                height:
                                    (sprintRowHeaderHeight +
                                        (sprint.tasks.length * taskRowHeight)) +
                                    1,
                                child: Stack(
                                  children: [
                                    // Task bars
                                    ...sprint.tasks.map((task) {
                                      if (task.taskStartDate == null ||
                                          task.taskEndDate == null) {
                                        return const SizedBox.shrink();
                                      }
                                      // ไม่ filter สถานะ task ใด ๆ
                                      final start = DateTime.parse(
                                        task.taskStartDate!.toString(),
                                      );
                                      final end = DateTime.parse(
                                        task.taskEndDate!.toString(),
                                      );
                                      final offset =
                                          DateHelpers.differenceInDays(
                                            start,
                                            chartStartDate,
                                          );
                                      final duration =
                                          DateHelpers.differenceInDays(
                                            end,
                                            start,
                                          ) +
                                          1;
                                      final left = offset * dayWidth;
                                      final width = duration * dayWidth;
                                      final rowIndex = sprint.tasks.indexOf(
                                        task,
                                      );
                                      final top =
                                          sprintRowHeaderHeight +
                                          rowIndex * taskRowHeight;
                                      return Positioned(
                                        left: left,
                                        top: top,
                                        width: width,
                                        height: taskRowHeight,
                                        child: GestureDetector(
                                          onTap: () {
                                            final isCompleted =
                                                sprint.completed == true;

                                            _showTaskDetailPanel(
                                              task.id?.toString() ?? '',
                                              // ✅ ถ้า completed = true → readOnly = true
                                              readOnly: isCompleted,
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: HexColor.fromHex(
                                                task.taskStatus!.color!,
                                              ),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              "${task.taskStartDate} - ${task.taskEndDate}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white60,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                    // Slide panel แสดงรายละเอียด Task แบบเดียวกับ CommentTaskScreen
                                  ],
                                ),
                              );
                            },
                          ),
                          // เส้นแดงวันนี้ (วาดครั้งเดียว)
                          Positioned(
                            left: todayPosition,
                            top: 0,
                            width: 1,
                            height: ganttData.fold<double>(
                              0,
                              (sum, sprint) =>
                                  sum +
                                  (sprintRowHeaderHeight +
                                      (sprint.tasks.length * taskRowHeight)),
                            ),
                            child: Container(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(List<MonthInfo> months, List<DateTime> dateRange) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 70,
            width: sprintSidebarWidth,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.05),
              border: Border(
                right: BorderSide(
                  color: context.primaryColor.withValues(alpha: 0.1),
                ),
                bottom: BorderSide(
                  color: context.primaryColor.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: const Center(
              child: Text(
                'Sprints',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Header for the gantt chart
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.05),
                border: Border(
                  bottom: BorderSide(
                    color: context.primaryColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Scrollbar(
                controller: _headerHorizontalController,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(
                  physics:
                      const ClampingScrollPhysics(), // ไม่เกิด overscroll/สกอเตลิด
                  controller: _headerHorizontalController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: dateRange.length * dayWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 40,
                          child: Row(
                            children:
                                months.map((month) {
                                  return Container(
                                    width: month.dayCount * dayWidth,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: context.primaryColor
                                              .withValues(alpha: 0.1),
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        month.name,
                                        style: TextStyle(
                                          color: context.primaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children:
                                dateRange.map((date) {
                                  return Container(
                                    width: dayWidth,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: context.primaryColor
                                              .withValues(alpha: 0.1),
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        DateHelpers.format(date, 'd'),
                                        style: const TextStyle(
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(List<SprintModel> sprints) {
    return Container(
      width: sprintSidebarWidth,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: context.primaryColor.withValues(alpha: 0.1)),
        ),
      ),
      child: Scrollbar(
        controller: _sidebarVerticalController,
        child: ListView.builder(
          controller: _sidebarVerticalController,
          itemCount: sprints.length,
          itemBuilder: (context, sprintIndex) {
            final processedSprint = sprints[sprintIndex];
            print(
              "${processedSprint.name}สถานะเสร็จ ${processedSprint.completed}",
            );
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.primaryColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Sprint Header Row
                  Container(
                    height: sprintRowHeaderHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            processedSprint.name ?? 'N/A',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: context.primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // 🔹 เงื่อนไขปุ่ม Add Task
                        Consumer(
                          builder: (context, ref, _) {
                            final isCompleted =
                                processedSprint.completed == true;

                            // ❌ Sprint จบแล้ว → ไม่โชว์ปุ่ม
                            if (isCompleted) {
                              return const SizedBox.shrink();
                            }

                            // ✅ Sprint เริ่มแล้ว หรือ ยังไม่ start → โชว์ปุ่ม
                            return IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.green,
                                size: 20,
                              ),
                              tooltip: 'เพิ่มงาน',
                              onPressed:
                                  () => _showAddTaskDialog(
                                    processedSprint.id ?? '',
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // 🔹 Task Rows
                  ...processedSprint.tasks.map((taskWithLayout) {
                    return Consumer(
                      builder: (context, ref, _) {
                        final startedList =
                            ref
                                .watch(
                                  sprintStartedControllerProvider(
                                    widget.projectId,
                                  ),
                                )
                                .value ??
                            [];

                        final isCompleted = processedSprint.completed == true;

                        return GestureDetector(
                          onTap: () {
                            _showTaskDetailPanel(
                              taskWithLayout.id?.toString() ?? '',
                              // ✅ ถ้า Sprint complete → readOnly เสมอ
                              readOnly: isCompleted,
                            );
                          },
                          child: Container(
                            height: taskRowHeight,
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            alignment: Alignment.centerLeft,
                            child: Tooltip(
                              message:
                                  "${taskWithLayout.name}\n${taskWithLayout.taskStartDate} - ${taskWithLayout.taskEndDate}",
                              child: Text(
                                taskWithLayout.name ?? '',
                                style: const TextStyle(color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
