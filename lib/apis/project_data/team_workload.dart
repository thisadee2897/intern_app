import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/team_workload_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class TeamWorkloadApi {
  final Ref ref;
  final String _path = 'project_data/dashboard_team_workload';
  TeamWorkloadApi({required this.ref});
  Future<List<TeamWorkloadModel>> get({required String projectHDId}) async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'project_hd_id': projectHDId});
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response.data);
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
