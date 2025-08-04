// 📁 task_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/task_model.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'package:project/utils/services/rest_api_service.dart';

/// 🔸 API class สำหรับดึง Task ตาม project_id
class TaskBySprintApi {
  final Ref ref;
  final String _path = 'project_data/get_task_by_sprint';

  TaskBySprintApi({required this.ref});

  Future<List<TaskModel>> get({required String projectId}) async {
    try {
      final response = await ref.read(apiClientProvider).get(_path, queryParameters: {'project_id': projectId});
      final datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((e) => TaskModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

/// 🔹 Provider สำหรับ Task API
final apiTaskBySprintProvider = Provider<TaskBySprintApi>((ref) => TaskBySprintApi(ref: ref));

/// 🔸 Controller class สำหรับจัดการโหลด Task
class TaskBySprintController extends StateNotifier<AsyncValue<List<TaskModel>>> {
  final Ref ref;
  final String projectId;

  TaskBySprintController({required this.ref, required this.projectId}) : super(const AsyncValue.loading()) {
    fetch(); // ✅ แก้ไข: เรียก fetch ใน constructor อย่างปลอดภัย
  }

  /// โหลด Task และ return กลับ List TaskModel
  Future<void> fetch() async {
    String? projectHDId = ref.read(selectProjectIdProvider);
    if (projectHDId == null) {
      return;
    }
    try {
      final data = await ref.read(apiTaskBySprintProvider).get(projectId: projectHDId);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// ✅ Provider แบบ family ที่สามารถส่ง projectId เข้าไปได้
final taskBySprintControllerProvider = StateNotifierProvider.family<TaskBySprintController, AsyncValue<List<TaskModel>>, String>(
  (ref, projectId) => TaskBySprintController(ref: ref, projectId: projectId),
);
