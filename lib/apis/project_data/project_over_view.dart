import 'package:project/components/export.dart';
import 'package:project/models/project_over_view_model.dart';

class ProjectOverViewApi {
  final Ref ref;
  // final String _path = 'project_data/status_overview';
  ProjectOverViewApi({required this.ref});
  Future<List<ProjectOverViewModel>> get() async {
    await Future.delayed(Duration(seconds: 1));
    try {
      // Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'project_hd_id': projectHDId});
      // return response.data;
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(dummyProjectOverView);
      return data.map((item) => ProjectOverViewModel.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiProjectOverView = Provider<ProjectOverViewApi>((ref) => ProjectOverViewApi(ref: ref));

final dummyProjectOverView = [
  {"table_name": "ProjectOverView", "title": "completed", "icon": "completed", "count": 5},
  {"table_name": "ProjectOverView", "title": "updated", "icon": "updated", "count": 3},
  {"table_name": "ProjectOverView", "title": "created", "icon": "created", "count": 2},
  {"table_name": "ProjectOverView", "title": "due soon", "icon": "due_soon", "count": 0},
];
