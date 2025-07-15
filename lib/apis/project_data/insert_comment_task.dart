import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';

class InsertCommentTaskApi {
  final Ref ref;
  final String _path = 'project_data/insert_comment_task';
  InsertCommentTaskApi({required this.ref});
  Future<String> post({required Map<String, dynamic> body}) async {
    try {
      Response response = await ref.read(apiClientProvider).post(_path, data: body);
      return response.data['message'].toString();
    } catch (e) {
      rethrow;
    }
  }
}

final apiInsertCommentTask = Provider<InsertCommentTaskApi>((ref) => InsertCommentTaskApi(ref: ref));
