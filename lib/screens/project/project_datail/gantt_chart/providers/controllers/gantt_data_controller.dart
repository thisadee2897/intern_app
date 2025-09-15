import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/models/task_model.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import '../apis/gantt_data_api.dart';

class GanttDataNotifier extends StateNotifier<AsyncValue<List<SprintModel>?>> {
  GanttDataNotifier(this.ref) : super(const AsyncValue.loading());
  final Ref ref;

  Future<void> get() async {
    state = await AsyncValue.guard(() async {
      String projectId = ref.read(selectProjectIdProvider) ?? '0';
      try {
        List<SprintModel> response = await ref.read(apiGanttData).get(projectId: projectId);
        return response;
      } catch (e) {
        rethrow;
      }
    });
  }
}

final ganttDataProvider = StateNotifierProvider<GanttDataNotifier, AsyncValue<List<SprintModel>?>>((ref) => GanttDataNotifier(ref));
final minGanttDateProvider = Provider<DateTimeRange>((ref) {
  final ganttData = ref.watch(ganttDataProvider);
  return ganttData.when(
    data: (data) {
      if (data == null || data.isEmpty) {
        return DateTimeRange(start: DateTime.now(), end: DateTime.now());
      }
      List<DateTime> allDates = data.expand((sprint) => sprint.tasks.map((task) => DateTime.parse(task.taskStartDate ?? (DateTime.now().toString())))).toList();
      DateTime minDate = allDates.reduce((a, b) => a.isBefore(b) ? a : b);
      DateTime maxDate = allDates.reduce((a, b) => a.isAfter(b) ? a : b);
      return DateTimeRange(start: minDate, end: maxDate);
    },
    loading: () => DateTimeRange(start: DateTime.now().add(Duration(days: -5)), end: DateTime.now().add(Duration(days: 30))),
    error: (_, __) => DateTimeRange(start: DateTime.now().add(Duration(days: -5)), end: DateTime.now().add(Duration(days: 30))),
  );
});

// final showTextProvider = Provider.family<String, TaskModel>((ref, task) {
//   if (task.taskStartDate == null || task.taskEndDate == null) {
//     return '';
//   }

//   DateTime startDate = DateTime.parse(task.taskStartDate!);
//   DateTime endDate = DateTime.parse(task.taskEndDate!);

//   int startDay = startDate.day;
//   int endDay = endDate.day;

//   // กรณีวันเดียวกัน
//   if (startDay == endDay && startDate.month == endDate.month && startDate.year == endDate.year) {
//     return '$startDay';
//   }

//   // ถ้าวันห่างกัน <= 3 วัน
//   if (startDate.month == endDate.month && startDate.year == endDate.year && (endDay - startDay).abs() <= 2) {
//     return '$startDay - $endDay';
//   }

//   // ถ้าวันห่างกัน > 3 วัน และยังอยู่เดือนเดียวกัน
//   if (startDate.month == endDate.month && startDate.year == endDate.year && (endDay - startDay).abs() > 2) {
//     return '$startDay-$endDay ${DateFormat.MMM('en').format(startDate)}';
//   }

//   // ต่างเดือน แต่ปีเดียวกัน
//   if (startDate.year == endDate.year) {
//     return '${DateFormat('d MMM', 'en').format(startDate)} - ${DateFormat('d MMM', 'en').format(endDate)}';
//   }

//   // ต่างปี
//   return '${DateFormat('d MMM yyyy', 'en').format(startDate)} - ${DateFormat('d MMM yyyy', 'en').format(endDate)}';
// });




// final toolTipProvider = Provider.family<String, TaskModel>((ref, task) {
//   if (task.taskStartDate == null || task.taskEndDate == null) {
//     return '';
//   }

//   DateTime startDate = DateTime.parse(task.taskStartDate!);
//   DateTime endDate = DateTime.parse(task.taskEndDate!);

//   String formattedStart = DateFormat('d MMM yyyy', 'en').format(startDate);
//   String formattedEnd = DateFormat('d MMM yyyy', 'en').format(endDate);

//   return '${task.name} \n$formattedStart - $formattedEnd \nStatus: ${task.taskStatus?.name ?? 'Unknown'} \nAssignee: ${task.assignedTo?.name ?? 'Unassigned'}';
// });