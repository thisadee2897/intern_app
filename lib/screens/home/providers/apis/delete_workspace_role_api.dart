import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';

class DeleteWorkspaceRoleApi {
  final Ref ref;
  final String _path = 'master_data/delete_workspace_role';

  DeleteWorkspaceRoleApi({required this.ref});

  Future<bool> delete({
    required String workspaceId,
    required String userId,
  }) async {
    try {
      debugPrint(" Calling DELETE API...");
      debugPrint("   workspace_id: $workspaceId");
      debugPrint("   user_id: $userId");

      final response = await ref
          .read(apiClientProvider)
          .delete(
            _path,
            queryParameters: {'workspace_id': workspaceId, 'user_id': userId},
          );

      debugPrint("✅ Delete response status: ${response.statusCode}");
      debugPrint("✅ Delete response data: ${response.data}");

      
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint("❌ Dio error: ${e.message}");
      debugPrint("❌ Dio response: ${e.response?.data}");
      return false;
    } catch (e) {
      debugPrint("❌ Unexpected error: $e");
      return false;
    }
  }
}

final apiDeleteWorkspaceRoleApi = Provider<DeleteWorkspaceRoleApi>(
  (ref) => DeleteWorkspaceRoleApi(ref: ref),
);
