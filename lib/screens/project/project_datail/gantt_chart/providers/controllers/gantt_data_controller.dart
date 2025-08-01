import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/sprint_model.dart';
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
      List<DateTime> allDates =
          data.expand((sprint) => sprint.tasks!.map((task) => DateTime.parse(task.taskStartDate ?? (DateTime.now().toString())))).toList();
      DateTime minDate = allDates.reduce((a, b) => a.isBefore(b) ? a : b);
      DateTime maxDate = allDates.reduce((a, b) => a.isAfter(b) ? a : b);
      return DateTimeRange(start: minDate, end: maxDate);
    },
    loading: () => DateTimeRange(start: DateTime.now().add(Duration(days: -5)), end: DateTime.now().add(Duration(days: 30))),
    error: (_, __) => DateTimeRange(start: DateTime.now().add(Duration(days: -5)), end: DateTime.now().add(Duration(days: 30))),
  );
});
