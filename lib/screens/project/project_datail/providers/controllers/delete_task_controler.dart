import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/delete_task.dart';


final deleteTaskControllerProvider =
    StateNotifierProvider<DeleteTaskController, AsyncValue<String>>(
  (ref) => DeleteTaskController(ref),
);

class DeleteTaskController extends StateNotifier<AsyncValue<String>> {
  final Ref ref;
  DeleteTaskController(this.ref) : super(const AsyncValue.data(''));

  Future<void> deleteTask(String taskId) async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(apiDeleteTask).delete(taskId: taskId);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
