import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class InsertOrUpdateWorkspaceApi {
  final Ref ref;
  final String _path = 'master_data/insert_or_update_workspace';
  InsertOrUpdateWorkspaceApi({required this.ref});
  Future<WorkspaceModel> post({required Map<String, dynamic> body}) async {
    try {
      Response response = await ref.read(apiClientProvider).post(_path, data: body);
      Map<String, dynamic> datas = Map<String, dynamic>.from(response.data);
      return WorkspaceModel.fromJson(datas);
    } catch (e) {
      rethrow;
    }
  }
}

final apiInsertOrUpdateWorkspace = Provider<InsertOrUpdateWorkspaceApi>((ref) => InsertOrUpdateWorkspaceApi(ref: ref));
