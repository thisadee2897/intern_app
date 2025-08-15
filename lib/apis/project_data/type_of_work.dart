import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/type_of_work_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class TypeOfWorkApi {
  final Ref ref;
  final String _path = 'project_data/dashboard_type_of_work';
  TypeOfWorkApi({required this.ref});
  Future<List<TypeOfWorkModel>> get({required String projectHDId}) async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'project_id': projectHDId});
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response.data);
      return data.map((item) => TypeOfWorkModel.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiTypeOfWork = Provider<TypeOfWorkApi>((ref) => TypeOfWorkApi(ref: ref));

final dummyTypeOfWork = [
  {"table_name": "TypeOfWork", "id": "1", "name": "Task", "color": "#ff7e00", "count": 25},
  {"table_name": "TypeOfWork", "id": "2", "name": "Epic", "color": "#f2bbc9", "count": 15},
  {"table_name": "TypeOfWork", "id": "3", "name": "Request", "color": "#419ced", "count": 55},
  {"table_name": "TypeOfWork", "id": "4", "name": "Bug", "color": "#8fce00", "count": 5},
  {"table_name": "TypeOfWork", "id": "5", "name": "Feature", "color": "#d3d3d3", "count": 0},
];
