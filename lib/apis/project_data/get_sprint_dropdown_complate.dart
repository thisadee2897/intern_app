import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class DropDownSprintFormCompleteApi {
  final Ref ref;
  final String _path = 'project_data/fn_get_sprint_dropdown_complate';
  DropDownSprintFormCompleteApi({required this.ref});
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

final apiDropDownSprintFormComplete = Provider<DropDownSprintFormCompleteApi>((ref) => DropDownSprintFormCompleteApi(ref: ref));
