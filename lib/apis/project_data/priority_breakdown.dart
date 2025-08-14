import 'package:project/components/export.dart';
import 'package:project/models/priority_model.dart';

class PriorityBreakdownApi {
  final Ref ref;
  // final String _path = 'project_data/status_overview';
  PriorityBreakdownApi({required this.ref});
  Future<List<PriorityModel>> get() async {
    await Future.delayed(Duration(seconds: 1));
    try {
      // Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'project_hd_id': projectHDId});
      // return response.data;
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(dummyPriorityBreakdown);
      return data.map((item) => PriorityModel.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiPriorityBreakdown = Provider<PriorityBreakdownApi>((ref) => PriorityBreakdownApi(ref: ref));

final dummyPriorityBreakdown = [
  {"table_name": "Priority", "id": "1", "name": "Highest", "color": "#ff7e00", "count": 2},
  {"table_name": "Priority", "id": "2", "name": "High", "color": "#f2bbc9", "count": 4},
  {"table_name": "Priority", "id": "3", "name": "Medium", "color": "#419ced", "count": 1},
  {"table_name": "Priority", "id": "4", "name": "Low", "color": "#8fce00", "count": 19},
  {"table_name": "Priority", "id": "5", "name": "Lowest", "color": "#d3d3d3", "count": 0},
];
