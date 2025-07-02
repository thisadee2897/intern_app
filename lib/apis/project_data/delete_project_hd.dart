import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';

class DeleteProjectHDApi {
  final Ref ref;
  final String _path = 'project_data/delete_project_hd';
  DeleteProjectHDApi({required this.ref});
  Future<String> delete({required String projectHDId}) async {
    try {
      Response response = await ref.read(apiClientProvider).delete(_path, queryParameters: {'project_hd_id': projectHDId});
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

final apiDeleteProjectHD = Provider<DeleteProjectHDApi>((ref) => DeleteProjectHDApi(ref: ref));
