import 'package:project/apis/project_data/status_overview.dart';
import 'package:project/components/export.dart';
import 'package:project/models/task_status_model.dart';

class StatusOverviewController extends StateNotifier<AsyncValue<List<TaskStatusModel>>> {
  final Ref ref;
  StatusOverviewController(this.ref) : super(const AsyncValue.loading());
  Future<void> getData() async {
    try {
      final result = await ref.read(apiStatusOverview).get();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final statusOverviewProvider = StateNotifierProvider<StatusOverviewController, AsyncValue<List<TaskStatusModel>>>((ref) => StatusOverviewController(ref));