import 'package:project/components/export.dart';
import 'package:project/models/user_role_model.dart';
import 'package:project/screens/home/providers/apis/insert_or_update_workspace_role.dart';

final insertOrUpdateWorkspaceRoleController =
    StateNotifierProvider<InsertOrUpdateWorkspaceRoleNotifier,
        AsyncValue<UserRoleModel?>>(
  (ref) => InsertOrUpdateWorkspaceRoleNotifier(ref),
);

class InsertOrUpdateWorkspaceRoleNotifier
    extends StateNotifier<AsyncValue<UserRoleModel?>> {
  final Ref ref;
  InsertOrUpdateWorkspaceRoleNotifier(this.ref)
      : super(const AsyncValue.data(null));


  Future<bool> saveRole(Map<String, dynamic> body) async {
    state = const AsyncValue.loading();
    try {
      final result =
          await ref.read(apiInsertOrUpdateWorkspaceRoleApi).post(body: body);
      state = AsyncValue.data(result);
      return true;
    } catch (e, st) {
      print("Error saveRole: $e"); // Debug print
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

