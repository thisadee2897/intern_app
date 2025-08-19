// 📁 task_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/task_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

/// 🔸 API class สำหรับดึง Task ตาม project_id
class TaskBySprintApi {
  final Ref ref;
  final String _path = 'project_data/get_task_by_sprint_started'; // เปลี่ยน path ตรงนี้ได้ตาม API ใหม่

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
final apiTaskBySprintProvider =
    Provider<TaskBySprintApi>((ref) => TaskBySprintApi(ref: ref));

/// 🔸 Controller class สำหรับจัดการโหลด Task
final taskBySprintControllerProvider = StateNotifierProvider.family<
    TaskBySprintController, AsyncValue<List<TaskModel>>, String>((ref, projectId) {
  return TaskBySprintController(ref: ref, projectId: projectId);
});

class TaskBySprintController extends StateNotifier<AsyncValue<List<TaskModel>>> {
  final Ref ref;
  final String projectId;

  TaskBySprintController({required this.ref, required this.projectId})
      : super(const AsyncValue.loading());

  Future<void> fetch() async {
    try {
      final data = await ref.read(apiTaskBySprintProvider).get(projectId: projectId);
      print('✅ Loaded ${data.length} tasks for project $projectId');
      for (var t in data) {
        print('Task: ${t.name}, status: ${t.taskStatus?.id}');
      }
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      print('❌ Error fetching tasks: $e');
    }
  }
}