// 📁 sprint_started_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

/// 🔸 API class สำหรับดึง Sprint เริ่มแล้วตาม project_id
class SprintStartedApi {
  final Ref ref;
  final String _path = 'project_data/get_sprint_started_by_project';

  SprintStartedApi({required this.ref});

  Future<List<SprintModel>> get({required String projectId}) async {
    try {
      final response = await ref.read(apiClientProvider).get(
            _path,
            queryParameters: {'project_id': projectId},
          );
      final datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((e) => SprintModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

/// 🔹 Provider สำหรับ Sprint API
final apiSprintStartedProvider =
    Provider<SprintStartedApi>((ref) => SprintStartedApi(ref: ref));

/// 🔸 Controller class สำหรับจัดการโหลด Sprint
final sprintStartedControllerProvider = StateNotifierProvider.family<
    SprintStartedController, AsyncValue<List<SprintModel>>, String>(
  (ref, projectId) {
    return SprintStartedController(ref: ref, projectId: projectId);
  },
);

class SprintStartedController extends StateNotifier<AsyncValue<List<SprintModel>>> {
  final Ref ref;
  final String projectId;

  SprintStartedController({required this.ref, required this.projectId})
      : super(const AsyncValue.loading());

  Future<void> fetch() async {
    try {
      final data =
          await ref.read(apiSprintStartedProvider).get(projectId: projectId);
      print('✅ Loaded ${data.length} sprints for project $projectId');
      for (var s in data) {
        print('Sprint: ${s.name}, start: ${s.satartDate}, end: ${s.endDate}');
      }
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      print('❌ Error fetching sprints: $e');
    }
  }
}
