import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/insert_comment_task.dart';

class InsertCommentTaskController extends StateNotifier<AsyncValue<String?>> {
  InsertCommentTaskController(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;

  Future<void> submit({required Map<String, dynamic> body}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final message = await ref.read(apiInsertCommentTask).post(body: body);
      return message;
    });

    // Handle error globally if needed (e.g., dioError(state))
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final insertCommentTaskControllerProvider =
    StateNotifierProvider<InsertCommentTaskController, AsyncValue<String?>>(
  (ref) => InsertCommentTaskController(ref),
);
