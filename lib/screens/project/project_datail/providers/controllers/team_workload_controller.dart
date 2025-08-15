
import 'package:project/apis/project_data/team_workload.dart';
import 'package:project/components/export.dart';
import 'package:project/models/team_workload_model.dart';

class TeamWorkloadController extends StateNotifier<AsyncValue<List<TeamWorkloadModel>>> {
  final Ref ref;
  TeamWorkloadController(this.ref) : super(const AsyncValue.loading());
  Future<void> getData() async {
    try {
      final result = await ref.read(apiTeamWorkload).get();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final teamWorkloadProvider = StateNotifierProvider<TeamWorkloadController, AsyncValue<List<TeamWorkloadModel>>>((ref) => TeamWorkloadController(ref));
