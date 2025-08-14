import 'package:project/apis/project_data/project_over_view.dart';
import 'package:project/components/export.dart';
import 'package:project/models/project_over_view_model.dart';

class ProjectOverViewController extends StateNotifier<AsyncValue<List<ProjectOverViewModel>>> {
  final Ref ref;
  ProjectOverViewController(this.ref) : super(const AsyncValue.loading());
  Future<void> getData() async {
    state = await AsyncValue.guard(() async {
      final result = await ref.read(apiProjectOverView).get();
      return result;
    });
  }
}

final projectOverViewProvider = StateNotifierProvider<ProjectOverViewController, AsyncValue<List<ProjectOverViewModel>>>(
  (ref) => ProjectOverViewController(ref),
);
