import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';

class InsertUpdateSprint extends BaseStatefulWidget {
  final SprintModel? sprint; // null for insert, SprintModel for update
  const InsertUpdateSprint({super.key, this.sprint});
  @override
  BaseState<InsertUpdateSprint> createState() => _InsertUpdateSprintState();
}

class _InsertUpdateSprintState extends BaseState<InsertUpdateSprint> {
  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // ถ้าเป็นการแก้ไข ให้ใส่ข้อมูลเดิมลงในฟอร์ม
    if (widget.sprint != null) {
      nameController.text = widget.sprint!.name ?? '';
      durationController.text = widget.sprint!.duration?.toString() ?? '14';
      goalController.text = widget.sprint!.goal ?? '';
    } else {
      // ถ้าเป็นการเพิ่มใหม่ ให้ duration เป็น 14 วัน (default)
      durationController.text = '14';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    durationController.dispose();
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget buildDesktop(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    final insertUpdateState = ref.watch(insertUpdateSprintProvider);
    final selectedProjectId = ref.watch(selectProjectIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.sprint == null ? 'เพิ่ม Sprint ใหม่' : 'แก้ไข Sprint',
          style: const TextStyle(
            color: Color.fromARGB(255, 24, 87, 118),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 24, 87, 118)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 240, 248, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.blue.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Section
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      24,
                                      87,
                                      118,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.rocket_launch,
                                    color: Color.fromARGB(255, 24, 87, 118),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.sprint == null
                                            ? 'สร้าง Sprint ใหม่'
                                            : 'แก้ไข Sprint',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                            255,
                                            24,
                                            87,
                                            118,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.sprint == null
                                            ? 'เพิ่มสปรินต์ใหม่เพื่อจัดการงานในโปรเจกต์'
                                            : 'แก้ไขข้อมูล Sprint ที่มีอยู่',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Sprint Name Field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ชื่อ Sprint *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 24, 87, 118),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText:
                                        'กรอกชื่อ Sprint เช่น "Sprint 1A"',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 24, 87, 118),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    prefixIcon: const Icon(
                                      Icons.title,
                                      color: Color.fromARGB(255, 24, 87, 118),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'กรุณากรอกชื่อ Sprint';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Duration Field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ระยะเวลา (วัน) *',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 24, 87, 118),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: durationController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'กรอกจำนวนวัน เช่น 14',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 24, 87, 118),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    prefixIcon: const Icon(
                                      Icons.access_time,
                                      color: Color.fromARGB(255, 24, 87, 118),
                                    ),
                                    suffixText: 'วัน',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'กรุณากรอกระยะเวลา';
                                    }
                                    final duration = int.tryParse(value.trim());
                                    if (duration == null || duration <= 0) {
                                      return 'กรุณากรอกระยะเวลาที่ถูกต้อง (มากกว่า 0)';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Goal Field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'เป้าหมาย Sprint',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 24, 87, 118),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: goalController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText:
                                        'กรอกเป้าหมายของ Sprint เช่น "Complete initial setup"',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 24, 87, 118),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.only(bottom: 48.0),
                                      child: Icon(
                                        Icons.flag,
                                        color: Color.fromARGB(255, 24, 87, 118),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Info Section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 229, 246, 253),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    24,
                                    87,
                                    118,
                                  ).withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info,
                                    color: Color.fromARGB(255, 24, 87, 118),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'ข้อมูลเพิ่มเติม',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                              255,
                                              24,
                                              87,
                                              118,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '• วันเริ่มต้นและวันสิ้นสุดจะถูกกำหนดเมื่อเริ่ม Sprint\n'
                                          '• สถานะเริ่มต้นจะเป็น "ยังไม่เริ่ม"\n'
                                          '• Project ID: ${selectedProjectId ?? "ไม่ระบุ"}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Action Buttons
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('ยกเลิก'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 156, 163, 175),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            insertUpdateState.isLoading ? null : _handleSubmit,
                        icon:
                            insertUpdateState.isLoading
                                ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Icon(
                                  widget.sprint == null
                                      ? Icons.add
                                      : Icons.update,
                                ),
                        label: Text(
                          insertUpdateState.isLoading
                              ? 'กำลังบันทึก...'
                              : (widget.sprint == null
                                  ? 'เพิ่ม Sprint'
                                  : 'อัปเดต Sprint'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            24,
                            87,
                            118,
                          ),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (!formKey.currentState!.validate()) return;

    final selectedProjectId = ref.read(selectProjectIdProvider);
    if (selectedProjectId == null || selectedProjectId.isEmpty) {
      _showErrorSnackBar('ไม่พบ Project ID กรุณาเลือกโปรเจกต์ก่อน');
      return;
    }

    try {
      await ref
          .read(insertUpdateSprintProvider.notifier)
          .insertOrUpdateSprint(
            id: widget.sprint?.id ?? "0", // ถ้าเป็นการเพิ่มใหม่ให้ id = "0"
            name: nameController.text.trim(),
            duration: int.parse(durationController.text.trim()),
            goal: goalController.text.trim(),
            projectHdId: selectedProjectId,
            hdId: selectedProjectId, // ค่าคงที่ตามที่ระบุ
          );

      final state = ref.read(insertUpdateSprintProvider);
      state.whenOrNull(
        data: (sprint) {
          if (sprint != null) {
            _showSuccessSnackBar(
              widget.sprint == null
                  ? 'เพิ่ม Sprint เรียบร้อยแล้ว'
                  : 'อัปเดต Sprint เรียบร้อยแล้ว',
            );
            Navigator.of(context).pop(true); // ส่งค่า true เพื่อแจ้งว่าสำเร็จ
          }
        },
        error: (error, _) {
          _showErrorSnackBar('เกิดข้อผิดพลาด: $error');
        },
      );
    } catch (e) {
      _showErrorSnackBar('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget buildTablet(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    //return Center(child: Text('Tablet View', style: Theme.of(context).textTheme.titleLarge));
    return buildDesktop(context, sizingInformation);
  }

  @override
  Widget buildMobile(
    BuildContext context,
    SizingInformation sizingInformation,
  ) {
    //return Center(child: Text('Mobile View', style: Theme.of(context).textTheme.titleLarge));
    return buildDesktop(context, sizingInformation);
  }
}
