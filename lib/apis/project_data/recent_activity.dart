import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/comment_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class RecentActivityApi {
  final Ref ref;
  final String _path = 'project_data/dashboard_recent_activity';
  RecentActivityApi({required this.ref});
  Future<List<CommentModel>> get({required String projectHDId}) async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'project_id': projectHDId});
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response.data);
      return data.map((item) => CommentModel.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiRecentActivity = Provider<RecentActivityApi>((ref) => RecentActivityApi(ref: ref));
