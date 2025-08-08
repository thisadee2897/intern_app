import 'package:project/apis/master_data_all/get_master_type_of_work.dart';
import 'package:project/components/export.dart';
import 'package:project/models/type_of_work_model.dart';

final listTypeOfWorkProvider = StateNotifierProvider<ListTypeOfWorkNotifier, AsyncValue<List<TypeOfWorkModel>>>((ref) => ListTypeOfWorkNotifier(ref));

class ListTypeOfWorkNotifier extends StateNotifier<AsyncValue<List<TypeOfWorkModel>>> {
  final Ref ref;
  ListTypeOfWorkNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> get() async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(apiMasterTypeOfWork).get();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final dropdownListTypeOfWorkProvider = Provider<List<String>>((ref) {
  final listTypeOfWork = ref.watch(listTypeOfWorkProvider);
  return listTypeOfWork.when(
    data: (data) => data.map((e) => e.name ?? '').toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});