import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/master_data_all/get_master_task_status.dart';
import 'package:project/models/task_status_model.dart';

class MasterTaskStatusController extends StateNotifier<AsyncValue<List<TaskStatusModel>>> {
  final Ref ref;

  MasterTaskStatusController(this.ref) : super(const AsyncValue.loading()) {
    fetchTaskStatuses(); // ดึงข้อมูลทันทีเมื่อ controller ถูกสร้าง
  }

  Future<void> fetchTaskStatuses() async {
    try {
      state = const AsyncValue.loading(); // ตั้งค่าสถานะเป็น loading
      final data = await ref.read(apiMasterTaskStatus).get(); // เรียก API
      state = AsyncValue.data(data); // ถ้าเรียกสำเร็จ
    } catch (e, st) {
      state = AsyncValue.error(e, st); // ถ้าเกิด error
    }
  }
}

final masterTaskStatusControllerProvider = StateNotifierProvider<MasterTaskStatusController, AsyncValue<List<TaskStatusModel>>>(
  (ref) => MasterTaskStatusController(ref),
);
