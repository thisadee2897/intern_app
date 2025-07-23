import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';

class DeleteProjectCategoryApi {
  final Ref ref;
  final String _path = 'project_data/delete_project_category';

  DeleteProjectCategoryApi({required this.ref});

  /// ลบ category และคืนค่าข้อความตอบกลับจาก API
  Future<String> delete({required Map<String, dynamic> body}) async {
    try {
      final projectCategoryId = body['project_category_id'];
      print('📤 Sending DELETE to $_path with query: $projectCategoryId');

      final response = await ref.read(apiClientProvider).delete(
        _path,
        queryParameters: {
          'project_category_id': projectCategoryId,
        },
      );

      print('✅ Success response: ${response.statusCode} - ${response.data}');
      return response.data.toString(); // ✅ เก็บข้อความเช่น "Successfully deleted project category"
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('📦 Status code: ${e.response?.statusCode}');
      print('📨 Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('❌ Unknown Error: $e');
      rethrow;
    }
  }
}

final apiDeleteProjectCategory = Provider<DeleteProjectCategoryApi>(
  (ref) => DeleteProjectCategoryApi(ref: ref),
);
