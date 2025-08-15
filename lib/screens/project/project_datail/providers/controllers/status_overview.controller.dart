import 'package:project/apis/project_data/status_overview.dart';
import 'package:project/components/export.dart';
import 'package:project/models/task_status_model.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';

class StatusOverviewController extends StateNotifier<AsyncValue<List<TaskStatusModel>>> {
  final Ref ref;
  StatusOverviewController(this.ref) : super(const AsyncValue.loading());
  Future<void> getData() async {
    state = await AsyncValue.guard(() async {
      var projectId = ref.read(selectProjectIdProvider);
      if (projectId == null) return [];
      final result = await ref.read(apiStatusOverview).get(projectHDId: projectId);
      return result;
    });
  }
}

final statusOverviewProvider = StateNotifierProvider<StatusOverviewController, AsyncValue<List<TaskStatusModel>>>((ref) => StatusOverviewController(ref));
