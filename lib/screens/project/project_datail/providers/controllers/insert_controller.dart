// 📁 insert_or_update_task_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/insert_or_update_task.dart';
import 'package:project/components/export.dart';

class InsertOrUpdateTaskController extends StateNotifier<AsyncValue<String>> {
  final Ref ref;

  InsertOrUpdateTaskController(this.ref) : super(const AsyncValue.data(''));

  Future<void> submit({required Map<String, dynamic> body}) async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(apiInsertOrUpdateTask).post(body: body);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final insertOrUpdateTaskControllerProvider = StateNotifierProvider<
    InsertOrUpdateTaskController, AsyncValue<String>>((ref) {
  return InsertOrUpdateTaskController(ref);
});
