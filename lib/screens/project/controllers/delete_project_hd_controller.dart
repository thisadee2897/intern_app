import 'package:project/apis/project_data/delete_project_hd.dart';
import 'package:riverpod/riverpod.dart';

class DeleteProjectHDController extends StateNotifier<AsyncValue<String>> {
  final Ref ref;
  DeleteProjectHDController(this.ref) : super(const AsyncValue.data(''));

  Future<void> deleteProjectHD(String projectHDId) async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(apiDeleteProjectHD).delete(
            projectHDId: projectHDId,
          );
      state = AsyncValue.data(result);

    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
final deleteProjectHDControllerProvider = StateNotifierProvider<DeleteProjectHDController, AsyncValue<String>>((ref) => DeleteProjectHDController(ref),
);