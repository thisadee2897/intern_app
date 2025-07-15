//priority_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/master_data_all/get_master_priority.dart';
import 'package:project/models/priority_model.dart';

class MasterPriorityController extends StateNotifier<AsyncValue<List<PriorityModel>>> {
  final Ref ref;

  MasterPriorityController(this.ref) : super(const AsyncValue.loading()) {
    get(); // โหลดทันทีเมื่อสร้าง controller
  }

  Future<void> get() async {
    try {
      final priorities = await ref.read(apiMasterPriority).get();
      state = AsyncValue.data(priorities);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final masterPriorityControllerProvider =
    StateNotifierProvider<MasterPriorityController, AsyncValue<List<PriorityModel>>>(
        (ref) => MasterPriorityController(ref));
