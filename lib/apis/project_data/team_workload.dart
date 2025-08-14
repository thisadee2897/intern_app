import 'package:project/components/export.dart';
import 'package:project/models/team_workload_model.dart';

class TeamWorkloadApi {
  final Ref ref;
  // final String _path = 'project_data/status_overview';
  TeamWorkloadApi({required this.ref});
  Future<List<TeamWorkloadModel>> get() async {
    await Future.delayed(Duration(seconds: 1));
    try {
      // Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'project_hd_id': projectHDId});
      // return response.data;
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(dummyTeamWorkload);
      return data.map((item) => TeamWorkloadModel.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiTeamWorkload = Provider<TeamWorkloadApi>((ref) => TeamWorkloadApi(ref: ref));

final dummyTeamWorkload = [
  {"table_name": "TeamWorkload", "id": "1", "name": "Task", "color": "#ff7e00", "count": 25},
  {"table_name": "TeamWorkload", "id": "2", "name": "Epic", "color": "#f2bbc9", "count": 15},
  {"table_name": "TeamWorkload", "id": "3", "name": "Request", "color": "#419ced", "count": 55},
  {"table_name": "TeamWorkload", "id": "4", "name": "Bug", "color": "#8fce00", "count": 5},
  {"table_name": "TeamWorkload", "id": "5", "name": "Feature", "color": "#d3d3d3", "count": 0},
];
