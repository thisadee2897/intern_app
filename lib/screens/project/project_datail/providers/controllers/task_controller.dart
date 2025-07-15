//task_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/task_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

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

final apiTaskBySprintProvider = Provider<TaskBySprintApi>(
  (ref) => TaskBySprintApi(ref: ref),
);

class TaskBySprintController extends StateNotifier<AsyncValue<List<TaskModel>>> {
  final Ref ref;

  TaskBySprintController(this.ref) : super(const AsyncValue.loading());

  Future<void> getTaskBySprint(String projectId) async {
    try {
      state = const AsyncValue.loading();
      final data = await ref.read(apiTaskBySprintProvider).get(projectId: projectId);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// **แก้ไข:** ให้ provider สร้าง controller เปล่า ๆ โดยไม่เรียกโหลดข้อมูล
final taskBySprintControllerProvider = StateNotifierProvider.family<
    TaskBySprintController, AsyncValue<List<TaskModel>>, String>((ref, projectId) {
  return TaskBySprintController(ref);
});
