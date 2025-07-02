import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/category_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class ProjectCategoryByUserApi {
  final Ref ref;
  final String _path = 'project_data/get_project_category_by_user';
  ProjectCategoryByUserApi({required this.ref});
  Future<List<CategoryModel>> get({required String workspaceId}) async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'workspace_id': workspaceId});
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiProjectCategoryByUser = Provider<ProjectCategoryByUserApi>((ref) => ProjectCategoryByUserApi(ref: ref));
