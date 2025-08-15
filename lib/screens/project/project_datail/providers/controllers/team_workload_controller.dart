import 'package:project/apis/project_data/team_workload.dart';
import 'package:project/components/export.dart';
import 'package:project/models/team_workload_model.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';

class TeamWorkloadController extends StateNotifier<AsyncValue<List<TeamWorkloadModel>>> {
  final Ref ref;
  TeamWorkloadController(this.ref) : super(const AsyncValue.loading());
  Future<void> getData() async {
    state = await AsyncValue.guard(() async {
      var projectId = ref.read(selectProjectIdProvider);
      if (projectId == null) return [];
      final result = await ref.read(apiTeamWorkload).get(projectHDId: projectId);
      return result;
    });
  }
}

final teamWorkloadProvider = StateNotifierProvider<TeamWorkloadController, AsyncValue<List<TeamWorkloadModel>>>((ref) => TeamWorkloadController(ref));
