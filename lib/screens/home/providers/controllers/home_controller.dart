import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/master_data/get_workspace_by_user.dart';
import 'package:project/models/workspace_model.dart';


// ✅ StateNotifier สำหรับจัดการโหลดสถานะ
class WorkSpaceNotifier extends StateNotifier<AsyncValue<List<WorkspaceModel>>> {
  WorkSpaceNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchWorkspace();
  }

  final Ref ref;

  Future<void> fetchWorkspace() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final workspaces = await ref.read(apiGetWorkspaceByUser).get();
      return workspaces;
    });
  }

  void reset() {
    state = const AsyncValue.data([]);
  }
}

// ✅ Provider สำหรับเรียกใช้ในหน้าจอ
final workspaceProvider =
    StateNotifierProvider<WorkSpaceNotifier, AsyncValue<List<WorkspaceModel>>>(
  (ref) => WorkSpaceNotifier(ref),
);


