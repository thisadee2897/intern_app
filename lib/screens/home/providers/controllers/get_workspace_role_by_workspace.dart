import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/user_role_model.dart';
import 'package:project/screens/home/providers/apis/get_workspace_role_by_workspace.dart';

class GetWorkspaceRoleByWorkspaceNotifier
    extends StateNotifier<AsyncValue<List<UserRoleModel>>> {
  final Ref ref;

  GetWorkspaceRoleByWorkspaceNotifier(this.ref)
      : super(const AsyncValue.loading());

  /// โหลดข้อมูล workspace role ตาม workspace
  Future<void> fetch(String workspaceId) async {
    state = const AsyncValue.loading();
    try {
      final api = ref.read(apiGetWorkspaceRoleByWorkspaceApi);
      final result = await api.get(workspaceId);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final getWorkspaceRoleByWorkspaceController = StateNotifierProvider<
    GetWorkspaceRoleByWorkspaceNotifier,
    AsyncValue<List<UserRoleModel>>>(
  (ref) => GetWorkspaceRoleByWorkspaceNotifier(ref),
);


