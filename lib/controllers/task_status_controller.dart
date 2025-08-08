import 'package:project/apis/master_data_all/get_master_task_status.dart';
import 'package:project/components/export.dart';
import 'package:project/models/task_status_model.dart';


final listTaskStatusProvider = StateNotifierProvider<ListTaskStatusNotifier, AsyncValue<List<TaskStatusModel>>>((ref) => ListTaskStatusNotifier(ref));

class ListTaskStatusNotifier extends StateNotifier<AsyncValue<List<TaskStatusModel>>> {
  final Ref ref;
  ListTaskStatusNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> get() async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(apiMasterTaskStatus).get();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final dropdownListTaskStatusProvider = Provider<List<String>>((ref) {
  final listTaskStatus = ref.watch(listTaskStatusProvider);
  return listTaskStatus.when(
    data: (data) => data.map((e) => e.name ?? '').toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});
