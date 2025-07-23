// 📁 task_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/task_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

/// 🔸 API class สำหรับดึง Task ตาม project_id
class TaskBySprintApi {
  final Ref ref;
  final String _path = 'project_data/get_task_by_sprint';

  TaskBySprintApi({required this.ref});

  Future<List<TaskModel>> get({required String projectId}) async {
    try {
      final response = await ref.read(apiClientProvider).get(
        _path,
        queryParameters: {'project_id': projectId},
      );
      final datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((e) => TaskModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

/// 🔹 Provider สำหรับ Task API
final apiTaskBySprintProvider = Provider<TaskBySprintApi>(
  (ref) => TaskBySprintApi(ref: ref),
);

/// 🔸 Controller class สำหรับจัดการโหลด Task
class TaskBySprintController extends StateNotifier<AsyncValue<List<TaskModel>>> {
  final Ref ref;

  TaskBySprintController(this.ref) : super(const AsyncValue.loading());

  /// ✅ โหลด Task และ return กลับ List<TaskModel>
  Future<List<TaskModel>> getTaskBySprint(String projectId) async {
    try {
      state = const AsyncValue.loading();
      final data = await ref.read(apiTaskBySprintProvider).get(projectId: projectId);
      state = AsyncValue.data(data);
      return data;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return [];
    }
  }
}

/// ✅ Provider แบบ family ที่สามารถส่ง projectId เข้าไปได้
final taskBySprintControllerProvider = StateNotifierProvider.family<
    TaskBySprintController, AsyncValue<List<TaskModel>>, String>(
  (ref, projectId) => TaskBySprintController(ref),
);
