import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/get_sprint_by_project.dart';
import 'package:project/apis/master_data/insert_or_update_sprint.dart';
import 'package:project/models/sprint_model.dart';

class SprintNotifier extends StateNotifier<AsyncValue<List<SprintModel>>> {
  SprintNotifier(this.ref) : super(const AsyncValue.loading());
  final Ref ref;
  Future<void> get() async {
    String? id = ref.read(selectProjectIdProvider);
    if (id == null) {
      return;
    } else {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        List<SprintModel> response = await ref.read(apiSprintByProject).get(projectId: id);
        return response;
      });
    }
  }
}

class InsertUpdateSprintNotifier extends StateNotifier<AsyncValue<SprintModel?>> {
  InsertUpdateSprintNotifier(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;

  Future<void> insertOrUpdateSprint({
    required String id, // "0" for insert, actual id for update
    required String name,
    required int duration,
    required String goal,
    required String projectHdId,
    required String hdId,
  }) async {
    state = const AsyncValue.loading();

    try {
      final body = {
        "id": id,
        "name": name,
        "duration": duration,
        "start_date": null,
        "end_date": null,
        "goal": goal,
        "completed": false,
        "project_hd_id": projectHdId,
        "active": true,
        "startting": false,
        "hd_id": projectHdId,
      };

      final result = await ref.read(apiInsertOrUpdateSprint).post(body: body);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {}
  }

  void clearState() {
    state = const AsyncValue.data(null);
  }
}

final sprintProvider = StateNotifierProvider<SprintNotifier, AsyncValue<List<SprintModel>>>((ref) => SprintNotifier(ref));
final insertUpdateSprintProvider = StateNotifierProvider<InsertUpdateSprintNotifier, AsyncValue<SprintModel?>>((ref) => InsertUpdateSprintNotifier(ref));
final selectProjectIdProvider = StateProvider<String?>((ref) => null);
