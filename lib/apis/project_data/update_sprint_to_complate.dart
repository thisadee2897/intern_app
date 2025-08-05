import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class UpdateSprintToComplateApi {
  final Ref ref;
  final String _path = 'project_data/update_sprint_to_complate';
  UpdateSprintToComplateApi({required this.ref});
  Future<List<SprintModel>> post({required Map<String, dynamic> body}) async {
    print(jsonEncode(body));
    try {
      Response response = await ref.read(apiClientProvider).post(_path, data: body);
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((e) => SprintModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiUpdateSprintToComplate = Provider<UpdateSprintToComplateApi>((ref) => UpdateSprintToComplateApi(ref: ref));
