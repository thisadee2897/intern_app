import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/utils/services/rest_api_service.dart';

class DeleteCommentTaskApi {
  final Ref ref;
  final String _path = 'project_data/delete_comment_task';

  DeleteCommentTaskApi({required this.ref});

  Future<String> delete({required String activityId}) async {
    try {
      // ✅ แปลงเป็น int ป้องกันความผิดพลาดจาก API ที่รับเฉพาะ int
      final intId = int.tryParse(activityId);
      if (intId == null) {
        throw Exception('Invalid activityId: ไม่สามารถแปลงเป็น int ได้');
      }

      final response = await ref.read(apiClientProvider).delete(
        _path,
        queryParameters: {'activity_id': intId},
      );

      // ✅ DEBUG ประเภทของ response
      print('✅ response.data runtimeType: ${response.data.runtimeType}');
      print('✅ response.data content: ${response.data}');

      // ✅ ป้องกันกรณี response.data ไม่ใช่ Map
      if (response.data is Map<String, dynamic>) {
        return response.data['message'] ?? 'ลบความคิดเห็นสำเร็จ';
      } else {
        return 'ลบความคิดเห็นสำเร็จ (ไม่มีข้อความจากเซิร์ฟเวอร์)';
      }
    } catch (e) {
      print('❌ DeleteCommentTaskApi error: $e');
      rethrow;
    }
  }
}

final deleteCommentTaskApiProvider = Provider<DeleteCommentTaskApi>(
  (ref) => DeleteCommentTaskApi(ref: ref),
);
