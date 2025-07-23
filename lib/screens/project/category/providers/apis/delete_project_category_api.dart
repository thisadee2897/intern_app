import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/category_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class DeleteProjectCategoryApi {
  final Ref ref;
  final String _path = 'project_data/delete_project_category';
  DeleteProjectCategoryApi({required this.ref});
  Future<CategoryModel> post({required Map<String, dynamic> body}) async {
    try {
      Response response = await ref.read(apiClientProvider).post(_path, data: body);
      Map<String, dynamic> datas =Map<String, dynamic>.from(response.data);
      return CategoryModel.fromJson(datas);
    } catch (e) {
      rethrow;
    }
  }
}

final apiDeleteProjectCategory = Provider<DeleteProjectCategoryApi>((ref) => DeleteProjectCategoryApi(ref: ref));