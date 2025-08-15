import 'package:project/apis/project_data/type_of_work.dart';
import 'package:project/components/export.dart';
import 'package:project/models/type_of_work_model.dart';

class DashboardTypeOfWorkNotifier extends StateNotifier<AsyncValue<List<TypeOfWorkModel>>> {
  final Ref ref;
  DashboardTypeOfWorkNotifier(this.ref) : super(const AsyncValue.loading());
  Future<void> getData() async {
    state = await AsyncValue.guard(() async {
      final result = await ref.read(apiTypeOfWork).get();
      return result;
    });
  }
}

final dashboardTypeOfWorkProvider = StateNotifierProvider<DashboardTypeOfWorkNotifier, AsyncValue<List<TypeOfWorkModel>>>(
  (ref) => DashboardTypeOfWorkNotifier(ref),
);
