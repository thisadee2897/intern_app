
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
          SizedBox(width: 120, child: Text(title, style: TextStyle(color: Colors.grey.shade700, fontSize: 14))),
          Expanded(child: SizedBox(height: 40, child: SmartDateFieldPicker(
           
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
              
              border: OutlineInputBorder(),
            ),
            initialDate: initialDate, controller: controller, onDateSelected: onDateSelected))),
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
        Text(' : $value', style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }
}
