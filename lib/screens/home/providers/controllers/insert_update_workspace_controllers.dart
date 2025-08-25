


import 'package:dio/dio.dart';
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
    } on DioException catch (e, st) {
  String errorMessage =
      e.response?.data['message']?.toString() ?? 'Unknown server error';
  state = AsyncValue.error(errorMessage, st);
  rethrow;
} catch (e, st) {
  state = AsyncValue.error(e, st);
  rethrow;
}

  }
  
}
