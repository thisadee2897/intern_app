import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';

// class DeleteWorkspaceApi {
//   final Ref ref;
//   final String _path = 'master_data/delete_workspace';
//   DeleteWorkspaceApi({required this.ref});
//   Future<String> delete({required String sprintId}) async {
//     try {
//       Response response = await ref.read(apiClientProvider).delete(_path, queryParameters: {'sprint_id': sprintId});
//       return response.data;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }

// final apiDeleteWorkspace = Provider<DeleteWorkspaceApi>((ref) => DeleteWorkspaceApi(ref: ref));

class DeleteWorkspaceApi {
  final Ref ref;
  final String _path = 'master_data/delete_workspace';

  DeleteWorkspaceApi({required this.ref});

  Future<void> delete({required String id}) async {
    try {
      final response = await ref
          .read(apiClientProvider)
          .delete(_path, queryParameters: {'workspace_id': id});

      print('ลบ workspace สำเร็จ: ${response.data}');
    } on DioError catch (e) {
      print(
        'ลบ Workspace ไม่สำเร็จ: ${e.response?.statusCode} ${e.response?.data}',
      );
      rethrow;
    }
  }
}

final apiDeleteWorkspace = Provider<DeleteWorkspaceApi>(
  (ref) => DeleteWorkspaceApi(ref: ref),
);
