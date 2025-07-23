import 'package:project/components/export.dart';
import 'package:project/models/category_model.dart';
import 'package:project/screens/project/category/providers/apis/delete_project_category_api.dart';

final deleteProjectCategoryControllerProvider =
    AsyncNotifierProvider<DeleteProjectCategoryController, CategoryModel?>(
  DeleteProjectCategoryController.new,
);

class DeleteProjectCategoryController
    extends AsyncNotifier<CategoryModel?> {
  @override
  Future<CategoryModel?> build() async {
    // ค่าเริ่มต้นคือ null เพราะยังไม่ได้ลบอะไร
    return null;
  }

  /// ฟังก์ชันสำหรับเรียก API ลบหมวดหมู่โปรเจค
  Future<void> deleteCategory(Map<String, dynamic> body) async {
    state = const AsyncLoading();

    try {
      final api = ref.read(apiDeleteProjectCategory);
      final result = await api.post(body: body);

      // อัปเดต state ด้วย CategoryModel ที่ลบแล้ว
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}