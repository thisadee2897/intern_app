import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormStartDateWidget extends StatelessWidget {
  const FormStartDateWidget({super.key, required this.startDate, required this.endDate, required this.onChanged, this.validator});
  final DateTime? startDate;
  final DateTime? endDate;
  // onchanged
  final Function(DateTime) onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(text: startDate != null ? DateFormat('dd/MM/yyyy').format(startDate!) : ''),
      mouseCursor: SystemMouseCursors.click,
      readOnly: true,
      validator: validator,
      decoration: InputDecoration(suffixIcon: const Icon(Icons.calendar_today, size: 20), hintText: 'Select start date'),
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: startDate ?? DateTime.now(),
          currentDate: startDate,
          firstDate: DateTime.now(),
          lastDate: endDate?.add(const Duration(days: -1)) ?? DateTime(DateTime.now().year + 1),
        ).then((value) {
          if (value != null) {
            onChanged(value);
          }
        });
      },
    );
  }
}

class FormEndDateWidget extends StatelessWidget {
  const FormEndDateWidget({super.key, required this.startDate, required this.endDate, required this.onChanged, this.validator});

  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime) onChanged;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: startDate != null,
      controller: TextEditingController(text: endDate != null ? DateFormat('dd/MM/yyyy').format(endDate!) : ''),
      mouseCursor: SystemMouseCursors.click,
      readOnly: true,
      validator: validator,
      decoration: InputDecoration(suffixIcon: const Icon(Icons.calendar_today, size: 20), hintText: 'Select End date'),
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: endDate ?? startDate!.add(const Duration(days: 1)),
          currentDate: endDate,
          firstDate: startDate!.add(const Duration(days: 1)),
          lastDate: DateTime(DateTime.now().year + 1),
        ).then((value) {
          if (value != null) {
            onChanged(value);
          }
        });
      },
    );
  }
}
