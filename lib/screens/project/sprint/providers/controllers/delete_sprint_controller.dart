import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/project/sprint/providers/apis/delete_sprint_api.dart';


class DeleteSprintController extends StateNotifier<AsyncValue<String>> {
  final Ref ref;

  DeleteSprintController(this.ref) : super(const AsyncValue.data(''));

  Future<void> deleteSprint({required String sprintId}) async {
    state = const AsyncValue.loading();
    try {
      final api = ref.read(apiDeleteSprint);
      final result = await api.delete(sprintId: sprintId);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

//  Provider ต้องใช้ lowerCamelCase ตามมาตรฐาน
final deleteSprintControllerProvider = StateNotifierProvider<DeleteSprintController, AsyncValue<String>>(
  (ref) => DeleteSprintController(ref),
);
