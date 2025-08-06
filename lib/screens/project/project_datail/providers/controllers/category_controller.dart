import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/get_project_category_by_user.dart';
import 'package:project/apis/project_data/get_project_category_unique_name.dart';
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
final categoryControllerProvider = Provider<CategoryController>((ref) => CategoryController(ref));

/// ✅ FutureProvider สำหรับโหลดหมวดหมู่ตาม workspaceId
final categoryListProvider = FutureProvider.family<List<CategoryModel>, String>((ref, workspaceId) async {
  return await ref.read(categoryControllerProvider).getCategories(workspaceId: workspaceId);
});

// final checkTextCategoryUniqueNameProvider = FutureProvider.family<String?, String?>((ref, text) async {
//   if (text == null || text.isEmpty) {
//     return 'Text cannot be empty';
//   } else {
//     final response = await ref.read(apiProjectCategoryUniqueName).get(testSearch: text);
//     return response.isEmpty ? null : response;
//   }
// });
final categoryNameProvider = StateProvider<String>((ref) => '');
final categoryNameErrorProvider = StateProvider<String?>((ref) => null);

final checkTextCategoryUniqueNameProvider = FutureProvider.autoDispose<void>((ref) async {
  final name = ref.watch(categoryNameProvider);
  if (name.isEmpty) {
    ref.read(categoryNameErrorProvider.notifier).state = 'ห้ามเว้นว่าง';
  } else {
    final response = await ref.read(apiProjectCategoryUniqueName).get(testSearch: name);
    ref.read(categoryNameErrorProvider.notifier).state =
        response.isEmpty ? null : 'ชื่อหมวดหมู่นี้ถูกใช้แล้ว';
  }
});
