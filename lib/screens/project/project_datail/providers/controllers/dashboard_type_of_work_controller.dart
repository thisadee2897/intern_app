import 'package:project/apis/project_data/type_of_work.dart';
import 'package:project/components/export.dart';
import 'package:project/models/type_of_work_model.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';

class DashboardTypeOfWorkNotifier extends StateNotifier<AsyncValue<List<TypeOfWorkModel>>> {
  final Ref ref;
  DashboardTypeOfWorkNotifier(this.ref) : super(const AsyncValue.loading());
  Future<void> getData() async {
    state = await AsyncValue.guard(() async {
      var projectId = ref.read(selectProjectIdProvider);
      if (projectId == null) return [];
      final result = await ref.read(apiTypeOfWork).get(projectHDId: projectId);
      return result;
    });
  }
}

final dashboardTypeOfWorkProvider = StateNotifierProvider<DashboardTypeOfWorkNotifier, AsyncValue<List<TypeOfWorkModel>>>(
  (ref) => DashboardTypeOfWorkNotifier(ref),
);
