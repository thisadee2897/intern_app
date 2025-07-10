import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/master_data/get_master_workspace_role.dart';
import 'package:project/models/workspace_model.dart';

final workspaceControllerProvider = StateNotifierProvider<WorkspaceController, AsyncValue<List<WorkspaceModel>>>((ref) {
  return WorkspaceController(ref);
});

class WorkspaceController extends StateNotifier<AsyncValue<List<WorkspaceModel>>> {
  final Ref ref;

  WorkspaceController(this.ref) : super(const AsyncValue.loading());

  // ดึงข้อมูล workspace list จาก API
  Future<void> fetchWorkspaces(String workspaceId) async {
    try {
      state = const AsyncValue.loading();
      final api = ref.read(apiGetMasterWorkspaceRole);
      final workspaces = await api.get(workspaceId: workspaceId);
      state = AsyncValue.data(workspaces);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
