// // insert_update_workspace_controller.dart

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:project/models/workspace_model.dart';
// import 'package:project/screens/home/providers/apis/insert_update_workspace_api.dart';

// /// Provider สำหรับ controller
// final insertOrUpdateWorkspaceControllerProvider =
//     AsyncNotifierProvider<InsertOrUpdateWorkspaceController, WorkspaceModel?>(
//   InsertOrUpdateWorkspaceController.new,
// );

// /// Controller สำหรับ insert หรือ update workspace
// class InsertOrUpdateWorkspaceController
//     extends AsyncNotifier<WorkspaceModel?> {
//   late final InsertOrUpdateWorkspaceApi _api;

//   @override
//   Future<WorkspaceModel?> build() async {
//     _api = ref.read(apiInsertOrUpdateWorkspace);
//     return null; // เริ่มต้นยังไม่มีข้อมูล
//   }

//   /// เรียกใช้ API สำหรับ insert หรือ update
//   Future<bool> submitWorkspace(Map<String, dynamic> data) async {
//     state = const AsyncLoading();
//     try {
//       final result = await _api.post(body: data);
//       state = AsyncData(result);
//       return true;
//     } catch (e, st) {
//       state = AsyncError(e, st);
//       return false;
//     }
//   }

//   /// สำหรับ reset state เป็นค่าเริ่มต้น
//   void reset() {
//     state = const AsyncData(null);
//   }
// }
// // insert_update_workspace_controller.dart

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:project/models/workspace_model.dart';
// import 'package:project/screens/home/providers/apis/insert_update_workspace_api.dart';

// /// Provider สำหรับ controller
// final insertOrUpdateWorkspaceControllerProvider =
//     AsyncNotifierProvider<InsertOrUpdateWorkspaceController, WorkspaceModel?>(
//   InsertOrUpdateWorkspaceController.new,
// );

// /// Controller สำหรับ insert หรือ update workspace
// class InsertOrUpdateWorkspaceController
//     extends AsyncNotifier<WorkspaceModel?> {
//   late final InsertOrUpdateWorkspaceApi _api;

//   @override
//   Future<WorkspaceModel?> build() async {
//     _api = ref.read(apiInsertOrUpdateWorkspace);
//     return null; // เริ่มต้นยังไม่มีข้อมูล
//   }

//   /// เรียกใช้ API สำหรับ insert หรือ update
//   Future<bool> submitWorkspace(Map<String, dynamic> data) async {
//     state = const AsyncLoading();
//     try {
//       final result = await _api.post(body: data);
//       state = AsyncData(result);
//       return true;
//     } catch (e, st) {
//       state = AsyncError(e, st);
//       return false;
//     }
//   }

//   /// สำหรับ reset state เป็นค่าเริ่มต้น
//   void reset() {
//     state = const AsyncData(null);
//   }
// }



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/screens/home/providers/apis/insert_update_workspace_api.dart';

final insertUpdateWorkspaceControllerProvider = StateNotifierProvider<
  InsertUpdateWorkspaceController,
  AsyncValue<WorkspaceModel?>
>((ref) => InsertUpdateWorkspaceController(ref));

class InsertUpdateWorkspaceController
    extends StateNotifier<AsyncValue<WorkspaceModel?>> {
  final Ref ref;
  InsertUpdateWorkspaceController(this.ref)
    : super(const AsyncValue.data(null));

  Future<WorkspaceModel> insertOrUpdateWorkspace({
    required String id,
    required String name,
    required bool active,
    String? image,
  }) async {
    state = const AsyncValue.loading();
    try {
      final workspace = await ref
          .read(apiInsertOrUpdateWorkspace)
          .post(
            body: {
              'id': id,
              'name': name.trim(),
              'active': active,
              'image': image ?? '',
            },
          )
          .timeout(const Duration(seconds: 10));
      state = AsyncValue.data(workspace);
      return workspace;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
  
}
