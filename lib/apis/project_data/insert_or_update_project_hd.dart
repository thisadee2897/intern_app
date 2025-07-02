import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class InsertOrUpdateProjectHDApi {
  final Ref ref;
  final String _path = 'project_data/insert_or_update_project_hd';
  InsertOrUpdateProjectHDApi({required this.ref});
  Future<ProjectHDModel> post({required Map<String, dynamic> body}) async {
    try {
      Response response = await ref.read(apiClientProvider).post(_path, data: body);
      Map<String, dynamic> datas =Map<String, dynamic>.from(response.data);
      return ProjectHDModel.fromJson(datas);
    } catch (e) {
      rethrow;
    }
  }
}

final apiInsertOrUpdateProjectHD = Provider<InsertOrUpdateProjectHDApi>((ref) => InsertOrUpdateProjectHDApi(ref: ref));
