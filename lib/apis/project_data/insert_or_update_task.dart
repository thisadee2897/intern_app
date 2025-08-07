import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';

class InsertOrUpdateTaskApi {
  final Ref ref;
  final String _path = 'project_data/insert_or_update_task';
  InsertOrUpdateTaskApi({required this.ref});
  Future<String> post({required Map<String, dynamic> body}) async {
    try {
      Response response = await ref.read(apiClientProvider).post(_path, data: body);
      return response.data['message'].toString();  
    } catch (e) {
      rethrow;
    }
  }
}

final apiInsertOrUpdateTask = Provider<InsertOrUpdateTaskApi>((ref) => InsertOrUpdateTaskApi(ref: ref));
