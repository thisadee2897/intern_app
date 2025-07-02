import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class SprintByProjectApi {
  final Ref ref;
  final String _path = 'project_data/get_sprint_by_project';
  SprintByProjectApi({required this.ref});
  Future<List<SprintModel>> get({required String projectId}) async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'project_id': projectId});
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((e) => SprintModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiSprintByProject = Provider<SprintByProjectApi>((ref) => SprintByProjectApi(ref: ref));
