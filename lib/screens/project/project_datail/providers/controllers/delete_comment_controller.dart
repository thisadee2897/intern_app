import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/project/project_datail/providers/apis/delete_comment_api.dart';

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
}

final deleteCommentTaskControllerProvider = StateNotifierProvider<DeleteCommentTaskController, DeleteCommentTaskState>((ref) {
  final api = ref.watch(deleteCommentTaskApiProvider);
  return DeleteCommentTaskController(api: api);
});
