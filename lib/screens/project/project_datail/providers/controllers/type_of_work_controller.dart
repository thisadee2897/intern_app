//type_of_work_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/master_data_all/get_master_type_of_work.dart';
import 'package:project/apis/project_data/type_of_work.dart';
import 'package:project/models/type_of_work_model.dart';

class MasterTypeOfWorkController extends StateNotifier<AsyncValue<List<TypeOfWorkModel>>> {
  final Ref ref;

  MasterTypeOfWorkController(this.ref) : super(const AsyncValue.loading()) {
    get(); // โหลดทันทีเมื่อ Controller ถูกสร้าง
  }

  Future<void> get() async {
    try {
      final result = await ref.read(apiMasterTypeOfWork).get();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final masterTypeOfWorkControllerProvider =
    StateNotifierProvider<MasterTypeOfWorkController, AsyncValue<List<TypeOfWorkModel>>>(
        (ref) => MasterTypeOfWorkController(ref));


class DashboardTypeOfWork extends StateNotifier<AsyncValue<List<TypeOfWorkModel>>> {
  final Ref ref;
  DashboardTypeOfWork(this.ref) : super(const AsyncValue.loading());
  Future<void> getData() async {
    try {
      final result = await ref.read(apiTypeOfWork).get();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final dashboardTypeOfWorkProvider = StateNotifierProvider<DashboardTypeOfWork, AsyncValue<List<TypeOfWorkModel>>>((ref) => DashboardTypeOfWork(ref));
