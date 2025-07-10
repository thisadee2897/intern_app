import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/delete_project_hd.dart';

final deleteProjectHDControllerProvider = StateNotifierProvider<DeleteProjectHDController, AsyncValue<String>>(
  (ref) => DeleteProjectHDController(ref),
);

class DeleteProjectHDController extends StateNotifier<AsyncValue<String>> {
  final Ref ref;

  DeleteProjectHDController(this.ref) : super(const AsyncValue.data(""));

  Future<void> deleteProject(String projectHDId) async {
    state = const AsyncValue.loading();
    try {
      final result = await ref.read(apiDeleteProjectHD).delete(projectHDId: projectHDId);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
