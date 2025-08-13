import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/get_back_log.dart';
import 'package:project/apis/master_data/insert_or_update_sprint.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/models/task_model.dart';
import 'package:project/models/task_status_model.dart';
import 'package:project/screens/project/sprint/providers/apis/delete_sprint_api.dart';

import '../../../project_datail/providers/controllers/task_detail_controller.dart';
import '../../../project_datail/views/widgets/backlog_widget.dart';

// -------------------  SprintNotifier -------------------
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
        List<SprintModel> response = await ref.read(apiBacklog).get(projectId: id);
        return response;
      });
    }
  }

  Future<void> getWithOutLoading() async {
    String? id = ref.read(selectProjectIdProvider);
    if (id == null) {
      return;
    } else {
      state = await AsyncValue.guard(() async {
        List<SprintModel> response = await ref.read(apiBacklog).get(projectId: id);
        return response;
      });
    }
  }

  Future<void> updateStatusTask(TaskStatusModel model, TaskModel item) async {
    try {
      // String? id = ref.read(selectProjectIdProvider);
      // state = await AsyncValue.guard(() async {
      //   List<SprintModel> response = await ref.read(apiBacklog).get(projectId: id!);
      //   return response;
      // });
      state = AsyncValue.data(
        state.valueOrNull?.map((sprint) {
              if (sprint.tasks.any((task) => task.id == item.id)) {
                return sprint.copyWith(
                  tasks:
                      sprint.tasks.map((task) {
                        if (task.id == item.id) {
                          return task.copyWith(taskStatus: model);
                        }
                        return task;
                      }).toList(),
                );
              }
              return sprint;
            }).toList() ??
            [],
      );
      var detail = ref.read(taskDetailProvider);
      if (detail.hasValue && detail.value?.id == item.id) {
        ref.read(taskDetailProvider.notifier).updateTaskStatus(model);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  //  เพิ่ม delete method
  Future<void> delete(String sprintId) async {
    try {
      // เรียก API ลบ
      await ref.read(apiDeleteSprint).delete(sprintId: sprintId);

      // ลบจาก state local ด้วย
      state.whenData((list) {
        final updatedList = list.where((sprint) => sprint.id != sprintId).toList();
        state = AsyncValue.data(updatedList);
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // updateTaskById
  Future<void> updateTaskById(TaskModel updatedTask) async {
    try {
      state = AsyncValue.data(
        state.valueOrNull?.map((sprint) {
              if (sprint.tasks.any((task) => task.id == updatedTask.id)) {
                return sprint.copyWith(
                  tasks:
                      sprint.tasks.map((task) {
                        if (task.id == updatedTask.id) {
                          return updatedTask;
                        }
                        return task;
                      }).toList(),
                );
              }
              return sprint;
            }).toList() ??
            [],
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// -------------------  Insert/Update Notifier -------------------
class InsertUpdateSprintNotifier extends StateNotifier<AsyncValue<SprintModel>> {
  InsertUpdateSprintNotifier(this.ref) : super(AsyncValue.data(SprintModel(id: '0', active: true, completed: false, duration: 0)));
  final Ref ref;

  Future<SprintModel?> insertOrUpdateSprint() async {
    if (state.hasValue) {
      SprintModel item = state.value!;
      try {
        final body = {
          "id": item.id,
          "name": item.name,
          "duration": item.duration,
          "start_date": item.satartDate,
          "end_date": item.endDate,
          "goal": item.goal,
          "completed": item.completed ?? false,
          "project_hd_id": ref.read(selectProjectIdProvider)!,
          "active": item.active ?? true,
          "startting": item.startting ?? false,
          "hd_id": ref.read(selectProjectIdProvider)!,
        };

        final result = await ref.read(apiInsertOrUpdateSprint).post(body: body);
        state = AsyncValue.data(result);
        return result;
      } catch (e, st) {
        state = AsyncValue.error(e, st);
        return null;
      }
    } else {
      return null;
    }
  }

  // Start Sprint
  Future<void> startSprint(String id, String? goal, String name) async {
    state = const AsyncValue.loading();
    try {
      DateTime? startDate = ref.read(formStartDateProvider);
      DateTime? endDate = ref.read(formEndDateProvider);
      int duration = endDate!.difference(startDate!).inDays;
      final body = {
        "id": id,
        "name": name,
        "duration": duration,
        "start_date": startDate.toString(),
        "end_date": endDate.toString(),
        "goal": goal,
        "hd_id": ref.read(selectProjectIdProvider),
        "project_hd_id": ref.read(selectProjectIdProvider),
        "startting": true,
      };
      print(jsonEncode(body));
      final result = await ref.read(apiInsertOrUpdateSprint).post(body: body);
      state = AsyncValue.data(result);
    } catch (e) {
      rethrow;
    }
  }

  void updateActiveStatus(bool isActive) {
    if (state.hasValue) {
      state = AsyncData(state.value!.copyWith(active: isActive));
    }
  }

  //updateName
  void updateName(String name) {
    if (state.hasValue) {
      state = AsyncData(state.value!.copyWith(name: name));
    }
  }

  //updateGoal
  void updateGoal(String goal) {
    if (state.hasValue) {
      state = AsyncData(state.value!.copyWith(goal: goal));
    }
  }

  //updateStartDate
  void updateStartDate(DateTime startDate) {
    if (state.hasValue) {
      state = AsyncData(state.value!.copyWith(satartDate: startDate.toString()));
    }
  }

  //updateEndDate
  void updateEndDate(DateTime endDate) {
    if (state.hasValue) {
      state = AsyncData(state.value!.copyWith(endDate: endDate.toString()));
    }
  }
  //setItem
  void setItem(SprintModel item) {
    state = AsyncValue.data(item);
  }

  void clearState() {
    state = const AsyncValue.data(SprintModel(id: '0', active: true, completed: false, duration: 0));
  }
}

// -------------------  Providers -------------------
final sprintProvider = StateNotifierProvider<SprintNotifier, AsyncValue<List<SprintModel>>>((ref) => SprintNotifier(ref));

final insertUpdateSprintProvider = StateNotifierProvider<InsertUpdateSprintNotifier, AsyncValue<SprintModel>>((ref) => InsertUpdateSprintNotifier(ref));

final selectProjectIdProvider = StateProvider<String?>((ref) => null); //  Provider สำหรับเลือก Project ID

final projectSelectingProvider = StateProvider<ProjectHDModel>((ref) => ProjectHDModel());
final sprintSelectingProvider = StateProvider<SprintModel>((ref) => SprintModel());

// final apiDeleteSprint = Provider((ref) => DeleteSprintApi()); //  Provider สำหรับ API ลบ
final apiDeleteSprint = Provider<DeleteSprintApi>((ref) => DeleteSprintApi(ref: ref));
