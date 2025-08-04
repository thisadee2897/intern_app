import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/get_sprint_dropdown_complate.dart';
import 'package:project/apis/project_data/update_sprint_to_complate.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/screens/project/project_datail/providers/apis/delete_comment_api.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';

// สถานะของการลบความคิดเห็น
class DeleteCommentTaskState {
  final bool isLoading;
  final String? message;
  final String? error;

  DeleteCommentTaskState({this.isLoading = false, this.message, this.error});

  DeleteCommentTaskState copyWith({bool? isLoading, String? message, String? error}) {
    return DeleteCommentTaskState(isLoading: isLoading ?? this.isLoading, message: message, error: error);
  }
}

// Controller สำหรับจัดการลบ comment
class DeleteCommentTaskController extends StateNotifier<DeleteCommentTaskState> {
  final DeleteCommentTaskApi api;

  DeleteCommentTaskController({required this.api}) : super(DeleteCommentTaskState());

  Future<void> deleteComment(String activityId) async {
    try {
      state = state.copyWith(isLoading: true, error: null, message: null);
      final msg = await api.delete(activityId: activityId);
      state = state.copyWith(isLoading: false, message: msg);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// รีเซ็ต state กลับเป็นค่าเริ่มต้น
  void reset() {
    state = DeleteCommentTaskState();
  }
}

final deleteCommentTaskControllerProvider = StateNotifierProvider<DeleteCommentTaskController, DeleteCommentTaskState>((ref) {
  final api = ref.watch(deleteCommentTaskApiProvider);
  return DeleteCommentTaskController(api: api);
});

// Controller สำหรับจัดการลบ comment
class DropDownSprintFormCompleteNotifier extends StateNotifier<AsyncValue<List<SprintModel>>> {
  DropDownSprintFormCompleteNotifier(this.ref) : super(const AsyncValue.loading());
  final Ref ref;
  Future<void> get() async {
    final projectId = ref.read(selectProjectIdProvider);
    if (projectId == null) {
      state = AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(apiDropDownSprintFormComplete).get(projectId: projectId);
      return response;
    });
  }
}

final dropDownSprintFormCompleteProvider = StateNotifierProvider<DropDownSprintFormCompleteNotifier, AsyncValue<List<SprintModel>>>((ref) {
  return DropDownSprintFormCompleteNotifier(ref);
});

class UpdateSprintToCompleteNotifier extends StateNotifier<AsyncValue<List<SprintModel>>> {
  UpdateSprintToCompleteNotifier(this.ref) : super(const AsyncValue.loading());
  final Ref ref;
  Future<void> updateComplete({required String sprintCompleteId, required String moveTaskToSprintId}) async {
    final projectId = ref.read(selectProjectIdProvider);
    if (projectId == null) {
      state = AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await ref
          .read(apiUpdateSprintToComplate)
          .post(body: {'sprint_complete_id': sprintCompleteId, 'move_task_to_sprint_id': moveTaskToSprintId});
      return response;
    });
  }
}

final updateSprintToCompleteProvider = StateNotifierProvider<UpdateSprintToCompleteNotifier, AsyncValue<List<SprintModel>>>((ref) {
  return UpdateSprintToCompleteNotifier(ref);
});
