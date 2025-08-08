import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/get_comment_api.dart';

import 'package:project/apis/project_data/get_project_category_unique_name.dart';
import 'package:project/apis/project_data/get_task_detail.dart';
import 'package:project/models/comment_model.dart';
import 'package:project/models/priority_model.dart';
import 'package:project/models/task_model.dart';
import 'package:project/models/task_status_model.dart';
import 'package:project/models/type_of_work_model.dart';
import 'package:project/models/user_model.dart';

final taskDetailProvider = StateNotifierProvider<TaskDetailNotifier, AsyncValue<TaskModel>>((ref) => TaskDetailNotifier(ref));

class TaskDetailNotifier extends StateNotifier<AsyncValue<TaskModel>> {
  final Ref ref;
  TaskDetailNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> getTaskDetail(String id) async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(apiTaskDetail).get(taskId: id);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Update Type of Work
  Future<void> updateTypeOfWork(TypeOfWorkModel item) async {
    try {
      final currentData = state.valueOrNull;
      if (currentData != null) {
        final updatedData = currentData.copyWith(typeOfWork: item);
        state = AsyncValue.data(updatedData);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Update Task Status
  Future<void> updateTaskStatus(TaskStatusModel item) async {
    try {
      final currentData = state.valueOrNull;
      if (currentData != null) {
        final updatedData = currentData.copyWith(taskStatus: item);
        state = AsyncValue.data(updatedData);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Update Assignee
  Future<void> updateAssignee(UserModel item) async {
    try {
      final currentData = state.valueOrNull;
      if (currentData != null) {
        final updatedData = currentData.copyWith(assignedTo: item);
        state = AsyncValue.data(updatedData);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  // Update Priority
  Future<void> updatePriority(PriorityModel item) async {
    try {
      final currentData = state.valueOrNull;
      if (currentData != null) {
        final updatedData = currentData.copyWith(priority: item);
        state = AsyncValue.data(updatedData);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final commentTaskProvider = StateNotifierProvider<CommentTaskNotifier, AsyncValue<List<CommentModel>>>((ref) => CommentTaskNotifier(ref));

class CommentTaskNotifier extends StateNotifier<AsyncValue<List<CommentModel>>> {
  final Ref ref;
  CommentTaskNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> getCommentTask(String id) async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(apiGetCommentTaskProvider).get(taskId: id);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Validation and state management for category name input
final categoryNameProvider = StateProvider<String>((ref) => '');
final categoryNameErrorProvider = StateProvider<String?>((ref) => null);

final checkTextCategoryUniqueNameProvider = FutureProvider.autoDispose<void>((ref) async {
  final name = ref.watch(categoryNameProvider);
  if (name.isEmpty) {
    ref.read(categoryNameErrorProvider.notifier).state = 'ห้ามเว้นว่าง';
  } else {
    final response = await ref.read(apiProjectCategoryUniqueName).get(testSearch: name);
    ref.read(categoryNameErrorProvider.notifier).state = response.isEmpty ? null : 'ชื่อหมวดหมู่นี้ถูกใช้แล้ว';
  }
});
