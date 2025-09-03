import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/home/providers/apis/delete_workspace_role_api.dart';

final deleteWorkspaceRoleController =
    StateNotifierProvider<DeleteWorkspaceRoleNotifier, AsyncValue<bool>>(
      (ref) => DeleteWorkspaceRoleNotifier(ref),
    );

class DeleteWorkspaceRoleNotifier extends StateNotifier<AsyncValue<bool>> {
  final Ref ref;
  DeleteWorkspaceRoleNotifier(this.ref) : super(const AsyncValue.data(false));

  Future<bool> delete(String workspaceId, String userId) async {
    state = const AsyncValue.loading();
    try {
      debugPrint("🔄 Start deleting user from workspace...");
      debugPrint("   workspace_id: $workspaceId");
      debugPrint("   user_id: $userId");

      final success = await ref
          .read(apiDeleteWorkspaceRoleApi)
          .delete(workspaceId: workspaceId, userId: userId);

      debugPrint("✅ Controller delete result: $success");
      debugPrint("✅ API call finished: $success");

      state = AsyncValue.data(success);
      return success;
    } catch (e, st) {
      debugPrint("❌ Controller delete error: $e");
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
