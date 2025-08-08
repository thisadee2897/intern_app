import 'package:intl/intl.dart';

extension DateTimeFormApi on String? {
  String get dateTHFormApi {
    if (this == null || this == '') return '-';
    DateTime dateTimeFormLocal = DateTime.parse(this!).toLocal();
    //dateTimeFormLocal add 543 year
    DateTime dateTimeFormLocalAdd543 = DateTime(dateTimeFormLocal.year + 543, dateTimeFormLocal.month, dateTimeFormLocal.day);
    //dd/MM/yyyy format
    return DateFormat('dd/MM/yyyy').format(dateTimeFormLocalAdd543);
  }
  String get dateTimeTHFormApi {
    if (this == null || this == '') return '-';
    DateTime dateTimeFormLocal = DateTime.parse(this!).toLocal();
    //dateTimeFormLocal add 543 year
    // DateTime dateTimeFormLocalAdd543 = DateTime(
    //   dateTimeFormLocal.year + 543,
    //    dateTimeFormLocal.month, 
    //    dateTimeFormLocal.day,
    //    dateTimeFormLocal.hour,
    //    dateTimeFormLocal.minute,

    //    );
    //dd/MM/yyyy format
    return DateFormat('EEEE dd MMMM yyyy HH:mm:ss').format(dateTimeFormLocal);
  }

  String get dateFullTHFormApi {
    if (this == null || this == '') return '-';
    DateTime dateTimeFormLocal = DateTime.parse(this!).toLocal();
    //dateTimeFormLocal add 543 year
    DateTime dateTimeFormLocalAdd543 = DateTime(dateTimeFormLocal.year + 543, dateTimeFormLocal.month, dateTimeFormLocal.day);
    //dd/MM/yyyy format
    return DateFormat('d MMMM yyyy', 'th').format(dateTimeFormLocalAdd543);
  }

  //time Only
  String get timeOnlyTHFormApi {
    if (this == null || this == '') return '-';
    DateTime dateTimeFormLocal = DateTime.parse(this!).toLocal();
    //HH:mm format
    return DateFormat('HH:mm:ss').format(dateTimeFormLocal);
  }
}
