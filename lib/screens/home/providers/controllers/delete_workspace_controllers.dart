import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/home/providers/apis/delete_workspace_api.dart';

class DeleteWorkspaceController extends StateNotifier<AsyncValue<void>> {
  DeleteWorkspaceController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> deleteWorkspace({required String id}) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(apiDeleteWorkspace).delete(id: id);
      state = const AsyncValue.data(null); // ลบสำเร็จ
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final deleteWorkspaceControllerProvider = 
  StateNotifierProvider<DeleteWorkspaceController, AsyncValue<void>>(
    (ref) => DeleteWorkspaceController(ref),
  );
