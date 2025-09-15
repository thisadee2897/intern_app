import 'package:flutter/material.dart';
import 'package:smart_date_field_picker/smart_date_field_picker.dart';

class DateDetailRowWidget extends StatelessWidget {
  final String title;
  final DateTime? initialDate;
  final OverlayPortalController controller;
  final Function(DateTime?) onDateSelected;
  const DateDetailRowWidget({super.key, required this.title, this.initialDate, required this.controller, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 120, child: Text(title, style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 14))),
          Expanded(
            child: SizedBox(
              height: 40, 
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: const Color(0xFF1A237E), // สีน้ำเงินเข้มสำหรับ header
                    onPrimary: Colors.white, // สีข้อความบน header
                    surface: const Color(0xFF0D1B4B), // สีพื้นหลังของปฏิทิน (น้ำเงินเข้ม)
                    onSurface: Colors.white, // สีข้อความในปฏิทิน
                    secondary: const Color(0xFF1A237E), // สีสำหรับวันที่ที่เลือก
                    onSecondary: Colors.white, // สีข้อความของวันที่ที่เลือก
                    background: const Color(0xFF0D1B4B), // สีพื้นหลังหลัก
                    onBackground: Colors.white, // สีข้อความบนพื้นหลังหลัก
                  ),
                  dialogBackgroundColor: const Color(0xFF0D1B4B), // สีพื้นหลังของ dialog
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // สีปุ่ม OK/Cancel
                    ),
                  ),
                  // ใช้ ThemeData แทน DatePickerThemeData
                  primaryColor: const Color(0xFF1A237E),
                  scaffoldBackgroundColor: const Color(0xFF0D1B4B),
                  cardColor: const Color(0xFF0D1B4B),
                  dividerColor: Colors.white.withOpacity(0.3),
                ),
                child: SmartDateFieldPicker(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
                    border: OutlineInputBorder(),
                  ),
                  initialDate: initialDate, 
                  controller: controller, 
                  onDateSelected: onDateSelected
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleForTask extends StatelessWidget {
  final String title;
  final String value;
  const TitleForTask({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 80, child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
        Text(' : $value', style: const TextStyle(fontSize: 14, color: Color.fromARGB(221, 245, 245, 245))),
      ],
    );
  }
}