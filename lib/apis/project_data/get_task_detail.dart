import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/task_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class TaskDetailApi {
  final Ref ref;
  final String _path = 'project_data/get_task_detail';
  TaskDetailApi({required this.ref});
  Future<TaskModel> get({required String taskId}) async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'task_id': taskId});
      Map<String, dynamic> datas = Map<String, dynamic>.from(response.data);
      return TaskModel.fromJson(datas);
    } catch (e) {
      rethrow;
    }
  }
}

final apiTaskDetail = Provider<TaskDetailApi>((ref) => TaskDetailApi(ref: ref));
