import 'package:project/apis/project_data/recent_activity.dart';
import 'package:project/components/export.dart';
import 'package:project/models/comment_model.dart';

class RecentActivityController extends StateNotifier<AsyncValue<List<CommentModel>>> {
  final Ref ref;
  RecentActivityController(this.ref) : super(const AsyncValue.loading());
  Future<void> getData() async {
    try {
      final result = await ref.read(apiRecentActivity).get();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final recentActivityProvider = StateNotifierProvider<RecentActivityController, AsyncValue<List<CommentModel>>>((ref) => RecentActivityController(ref));
