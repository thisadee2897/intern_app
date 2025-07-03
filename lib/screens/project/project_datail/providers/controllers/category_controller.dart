import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/get_project_category_by_user.dart';
import 'package:project/apis/project_data/insert_or_update_project_category.dart';
import 'package:project/models/category_model.dart';

/// 🔁 Controller สำหรับจัดการ Category ของ Project
class CategoryController {
  final Ref ref;
  CategoryController(this.ref);

  /// 🔄 ดึง category ทั้งหมดใน workspace
  Future<List<CategoryModel>> getCategories({required String workspaceId}) async {
    return await ref.read(apiProjectCategoryByUser).get(workspaceId: workspaceId);
  }

  /// ✅ เพิ่มหรืออัปเดต Category
  Future<CategoryModel> addOrUpdateCategory(Map<String, dynamic> body) async {
    return await ref.read(apiInsertOrUpdateProjectCategory).post(body: body);
  }
}

/// ✅ Provider สำหรับ CategoryController
final categoryControllerProvider = Provider<CategoryController>(
  (ref) => CategoryController(ref),
);

/// ✅ FutureProvider สำหรับโหลดหมวดหมู่ตาม workspaceId
final categoryListProvider = FutureProvider.family<List<CategoryModel>, String>((ref, workspaceId) async {
  return await ref.read(categoryControllerProvider).getCategories(workspaceId: workspaceId);
});
