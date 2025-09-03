// สำหรับเก็บข้อมูล
import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/user_role_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class GetWorkspaceRoleByWorkspaceApi {
  final Ref ref;
  final String _path = 'master_data/get_workspace_role_by_workspace';
  GetWorkspaceRoleByWorkspaceApi({required this.ref});

  Future<List<UserRoleModel>> get(String workspaceId) async {
    try {
      Response response = await ref.read(apiClientProvider).get(
        _path,
        queryParameters: {'workspace_id': workspaceId}, 
      );
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((data) => UserRoleModel.fromJson(data)).toList();
    } catch (e) {
      rethrow;
    }
  }
}


final apiGetWorkspaceRoleByWorkspaceApi = Provider<GetWorkspaceRoleByWorkspaceApi>((ref) => GetWorkspaceRoleByWorkspaceApi(ref: ref));
