// 📁 task_status_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/task_status_model.dart';
import 'package:project/screens/project/project_datail/providers/apis/master_status_api.dart';

final taskStatusControllerProvider =
    StateNotifierProvider<TaskStatusController, AsyncValue<List<TaskStatusModel>>>(
  (ref) => TaskStatusController(ref),
);

class TaskStatusController extends StateNotifier<AsyncValue<List<TaskStatusModel>>> {
  final Ref ref;

  TaskStatusController(this.ref) : super(const AsyncValue.loading()) {
    fetch(); // fetch เมื่อ controller ถูกสร้าง
  }

  Future<void> fetch() async {
    try {
      final result = await ref.read(taskStatusApiProvider).getAll();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
