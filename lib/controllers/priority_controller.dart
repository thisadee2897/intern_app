import 'package:project/apis/master_data_all/get_master_priority.dart';
import 'package:project/components/export.dart';
import 'package:project/models/priority_model.dart';
final listPriorityProvider = StateNotifierProvider<ListPriorityNotifier, AsyncValue<List<PriorityModel>>>((ref) => ListPriorityNotifier(ref));

class ListPriorityNotifier extends StateNotifier<AsyncValue<List<PriorityModel>>> {
  final Ref ref;
  ListPriorityNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> get() async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(apiMasterPriority).get();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}