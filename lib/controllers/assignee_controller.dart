import 'package:project/components/export.dart';
import 'package:project/models/user_model.dart';
import 'package:project/models/user_role_model.dart';
import 'package:project/screens/home/providers/apis/get_workspace_role_by_workspace.dart';
import 'package:project/screens/project/sprint/providers/controllers/sprint_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:project/screens/project/project_datail/providers/apis/project_api.dart';

final listAssignProvider = StateNotifierProvider<ListAssignNotifier, AsyncValue<List<UserModel>>>((ref) => ListAssignNotifier(ref));

class ListAssignNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final Ref ref;
  ListAssignNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> get() async {
    state = const AsyncValue.loading();
    try {
      // 1) อ่าน workspaceId จาก selectWorkspaceIdProvider เป็นหลัก
      String? workspaceId = ref.read(selectWorkspaceIdProvider);
      if (workspaceId == null || workspaceId.isEmpty) {
        // 2) หา workspaceId จากโปรเจคที่ถูกเลือกอยู่ (ผ่าน category.workspaceId)
        var project = ref.read(projectSelectingProvider);
        workspaceId = project.category?.workspaceId;

        // 3) Fallback: ถ้า workspaceId ว่าง ลองดึงจาก project_id ที่เลือกอยู่
        if (workspaceId == null || workspaceId.isEmpty) {
          final projectId = ref.read(selectProjectIdProvider);
          debugPrint('[Assignee] Fallback หา workspaceId จาก project_id=$projectId');
          if (projectId != null && projectId.isNotEmpty) {
            final projects = await ref.read(apiProject).getProjects(params: {'project_id': projectId});
            if (projects.isNotEmpty) {
              project = projects.first;
              workspaceId = project.category?.workspaceId;
              debugPrint('[Assignee] Fallback workspaceId=$workspaceId');
            }
          }
        }
      }

      if (workspaceId == null || workspaceId.isEmpty) {
        debugPrint('[Assignee] workspaceId ว่าง - โปรดตรวจว่าตั้งค่า selectWorkspaceIdProvider หรือ project.category?.workspaceId แล้วหรือยัง');
        state = const AsyncValue.data([]);
        return;
      }

      debugPrint('[Assignee] โหลดรายชื่อผู้ใช้ด้วย workspace_id=$workspaceId');
      final roles = await ref.read(apiGetWorkspaceRoleByWorkspaceApi).get(workspaceId);
      final users = roles
          .map((UserRoleModel r) => r.masterUser)
          .where((u) => u != null)
          .cast<UserModel>()
          .toList();

      debugPrint('[Assignee] ได้ผู้ใช้ตามสิทธิ์ใน workspace ${users.length} คน');
      state = AsyncValue.data(users);
    } catch (e, st) {
      debugPrint('[Assignee] โหลดรายชื่อผู้ใช้ล้มเหลว: $e');
      state = AsyncValue.error(e, st);
    }
  }
}

final dropdownListAssignProvider = Provider<List<String>>((ref) {
  final listAssign = ref.watch(listAssignProvider);
  return listAssign.when(
    data: (data) {
      final labels = data
          .map((e) => e.publicName?.trim().isNotEmpty == true
              ? e.publicName!.trim()
              : (e.name?.trim().isNotEmpty == true
                  ? e.name!.trim()
                  : (e.email ?? '').trim()))
          .where((label) => label.isNotEmpty)
          .toList();
      debugPrint('[Assignee] dropdown labels: ${labels.length} รายการ');
      return labels;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});