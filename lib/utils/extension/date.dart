import 'package:intl/intl.dart';

extension DateExtension on DateTime {

  // Date Only Properties
  
  /// Returns a formatted string of the date in 'dd/MMMM' format.
  String get toFormattedString {
    return DateFormat('d MMM','en_US').format(this);
  }

  /// Returns a formatted string of the date in 'yyyy-MM-dd' format.
  String toIsoString() {
    return "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }
}