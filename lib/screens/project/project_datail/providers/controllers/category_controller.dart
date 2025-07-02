import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/category_model.dart';
import 'package:project/screens/project/project_datail/providers/apis/category_api.dart';

class CategoryController {
  final Ref ref;
  CategoryController(this.ref);

  Future<List<CategoryModel>> getCategories({Map<String, dynamic>? params}) async {
    return await ref.read(apiCategory).getCategories(params: params);
  }
}

final categoryControllerProvider = Provider<CategoryController>((ref) => CategoryController(ref));
