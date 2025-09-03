import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/user_role_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class InsertOrUpdateWorkspaceRoleApi {
  final Ref ref;
  final String _path = 'master_data/insert_or_update_workspace_role';
  InsertOrUpdateWorkspaceRoleApi({required this.ref});
  Future<UserRoleModel> post({required Map<String, dynamic> body}) async {
    try {
      Response response = await ref.read(apiClientProvider).post(_path, data: body);
      Map<String, dynamic> datas = Map<String, dynamic>.from(response.data);
      return UserRoleModel.fromJson(datas);
    } catch (e) {
      rethrow;
    }
  }
}

final apiInsertOrUpdateWorkspaceRoleApi = Provider<InsertOrUpdateWorkspaceRoleApi>((ref) => InsertOrUpdateWorkspaceRoleApi(ref: ref));
