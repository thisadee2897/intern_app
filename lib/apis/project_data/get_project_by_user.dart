import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class GetProjectByUserApi {
  final Ref ref;
  final String _path = 'project_data/get_project_by_user';
  GetProjectByUserApi({required this.ref});
  Future<List<ProjectHDModel>> get({String categoryId = '0'}) async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'category_id': categoryId});
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((e) => ProjectHDModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiGetProjectByUser = Provider<GetProjectByUserApi>((ref) => GetProjectByUserApi(ref: ref));
