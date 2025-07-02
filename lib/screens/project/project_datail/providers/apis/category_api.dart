import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/category_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class CategoryApi {
  final Ref ref;
  final String _path = 'project_data/get_project_category_by_user'; // ตัวอย่าง path
  CategoryApi({required this.ref});

  Future<List<CategoryModel>> getCategories({Map<String, dynamic>? params}) async {
    final response = await ref.read(apiClientProvider).get(_path, queryParameters: params);
    // สมมุติว่า response.data เป็น List
    List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
    return datas.map((e) => CategoryModel.fromJson(e)).toList();
  }
}

final apiCategory = Provider<CategoryApi>((ref) => CategoryApi(ref: ref));
