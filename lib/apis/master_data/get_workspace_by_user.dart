import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class GetWorkspaceByUserApi {
  final Ref ref;
  final String _path = 'master_data/get_workspace_by_user';
  GetWorkspaceByUserApi({required this.ref});
  Future<List<WorkspaceModel>> get() async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path);
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((data) => WorkspaceModel.fromJson(data)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiGetWorkspaceByUser = Provider<GetWorkspaceByUserApi>((ref) => GetWorkspaceByUserApi(ref: ref));
