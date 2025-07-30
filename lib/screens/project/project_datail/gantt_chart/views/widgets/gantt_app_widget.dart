import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'gantt_chart_widget.dart';

class GanttAppWidget extends ConsumerStatefulWidget {
  const GanttAppWidget({super.key});

  @override
  ConsumerState<GanttAppWidget> createState() => _GanttAppWidgetState();
}

class _GanttAppWidgetState extends ConsumerState<GanttAppWidget> {
  // Task? _selectedTask;

  // void _handleAddSprint() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => _AddItemDialog(
  //       title: 'Add New Sprint',
  //       hintText: 'Enter sprint name',
  //       onSubmit: (name) {
  //         if (name.isNotEmpty) {
  //           ref.read(ganttDataProvider.notifier).addSprint(name);
  //         }
  //       },
  //     ),
  //   );
  // }

  // void _handleAddTask() {
  //   final sprints = ref.read(ganttDataProvider).sprints;
  //   if (sprints.isEmpty) {
  //     _showErrorDialog('Please add a sprint first!');
  //     return;
  //   }

  //   showDialog(
  //     context: context,
  //     builder: (context) => _AddItemDialog(
  //       title: 'Add New Task',
  //       hintText: 'Enter task name',
  //       onSubmit: (name) {
  //         if (name.isNotEmpty) {
  //           ref.read(ganttDataProvider.notifier).addTask(name);
  //         }
  //       },
  //     ),
  //   );
  // }

  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: const Color(0xFF1F2937),
  //       title: const Text(
  //         'Error',
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       content: Text(
  //         message,
  //         style: const TextStyle(color: Color(0xFFE5E7EB)),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text(
  //             'OK',
  //             style: TextStyle(color: Color(0xFF3B82F6)),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        // Container(
        //   decoration: const BoxDecoration(
        //     color: Color(0xFF111827),
        //     border: Border(
        //       bottom: BorderSide(color: Color(0xFF1F2937)),
        //     ),
        //   ),
        //   padding: const EdgeInsets.all(16),
        //   child: Row(
        //     children: [
        //       const Expanded(
        //         child: Text(
        //           'Interactive Gantt Chart',
        //           style: TextStyle(
        //             fontSize: 20,
        //             fontWeight: FontWeight.bold,
        //             color: Color(0xFFF9FAFB),
        //           ),
        //         ),
        //       ),
        //       const SizedBox(width: 16),
        //       ElevatedButton.icon(
        //         onPressed: _handleAddSprint,
        //         icon: const Icon(Icons.add, size: 20),
        //         label: const Text('Add Sprint'),
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: const Color(0xFF4F46E5),
        //           foregroundColor: Colors.white,
        //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(8),
        //           ),
        //         ),
        //       ),
        //       const SizedBox(width: 12),
        //       ElevatedButton.icon(
        //         onPressed: _handleAddTask,
        //         icon: const Icon(Icons.add, size: 20),
        //         label: const Text('Add Task'),
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: const Color(0xFF059669),
        //           foregroundColor: Colors.white,
        //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(8),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Main content
        Expanded(
          child: const GanttChartWidget(),
        ),
      ],
    );
  }
}

class _AddItemDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final Function(String) onSubmit;

  const _AddItemDialog({
    required this.title,
    required this.hintText,
    required this.onSubmit,
  });

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSubmit(_controller.text.trim());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1F2937),
      title: Text(
        widget.title,
        style: const TextStyle(color: Colors.white),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Color(0xFF6B7280)),
          filled: true,
          fillColor: const Color(0xFF374151),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF4B5563)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
