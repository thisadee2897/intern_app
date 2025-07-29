import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project/models/task_model.dart';
import 'package:project/screens/auth/providers/controllers/auth_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/insert_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/task_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/priority_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/type_of_work_controller.dart';
import 'package:project/screens/project/project_datail/providers/controllers/master_task_status_controller.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  final String? sprintId;
  final String? projectHdId;
  final TaskModel? task;

  const AddTaskScreen({super.key, this.sprintId, this.projectHdId, this.task});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateTimeController = TextEditingController();
  final endDateTimeController = TextEditingController();

  String? selectedPriority;
  String? selectedTypeOfWork;
  String? selectedStatus;
  String? selectedAssignee;

  DateTime? startDateTime;
  DateTime? endDateTime;
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    final user = ref.read(loginProvider).value?.user; // ✅ ดึง user จาก loginProvider

    if (t != null) {
      nameController.text = t.name ?? '';
      descriptionController.text = t.description ?? '';
      selectedPriority = t.priority?.id?.toString();
      selectedStatus = t.taskStatus?.id?.toString();
      selectedTypeOfWork = t.typeOfWork?.id?.toString();
      selectedAssignee = t.assignedTo?.id?.toString();
      startDateTime = t.taskStartDate != null ? DateTime.tryParse(t.taskStartDate!) : null;
      endDateTime = t.taskEndDate != null ? DateTime.tryParse(t.taskEndDate!) : null;
      isActive = t.active ?? true;

      if (startDateTime != null) {
        startDateTimeController.text = DateFormat('yyyy-MM-dd').format(startDateTime!);
      }
      if (endDateTime != null) {
        endDateTimeController.text = DateFormat('yyyy-MM-dd').format(endDateTime!);
      }
    } else {
      selectedAssignee = user?.id?.toString(); // ✅ default ผู้รับผิดชอบเป็นคนล็อกอิน
    }
  }

  Future<void> _selectDate({required BuildContext context, required bool isStart}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? (startDateTime ?? DateTime.now()) : (endDateTime ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        final formatted = DateFormat('yyyy-MM-dd').format(pickedDate);
        if (isStart) {
          startDateTime = pickedDate;
          startDateTimeController.text = formatted;
        } else {
          endDateTime = pickedDate;
          endDateTimeController.text = formatted;
        }
      });
    }
  }

  Future<void> handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final taskJson = {
        "task_id": widget.task?.id ?? "0",
        "project_hd_id": widget.projectHdId ?? "1",
        "sprint_id": widget.sprintId ?? "0",
        "master_priority_id": selectedPriority,
        "master_task_status_id": selectedStatus,
        "master_type_of_work_id": selectedTypeOfWork,
        "task_name": nameController.text.trim(),
        "task_description": descriptionController.text.trim(),
        "task_assigned_to": selectedAssignee ?? "1",
        "task_start_date": startDateTime?.toIso8601String(),
        "task_end_date": endDateTime?.toIso8601String(),
        "task_is_active": isActive,
      };

      try {
        await ref.read(insertOrUpdateTaskControllerProvider.notifier).submit(body: taskJson);
        final projectId = widget.projectHdId ?? "1";
        await ref.read(taskBySprintControllerProvider(projectId).notifier).fetch();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.task == null ? 'เพิ่มงานสำเร็จ' : 'แก้ไขงานสำเร็จ')),
        );
        Navigator.of(context).pop(true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: ${e.toString()}')),
        );
      }
    }
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF6F8FB),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final priorities = ref.watch(masterPriorityControllerProvider);
    final types = ref.watch(masterTypeOfWorkControllerProvider);
    final statuses = ref.watch(masterTaskStatusControllerProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.task == null ? "เพิ่มงานใหม่" : "แก้ไขงาน", style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage('https://images.pexels.com/photos/314726/pexels-photo-314726.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: inputDecoration('ชื่องาน', Icons.task),
                    validator: (val) => val == null || val.isEmpty ? 'กรอกชื่องาน' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descriptionController,
                    decoration: inputDecoration('รายละเอียด', Icons.description),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  priorities.when(
                    data: (data) => DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: inputDecoration('Priority', Icons.flag),
                      items: data.map((e) => DropdownMenuItem(
                        value: e.id.toString(),
                        child: Text(e.name ?? '-'),
                      )).toList(),
                      onChanged: (val) => setState(() => selectedPriority = val),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 12),
                  types.when(
                    data: (data) => DropdownButtonFormField<String>(
                      value: selectedTypeOfWork,
                      decoration: inputDecoration('ประเภทงาน', Icons.work),
                      items: data.map((e) => DropdownMenuItem(
                        value: e.id.toString(),
                        child: Text(e.name ?? '-'),
                      )).toList(),
                      onChanged: (val) => setState(() => selectedTypeOfWork = val),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 12),
                  statuses.when(
                    data: (data) => DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: inputDecoration('สถานะ', Icons.info_outline),
                      items: data.map((e) => DropdownMenuItem(
                        value: e.id.toString(),
                        child: Text(e.name ?? '-'),
                      )).toList(),
                      onChanged: (val) => setState(() => selectedStatus = val),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: startDateTimeController,
                    readOnly: true,
                    decoration: inputDecoration('วันเริ่มต้น', Icons.calendar_today),
                    onTap: () => _selectDate(context: context, isStart: true),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: endDateTimeController,
                    readOnly: true,
                    decoration: inputDecoration('วันสิ้นสุด', Icons.event),
                    onTap: () => _selectDate(context: context, isStart: false),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: isActive,
                    title: const Text('สถานะการใช้งาน'),
                    subtitle: Text(isActive ? 'เปิดใช้งาน' : 'ปิดใช้งาน'),
                    secondary: Icon(
                      isActive ? Icons.check_circle : Icons.cancel,
                      color: isActive ? Colors.green : Colors.red,
                    ),
                    onChanged: (val) => setState(() => isActive = val),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(widget.task == null ? "บันทึกงาน" : "บันทึกการแก้ไข"),
                    onPressed: handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: const Color.fromARGB(255, 238, 238, 245),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
