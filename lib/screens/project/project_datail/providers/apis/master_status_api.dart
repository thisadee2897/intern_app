//master_status_api.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/task_status_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class TaskStatusApi {
  final Ref ref;
  final String _path = 'master_data_all/get_master_task_status';

  TaskStatusApi({required this.ref});

  Future<List<TaskStatusModel>> getAll() async {
    try {
      final response = await ref.read(apiClientProvider).get(_path);
      print('✅ Response: $response'); // DEBUG

      // ใช้ response.data สำหรับ dio หรือ http
      final resData = response.data;
      final List data = resData is List
          ? resData
          : (resData is Map && resData['data'] is List ? resData['data'] : []);

      return data.map((e) => TaskStatusModel.fromJson(e)).toList();
    } catch (e, stack) {
      print('❌ Error loading task statuses: $e');
      print(stack);
      return [];
    }
  }
}
