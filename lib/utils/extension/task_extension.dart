import 'package:intl/intl.dart';
import 'package:project/models/task_model.dart';

extension TaskExtension on TaskModel {
  String get showText {
    if (taskStartDate == null || taskEndDate == null) return '';

    final startDate = DateTime.parse(taskStartDate!);
    final endDate = DateTime.parse(taskEndDate!);

    final startDay = startDate.day;
    final endDay = endDate.day;

    if (startDay == endDay &&
        startDate.month == endDate.month &&
        startDate.year == endDate.year) {
      return '$startDay';
    }

    if (startDate.month == endDate.month &&
        startDate.year == endDate.year &&
        (endDay - startDay).abs() <= 2) {
      return '$startDay - $endDay';
    }

    if (startDate.month == endDate.month &&
        startDate.year == endDate.year &&
        (endDay - startDay).abs() > 2) {
      return '$startDay-$endDay ${DateFormat.MMM('en').format(startDate)}';
    }

    if (startDate.year == endDate.year) {
      return '${DateFormat('d MMM', 'en').format(startDate)} - ${DateFormat('d MMM', 'en').format(endDate)}';
    }

    return '${DateFormat('d MMM yyyy', 'en').format(startDate)} - ${DateFormat('d MMM yyyy', 'en').format(endDate)}';
  }

  String get toolTip {
    if (taskStartDate == null || taskEndDate == null) return '';

    final startDate = DateTime.parse(taskStartDate!);
    final endDate = DateTime.parse(taskEndDate!);

    final formattedStart = DateFormat('d MMM yyyy', 'en').format(startDate);
    final formattedEnd = DateFormat('d MMM yyyy', 'en').format(endDate);

    return '${name ?? ''}\n$formattedStart - $formattedEnd\nStatus: ${taskStatus?.name ?? 'Unknown'}\nAssignee: ${assignedTo?.name ?? 'Unassigned'}';
  }
}
