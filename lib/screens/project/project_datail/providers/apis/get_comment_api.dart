import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:project/utils/services/rest_api_service.dart';

class GetCommentTaskApi {
  final Ref ref;
  final String _path = 'project_data/get_comment_task';

  GetCommentTaskApi({required this.ref});

  Future<List<Map<String, dynamic>>> get({required String taskId}) async {
    try {
      final response = await ref.read(apiClientProvider).get(
        _path,
        queryParameters: {'task_id': taskId},
      );

      final data = response.data;

      // ✅ ตรวจว่าคือ List เลย
      if (data is List) {
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        throw Exception('Unexpected response format: $data');
      }

    } catch (e) {
      print('⚠️ GetCommentTaskApi Error: $e');
      rethrow;
    }
  }
}

final apiGetCommentTaskProvider = Provider<GetCommentTaskApi>(
  (ref) => GetCommentTaskApi(ref: ref),
);
