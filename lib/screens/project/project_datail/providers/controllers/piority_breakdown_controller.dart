
import 'package:project/apis/project_data/priority_breakdown.dart';
import 'package:project/components/export.dart';
import 'package:project/models/priority_model.dart';

class PiorityBreakdownController extends StateNotifier<AsyncValue<List<PriorityModel>>> {
  final Ref ref;
  PiorityBreakdownController(this.ref) : super(const AsyncValue.loading());
  Future<void> getData() async {
    try {
      final result = await ref.read(apiPriorityBreakdown).get();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final piorityBreakdownProvider = StateNotifierProvider<PiorityBreakdownController, AsyncValue<List<PriorityModel>>>((ref) => PiorityBreakdownController(ref));