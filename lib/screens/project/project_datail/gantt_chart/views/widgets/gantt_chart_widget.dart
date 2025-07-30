import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/utils/extension/context_extension.dart';
import 'package:project/utils/extension/date.dart';
import '../../models/gantt_models.dart';
import '../../utils/date_helpers.dart';
import '../../providers/gantt_data_provider.dart';

class GanttChartWidget extends ConsumerStatefulWidget {
  const GanttChartWidget({super.key});

  @override
  ConsumerState<GanttChartWidget> createState() => _GanttChartWidgetState();
}

class _GanttChartWidgetState extends ConsumerState<GanttChartWidget> {
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
    _sidebarVerticalController = ScrollController();
    _taskVerticalController = ScrollController();
    _headerHorizontalController = ScrollController();
    _taskHorizontalController = ScrollController();

    // Sync แนวตั้ง
    _sidebarVerticalController.addListener(() {
      if (_isSyncingVertical) return;
      _isSyncingVertical = true;
      _taskVerticalController.jumpTo(_sidebarVerticalController.position.pixels);
      _isSyncingVertical = false;
    });
    _taskVerticalController.addListener(() {
      if (_isSyncingVertical) return;
      _isSyncingVertical = true;
      _sidebarVerticalController.jumpTo(_taskVerticalController.position.pixels);
      _isSyncingVertical = false;
    });

    // Sync แนวนอน
    _headerHorizontalController.addListener(() {
      if (_isSyncingHorizontal) return;
      _isSyncingHorizontal = true;
      _taskHorizontalController.jumpTo(_headerHorizontalController.position.pixels);
      _isSyncingHorizontal = false;
    });
    _taskHorizontalController.addListener(() {
      if (_isSyncingHorizontal) return;
      _isSyncingHorizontal = true;
      _headerHorizontalController.jumpTo(_taskHorizontalController.position.pixels);
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
    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
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

    return monthMap.entries.map((entry) => MonthInfo(name: entry.key, dayCount: entry.value)).toList();
  }

  List<ProcessedSprint> _processedSprints(List<Sprint> sprints, List<Task> tasks) {
    return sprints.map((sprint) {
      final sprintTasks = tasks.where((t) => t.sprintId == sprint.id).toList()..sort((a, b) => a.start.compareTo(b.start));
      final tasksWithLayout = sprintTasks.asMap().entries.map((entry) => TaskWithLayout(task: entry.value, rowIndex: entry.key)).toList();
      final rowCount = sprintTasks.length;
      final sprintRowHeight = sprintRowHeaderHeight + (rowCount * taskRowHeight);
      return ProcessedSprint(sprint: sprint, tasksWithLayout: tasksWithLayout, rowCount: rowCount, sprintRowHeight: sprintRowHeight);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ganttData = ref.watch(ganttDataProvider);
    final sprints = ganttData.sprints;
    final tasks = ganttData.tasks;

    if (sprints.isEmpty && tasks.isEmpty) {
      return const Center(child: Text('No data available. Add some sprints and tasks to get started.', style: TextStyle(color: Colors.white70)));
    }

    final allDates = [...tasks.map((t) => t.start), ...tasks.map((t) => t.end), ...sprints.map((s) => s.start), ...sprints.map((s) => s.end)];

    final DateTime chartStartDate, chartEndDate;
    if (allDates.isEmpty) {
      final today = DateHelpers.startOfToday();
      chartStartDate = DateHelpers.addDays(today, -15);
      chartEndDate = DateHelpers.addDays(today, 30);
    } else {
      final minDate = allDates.reduce((a, b) => a.isBefore(b) ? a : b);
      final maxDate = allDates.reduce((a, b) => a.isAfter(b) ? a : b);
      chartStartDate = DateHelpers.addDays(minDate, -15);
      chartEndDate = DateHelpers.addDays(maxDate, 15);
    }

    final dateRange = _getDateRange(chartStartDate, chartEndDate);
    final months = _getMonths(dateRange);
    final processedSprints = _processedSprints(sprints, tasks);

    final today = DateHelpers.startOfToday();
    final todayPosition = DateHelpers.differenceInDays(today, chartStartDate) * dayWidth;
    return Column(
      children: [
        _buildHeader(months, dateRange),
        Expanded(
          child: Row(
            children: [
              _buildSidebar(processedSprints),
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
                            itemCount: processedSprints.length,
                            itemBuilder: (context, index) {
                              final sprint = processedSprints[index];
                              return Container(
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.primaryColor.withValues(alpha: 0.1)))),
                                height: sprint.sprintRowHeight + 1,
                                child: Stack(
                                  children: [
                                    // Task bars
                                    ...sprint.tasksWithLayout.map((taskLayout) {
                                      final task = taskLayout.task;
                                      final start = DateTime(task.start.year, task.start.month, task.start.day);
                                      final end = DateTime(task.end.year, task.end.month, task.end.day);
                                      final offset = DateHelpers.differenceInDays(start, chartStartDate);
                                      final duration = DateHelpers.differenceInDays(end, start) + 1;
                                      final left = offset * dayWidth;
                                      final width = duration * dayWidth;
                                      final top = sprintRowHeaderHeight + taskLayout.rowIndex * taskRowHeight;
                                      return Positioned(
                                        left: left,
                                        top: top,
                                        width: width,
                                        height: taskRowHeight,
                                        child: Container(
                                          decoration: BoxDecoration(color: context.primaryColor.withValues(alpha: 0.8)),
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            "${task.start.toFormattedString} - ${task.end.toFormattedString} (${task.durationDays})",
                                            style: const TextStyle(fontSize: 12, color: Colors.white60),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }),
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
                            height: processedSprints.fold<double>(0, (sum, sprint) => sum + sprint.sprintRowHeight),
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
                right: BorderSide(color: context.primaryColor.withValues(alpha: 0.1)),
                bottom: BorderSide(color: context.primaryColor.withValues(alpha: 0.1)),
              ),
            ),
            child: const Center(child: Text('Sprints', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ),
          // Header for the gantt chart
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.05),
                border: Border(bottom: BorderSide(color: context.primaryColor.withValues(alpha: 0.1))),
              ),
              child: Scrollbar(
                controller: _headerHorizontalController,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(), // ไม่เกิด overscroll/สกอเตลิด
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
                                    decoration: BoxDecoration(border: Border(right: BorderSide(color: context.primaryColor.withValues(alpha: 0.1)))),
                                    child: Center(child: Text(month.name, style: TextStyle(color: context.primaryColor))),
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
                                    decoration: BoxDecoration(border: Border(right: BorderSide(color: context.primaryColor.withValues(alpha: 0.1)))),
                                    child: Center(child: Text(DateHelpers.format(date, 'd'), style: const TextStyle(color: Colors.black45))),
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

  Widget _buildSidebar(List<ProcessedSprint> processedSprints) {
    return Container(
      width: sprintSidebarWidth,
      decoration: BoxDecoration(border: Border(right: BorderSide(color: context.primaryColor.withValues(alpha: 0.1)))),
      child: Scrollbar(
        controller: _sidebarVerticalController,
        child: ListView.builder(
          physics: const ClampingScrollPhysics(), // ไม่เกิด overscroll/สกอเตลิด
          controller: _sidebarVerticalController,
          itemCount: processedSprints.length,
          itemBuilder: (context, index) {
            final processedSprint = processedSprints[index];
            return Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.primaryColor.withValues(alpha: 0.1)))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [context.primaryColor.withValues(alpha: 0.05), context.primaryColor.withValues(alpha: 0.01)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    height: sprintRowHeaderHeight,
                    padding: const EdgeInsets.only(left: 2, right: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        processedSprint.sprint.name,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: context.primaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: processedSprint.rowCount,
                    itemBuilder: (context, indexitem) {
                      final taskWithLayout = processedSprint.tasksWithLayout[indexitem];
                      return Container(
                        height: taskRowHeight,
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Tooltip(
                            message:
                                "${taskWithLayout.task.name} \n${taskWithLayout.task.start.toFormattedString} - ${taskWithLayout.task.end.toFormattedString}\n${taskWithLayout.task.durationDays} days",
                            child: Text(taskWithLayout.task.name, style: const TextStyle(color: Colors.black54), overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
