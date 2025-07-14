import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';

class DeleteSprintApi {
  final Ref ref;
  final String _path = 'project_data/delete_sprint';
  DeleteSprintApi({required this.ref});
  Future<String> delete({required String sprintId}) async {
    try {
      Response response = await ref.read(apiClientProvider).delete(_path, queryParameters: {'sprint_id': sprintId});
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

final apiDeleteSprint = Provider<DeleteSprintApi>((ref) => DeleteSprintApi(ref: ref));