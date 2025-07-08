import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/category_model.dart';
import 'package:project/utils/services/rest_api_service.dart';
import 'package:dio/dio.dart';

/// API Class สำหรับการ insert หรือ update หมวดหมู่โปรเจค
class InsertOrUpdateProjectCategoryApi {
  final Ref ref;
  final String _path = 'project_data/insert_or_update_project_category';

  InsertOrUpdateProjectCategoryApi({required this.ref});

  Future<CategoryModel> post({required Map<String, dynamic> body}) async {
    try {
      Response response =
          await ref.read(apiClientProvider).post(_path, data: body);
      Map<String, dynamic> datas = Map<String, dynamic>.from(response.data);
      return CategoryModel.fromJson(datas);
    } catch (e) {
      rethrow;
    }
  }
}



/// ตัวควบคุม logic สำหรับ insert/update
class CategoryFormController extends StateNotifier<AsyncValue<CategoryModel?>> {
  final Ref ref;

  CategoryFormController(this.ref) : super(const AsyncValue.data(null));

  Future<void> insertOrUpdateCategory(Map<String, dynamic> body) async {
    state = const AsyncValue.loading();
    try {
      final category = await ref.read(apiInsertOrUpdateProjectCategory).post(body: body);
      state = AsyncValue.data(category);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

/// Provider สำหรับ API
final apiInsertOrUpdateProjectCategory =
    Provider<InsertOrUpdateProjectCategoryApi>(
        (ref) => InsertOrUpdateProjectCategoryApi(ref: ref));

/// Provider สำหรับ controller
final categoryFormControllerProvider =
    StateNotifierProvider<CategoryFormController, AsyncValue<CategoryModel?>>(
  (ref) => CategoryFormController(ref),
);

