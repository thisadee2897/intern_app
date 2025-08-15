import 'package:project/apis/project_data/priority_breakdown.dart';
import 'package:project/components/export.dart';
import 'package:project/models/priority_model.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';

class PiorityBreakdownController extends StateNotifier<AsyncValue<List<PriorityModel>>> {
  final Ref ref;
  PiorityBreakdownController(this.ref) : super(const AsyncValue.loading());
  Future<void> getData() async {
    state = await AsyncValue.guard(() async {
      var projectId = ref.read(selectProjectIdProvider);
      if (projectId == null) return [];
      final result = await ref.read(apiPriorityBreakdown).get(projectHDId: projectId);
      return result;
    });
  }
}

final piorityBreakdownProvider = StateNotifierProvider<PiorityBreakdownController, AsyncValue<List<PriorityModel>>>((ref) => PiorityBreakdownController(ref));
