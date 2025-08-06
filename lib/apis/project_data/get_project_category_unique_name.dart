import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';

class ProjectCategoryUniqueNameApi {
  final Ref ref;
  final String _path = 'project_data/get_project_category_unique_name';
  ProjectCategoryUniqueNameApi({required this.ref});
  Future<String> get({required String testSearch}) async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'text': testSearch});
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

final apiProjectCategoryUniqueName = Provider<ProjectCategoryUniqueNameApi>((ref) => ProjectCategoryUniqueNameApi(ref: ref));
