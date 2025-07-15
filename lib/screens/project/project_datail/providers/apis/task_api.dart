import 'package:dio/dio.dart';
import 'package:project/models/task_model.dart';
// import 'package:project/models/et_task_model.dart'; // ✅ ใช้ TaskModel แทน
import 'package:project/utils/services/rest_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskBysprintApi {
  final Ref ref;
  final String _path = 'project_data/get_task_by_sprint';
  TaskBysprintApi({required this.ref});

  Future<List<TaskModel>> get({required String projectId}) async {
    try {
      Response response = await ref.read(apiClientProvider).get(
        _path,
        queryParameters: {'project_id': projectId},
      );
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((e) => TaskModel.fromJson(e)).toList(); // ✅ แปลงเป็น TaskModel
    } catch (e) {
      rethrow;
    }
  }
}

final apiTaskBysprint = Provider<TaskBysprintApi>((ref) => TaskBysprintApi(ref: ref));
