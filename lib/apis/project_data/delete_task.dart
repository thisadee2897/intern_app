import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';

class DeleteTaskApi {
  final Ref ref;
  final String _path = 'project_data/delete_task';
  DeleteTaskApi({required this.ref});
  Future<String> delete({required String taskId}) async {
    try {
      Response response = await ref.read(apiClientProvider).delete(_path, queryParameters: {'task_id': taskId});
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

final apiDeleteTask = Provider<DeleteTaskApi>((ref) => DeleteTaskApi(ref: ref));
