import 'package:project/apis/master_data/search_master_user.dart';
import 'package:project/components/export.dart';
import 'package:project/models/user_model.dart';

final listAssignProvider = StateNotifierProvider<ListAssignNotifier, AsyncValue<List<UserModel>>>((ref) => ListAssignNotifier(ref));

class ListAssignNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final Ref ref;
  ListAssignNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> get() async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(apiSearchMasterUser).get();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}


final dropdownListAssignProvider = Provider<List<String>>((ref) {
  final listAssign = ref.watch(listAssignProvider);
  return listAssign.when(
    data: (data) => data.map((e) => e.name ?? '').toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});