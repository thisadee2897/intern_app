import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gantt_models.dart';
import '../utils/date_helpers.dart';

class GanttDataNotifier extends StateNotifier<GanttData> {
  GanttDataNotifier() : super(_initialData());

  static GanttData _initialData() {
    final today = DateHelpers.startOfToday();

    final initialSprints = [
      Sprint(id: 'sprint-1', name: 'Q3 Development', start: DateHelpers.addDays(today, -10), end: DateHelpers.addDays(today, 20)),
      Sprint(id: 'sprint-2', name: 'Q4 Planning', start: today, end: DateHelpers.addDays(today, 30)),
      Sprint(id: 'sprint-3', name: 'Q1 Launch Prep', start: DateHelpers.addDays(today, 15), end: DateHelpers.addDays(today, 45)),
      Sprint(id: 'sprint-4', name: 'Q2 Review', start: DateHelpers.addDays(today, 40), end: DateHelpers.addDays(today, 70)),
      Sprint(id: 'sprint-5', name: 'Q3 Retrospective', start: DateHelpers.addDays(today, 65), end: DateHelpers.addDays(today, 95)),
      Sprint(id: 'sprint-6', name: 'Q4 Strategy', start: DateHelpers.addDays(today, 90), end: DateHelpers.addDays(today, 120)),
      Sprint(id: 'sprint-7', name: 'Q1 Kickoff', start: DateHelpers.addDays(today, 105), end: DateHelpers.addDays(today, 135)),
      Sprint(id: 'sprint-8', name: 'Q2 Planning', start: DateHelpers.addDays(today, 130), end: DateHelpers.addDays(today, 160)),
      Sprint(id: 'sprint-9', name: 'Q3 Development', start: DateHelpers.addDays(today, 155), end: DateHelpers.addDays(today, 185)),
      Sprint(id: 'sprint-10', name: 'Q4 Review', start: DateHelpers.addDays(today, 180), end: DateHelpers.addDays(today, 210)),
      Sprint(id: 'sprint-11', name: 'Q1 Retrospective', start: DateHelpers.addDays(today, 205), end: DateHelpers.addDays(today, 235)),
      Sprint(id: 'sprint-12', name: 'Q2 Strategy', start: DateHelpers.addDays(today, 230), end: DateHelpers.addDays(today, 260)),
      Sprint(id: 'sprint-13', name: 'Q3 Kickoff', start: DateHelpers.addDays(today, 255), end: DateHelpers.addDays(today, 285)),
      Sprint(id: 'sprint-14', name: 'Q4 Planning', start: DateHelpers.addDays(today, 280), end: DateHelpers.addDays(today, 310)),
      Sprint(id: 'sprint-15', name: 'Q1 Development', start: DateHelpers.addDays(today, 305), end: DateHelpers.addDays(today, 335)),
      Sprint(id: 'sprint-16', name: 'Q2 Review', start: DateHelpers.addDays(today, 330), end: DateHelpers.addDays(today, 360)),
      Sprint(id: 'sprint-17', name: 'Q3 Retrospective', start: DateHelpers.addDays(today, 355), end: DateHelpers.addDays(today, 385)),
      Sprint(id: 'sprint-18', name: 'Q4 Strategy', start: DateHelpers.addDays(today, 380), end: DateHelpers.addDays(today, 410)),
      Sprint(id: 'sprint-19', name: 'Q1 Kickoff', start: DateHelpers.addDays(today, 405), end: DateHelpers.addDays(today, 435)),
      Sprint(id: 'sprint-20', name: 'Q2 Planning', start: DateHelpers.addDays(today, 430), end: DateHelpers.addDays(today, 460)),
    ];

    final initialTasks = [
      Task(
        id: 'task-1',
        name: 'ทดสอบข้อความทั้งหมดรูปแบบที่ยาวมากเพื่อดูว่ามันจะตัดหรือไม่',
        sprintId: 'sprint-1',
        start: DateHelpers.addDays(today, -5),
        end: DateHelpers.addDays(today, 2),
        comments: [Comment(id: 'c-1', text: 'Initial setup complete.', createdAt: DateHelpers.addDays(today, -4))],
      ),
      Task(id: 'task-2', name: 'Design UI Mockups', sprintId: 'sprint-1', start: today, end: DateHelpers.addDays(today, 6), comments: []),
      Task(
        id: 'task-3',
        name: 'Develop Frontend Components',
        sprintId: 'sprint-1',
        start: DateHelpers.addDays(today, 3),
        end: DateHelpers.addDays(today, 12),
        comments: [],
      ),
      Task(id: 'task-4', name: 'Market Research', sprintId: 'sprint-2', start: DateHelpers.addDays(today, 1), end: DateHelpers.addDays(today, 8), comments: []),
      Task(id: 'task-5', name: 'Define Roadmap', sprintId: 'sprint-2', start: DateHelpers.addDays(today, 9), end: DateHelpers.addDays(today, 15), comments: []),
      Task(
        id: 'task-6',
        name: 'Finalize Launch Strategy',
        sprintId: 'sprint-3',
        start: DateHelpers.addDays(today, 16),
        end: DateHelpers.addDays(today, 22),
        comments: [],
      ),
      Task(
        id: 'task-7',
        name: 'Conduct User Testing',
        sprintId: 'sprint-3',
        start: DateHelpers.addDays(today, 23),
        end: DateHelpers.addDays(today, 30),
        comments: [],
      ),
      Task(
        id: 'task-8',
        name: 'Prepare Marketing Materials',
        sprintId: 'sprint-4',
        start: DateHelpers.addDays(today, 31),
        end: DateHelpers.addDays(today, 38),
        comments: [],
      ),
      Task(
        id: 'task-9',
        name: 'Launch Product',
        sprintId: 'sprint-5',
        start: DateHelpers.addDays(today, 39),
        end: DateHelpers.addDays(today, 46),
        comments: [],
      ),
      Task(
        id: 'task-10',
        name: 'Collect User Feedback',
        sprintId: 'sprint-6',
        start: DateHelpers.addDays(today, 47),
        end: DateHelpers.addDays(today, 54),
        comments: [],
      ),
      Task(
        id: 'task-11',
        name: 'Analyze Performance Metrics',
        sprintId: 'sprint-7',
        start: DateHelpers.addDays(today, 55),
        end: DateHelpers.addDays(today, 62),
        comments: [],
      ),
      Task(
        id: 'task-12',
        name: 'Plan Next Features',
        sprintId: 'sprint-8',
        start: DateHelpers.addDays(today, 63),
        end: DateHelpers.addDays(today, 70),
        comments: [],
      ),
      Task(
        id: '      task-13',
        name: 'Implement User Suggestions',
        sprintId: 'sprint-9',
        start: DateHelpers.addDays(today, 71),
        end: DateHelpers.addDays(today, 78),
        comments: [],
      ),
      Task(
        id: 'task-14',
        name: 'Prepare for Next Sprint',
        sprintId: 'sprint-10',
        start: DateHelpers.addDays(today, 79),
        end: DateHelpers.addDays(today, 86),
        comments: [],
      ),
      Task(
        id: 'task-15',
        name: 'Conduct Sprint Retrospective',
        sprintId: 'sprint-11',
        start: DateHelpers.addDays(today, 87),
        end: DateHelpers.addDays(today, 94),
        comments: [],
      ),
      Task(
        id: 'task-16',
        name: 'Update Documentation',
        sprintId: 'sprint-12',
        start: DateHelpers.addDays(today, 95),
        end: DateHelpers.addDays(today, 102),
        comments: [],
      ),
      Task(
        id: 'task-17',
        name: 'Plan Next Quarter',
        sprintId: 'sprint      -13',
        start: DateHelpers.addDays(today, 103),
        end: DateHelpers.addDays(today, 110),
        comments: [],
      ),
      Task(
        id: 'task-18',
        name: 'Conduct Team Training',
        sprintId: 'sprint-14',
        start: DateHelpers.addDays(today, 111),
        end: DateHelpers.addDays(today, 118),
        comments: [],
      ),
      Task(
        id: 'task-19',
        name: 'Review Sprint Goals',
        sprintId: 'sprint-15',
        start: DateHelpers.addDays(today, 119),
        end: DateHelpers.addDays(today, 126),
        comments: [],
      ),
      Task(
        id: 'task-20',
        name: 'Prepare for Next Sprint',
        sprintId: 'sprint-16',
        start: DateHelpers.addDays(today, 127),
        end: DateHelpers.addDays(today, 134),
        comments: [],
      ),
    ];

    return GanttData(sprints: initialSprints, tasks: initialTasks);
  }

  void addSprint(String name) {
    if (name.isNotEmpty) {
      final today = DateHelpers.startOfToday();
      final newSprint = Sprint(id: 'sprint-${DateTime.now().millisecondsSinceEpoch}', name: name, start: today, end: DateHelpers.addDays(today, 14));

      state = state.copyWith(sprints: [...state.sprints, newSprint]);
    }
  }

  void addTask(String name) {
    if (name.isNotEmpty && state.sprints.isNotEmpty) {
      final firstSprint = state.sprints.first;
      final newTask = Task(
        id: 'task-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        sprintId: firstSprint.id,
        start: firstSprint.start,
        end: DateHelpers.addDays(firstSprint.start, 7),
        comments: [],
      );

      state = state.copyWith(tasks: [...state.tasks, newTask]);
    }
  }

  void updateTask(String taskId, Task updatedTask) {
    final updatedTasks =
        state.tasks.map((task) {
          return task.id == taskId ? updatedTask : task;
        }).toList();

    state = state.copyWith(tasks: updatedTasks);
  }

  void updateSprint(String sprintId, Sprint updatedSprint) {
    final updatedSprints =
        state.sprints.map((sprint) {
          return sprint.id == sprintId ? updatedSprint : sprint;
        }).toList();

    state = state.copyWith(sprints: updatedSprints);
  }

  void addCommentToTask(String taskId, String commentText) {
    if (commentText.trim().isEmpty) return;

    final newComment = Comment(id: 'comment-${DateTime.now().millisecondsSinceEpoch}', text: commentText, createdAt: DateTime.now());

    final updatedTasks =
        state.tasks.map((task) {
          if (task.id == taskId) {
            return task.copyWith(comments: [...task.comments, newComment]);
          }
          return task;
        }).toList();

    state = state.copyWith(tasks: updatedTasks);
  }
}

class GanttData {
  final List<Sprint> sprints;
  final List<Task> tasks;

  GanttData({required this.sprints, required this.tasks});

  GanttData copyWith({List<Sprint>? sprints, List<Task>? tasks}) {
    return GanttData(sprints: sprints ?? this.sprints, tasks: tasks ?? this.tasks);
  }
}

final ganttDataProvider = StateNotifierProvider<GanttDataNotifier, GanttData>((ref) {
  return GanttDataNotifier();
});

extension GanttDateRangeExtension on GanttData {
  DateTimeRange get dateRange {
    final allDates = [...tasks.map((t) => t.start), ...tasks.map((t) => t.end), ...sprints.map((s) => s.start), ...sprints.map((s) => s.end)];

    if (allDates.isEmpty) {
      final today = DateHelpers.startOfToday();
      return DateTimeRange(start: DateHelpers.addDays(today, -15), end: DateHelpers.addDays(today, 30));
    }

    final minDate = allDates.reduce((a, b) => a.isBefore(b) ? a : b);
    final maxDate = allDates.reduce((a, b) => a.isAfter(b) ? a : b);

    return DateTimeRange(start: DateHelpers.addDays(minDate, -15), end: DateHelpers.addDays(maxDate, 15));
  }
}
