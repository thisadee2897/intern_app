import 'package:intl/intl.dart';

class DateHelpers {
  static int differenceInDays(DateTime dateLeft, DateTime dateRight) {
    final left = DateTime(dateLeft.year, dateLeft.month, dateLeft.day);
    final right = DateTime(dateRight.year, dateRight.month, dateRight.day);
    return left.difference(right).inDays;
  }

  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  static String format(DateTime date, String formatStr) {
    switch (formatStr) {
      case 'MMM yyyy':
        return DateFormat('MMM yyyy').format(date);
      case 'MMMM yyyy':
        return DateFormat('MMMM yyyy').format(date);
      case 'MMM d':
        return DateFormat('MMM d').format(date);
      case 'MMMM':
        return DateFormat('MMMM').format(date);
      case 'd':
        return DateFormat('d').format(date);
      case 'yyyy-MM-dd':
        return DateFormat('yyyy-MM-dd').format(date);
      case 'yyyy-MM-dd HH:mm':
        return DateFormat('yyyy-MM-dd HH:mm').format(date);
      default:
        return DateFormat.yMd().format(date);
    }
  }

  static DateTime startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
