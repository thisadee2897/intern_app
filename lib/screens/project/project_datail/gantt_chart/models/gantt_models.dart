class Comment {
  final String id;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  Comment copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Task {
  final String id;
  final String name;
  final String sprintId;
  final DateTime start;
  final DateTime end;
  final List<Comment> comments;

  Task({
    required this.id,
    required this.name,
    required this.sprintId,
    required this.start,
    required this.end,
    required this.comments,
  });

  Task copyWith({
    String? id,
    String? name,
    String? sprintId,
    DateTime? start,
    DateTime? end,
    List<Comment>? comments,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      sprintId: sprintId ?? this.sprintId,
      start: start ?? this.start,
      end: end ?? this.end,
      comments: comments ?? this.comments,
    );
  }

  int get durationDays => end.difference(start).inDays + 1;
}

class Sprint {
  final String id;
  final String name;
  final DateTime start;
  final DateTime end;

  Sprint({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
  });

  Sprint copyWith({
    String? id,
    String? name,
    DateTime? start,
    DateTime? end,
  }) {
    return Sprint(
      id: id ?? this.id,
      name: name ?? this.name,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  int get durationDays => end.difference(start).inDays + 1;
}

class ProcessedSprint {
  final Sprint sprint;
  final List<TaskWithLayout> tasksWithLayout;
  final int rowCount;
  final double sprintRowHeight;

  ProcessedSprint({
    required this.sprint,
    required this.tasksWithLayout,
    required this.rowCount,
    required this.sprintRowHeight,
  });
}

class TaskWithLayout {
  final Task task;
  final int rowIndex;

  TaskWithLayout({
    required this.task,
    required this.rowIndex,
  });
}

class MonthInfo {
  final String name;
  final int dayCount;

  MonthInfo({
    required this.name,
    required this.dayCount,
  });
}

class TaskGroup {
  final String name;
  final List<Task> tasks;

  TaskGroup({
    required this.name,
    required this.tasks,
  });

  TaskGroup copyWith({
    String? name,
    List<Task>? tasks,
  }) {
    return TaskGroup(
      name: name ?? this.name,
      tasks: tasks ?? this.tasks,
    );
  }
}
