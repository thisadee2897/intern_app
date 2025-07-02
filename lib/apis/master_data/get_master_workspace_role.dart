import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class GetMasterWorkspaceRoleApi {
  final Ref ref;
  final String _path = 'master_data/get_master_workspace_role';
  GetMasterWorkspaceRoleApi({required this.ref});
  Future<List<WorkspaceModel>> get({required String workspaceId}) async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'workspace_id': workspaceId});
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((data) => WorkspaceModel.fromJson(data)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiGetMasterWorkspaceRole = Provider<GetMasterWorkspaceRoleApi>((ref) => GetMasterWorkspaceRoleApi(ref: ref));
