import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/insert_or_update_project_category.dart';
import 'package:project/models/category_model.dart';

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
/// Provider สำหรับ controller
final insertOrUpdateCategoryProvider = StateNotifierProvider<CategoryFormController, AsyncValue<CategoryModel?>>((ref) => CategoryFormController(ref));
