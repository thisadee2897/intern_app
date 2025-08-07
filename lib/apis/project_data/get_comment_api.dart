import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/comment_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class GetCommentTaskApi {
  final Ref ref;
  final String _path = 'project_data/get_comment_task';

  GetCommentTaskApi({required this.ref});

  Future<List<CommentModel>> get({required String taskId}) async {
    try {
      final response = await ref.read(apiClientProvider).get(_path, queryParameters: {'task_id': taskId});
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response.data);
      return data.map((e) => CommentModel.fromJson(e)).toList();
    } catch (e) {
      print('⚠️ GetCommentTaskApi Error: $e');
      rethrow;
    }
  }
}

final apiGetCommentTaskProvider = Provider<GetCommentTaskApi>((ref) => GetCommentTaskApi(ref: ref));
