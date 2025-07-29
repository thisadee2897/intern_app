import 'package:project/components/export.dart';
import 'package:project/screens/project/category/providers/apis/delete_project_category_api.dart';

/// Provider สำหรับ Controller
final deleteProjectCategoryControllerProvider =
    AsyncNotifierProvider<DeleteProjectCategoryController, String?>(
  DeleteProjectCategoryController.new,
);

class DeleteProjectCategoryController extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    return null;
  }

  /// เรียก API แล้วอัปเดตข้อความที่ได้กลับมา
  Future<void> deleteCategory(Map<String, dynamic> body) async {
    state = const AsyncLoading();
    try {
      final result = await ref.read(apiDeleteProjectCategory).delete(body: body);
      state = AsyncData(result); // ✅ result คือข้อความที่ตอบกลับ เช่น "Successfully deleted..."
    } catch (e, st) {
      print('Error: $e');
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
