import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class InsertOrUpdateSprintApi {
  final Ref ref;
  final String _path = 'project_data/insert_or_update_sprint';
  InsertOrUpdateSprintApi({required this.ref});
  Future<SprintModel> post({required Map<String, dynamic> body}) async {
    try {
      Response response = await ref.read(apiClientProvider).post(_path, data: body);
      Map<String, dynamic> datas = Map<String, dynamic>.from(response.data);
      return SprintModel.fromJson(datas);
    } catch (e) {
      rethrow;
    }
  }
}

final apiInsertOrUpdateSprint = Provider<InsertOrUpdateSprintApi>((ref) => InsertOrUpdateSprintApi(ref: ref));
