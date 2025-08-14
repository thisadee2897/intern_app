import 'package:project/components/export.dart';
import 'package:project/models/task_status_model.dart';

class StatusOverviewApi {
  final Ref ref;
  // final String _path = 'project_data/status_overview';
  StatusOverviewApi({required this.ref});
  Future<List<TaskStatusModel>> get() async {
    await Future.delayed(Duration(seconds: 1));
    try {
      // Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'project_hd_id': projectHDId});
      // return response.data;
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(dummyStatusOverview);
      return data.map((item) => TaskStatusModel.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiStatusOverview = Provider<StatusOverviewApi>((ref) => StatusOverviewApi(ref: ref));

final dummyStatusOverview = [
  {"table_name": "task_status", "id": "1", "name": "Done", "color": "#ff7e00", "count": 2},
  {"table_name": "task_status", "id": "2", "name": "In Progress", "color": "#f2bbc9", "count": 4},
  {"table_name": "task_status", "id": "3", "name": "In Review", "color": "#419ced", "count": 1},
  {"table_name": "task_status", "id": "4", "name": "To Do", "color": "#8fce00", "count": 19},
];
