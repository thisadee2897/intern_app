import 'package:dio/dio.dart';
import 'package:project/utils/services/rest_api_service.dart';
import 'package:project/models/workspace_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkSpaceAPI {
  final Ref ref;
  final String _path = 'master_data/get_workspace_by_user';
  WorkSpaceAPI({required this.ref});

  Future<List<WorkspaceModel>> fetch() async {
    try {
      final response = await ref.read(apiClientProvider).get(_path);
      if (response.data is List) {
        // ถ้า API ส่งข้อมูลเป็น List
        return (response.data as List)
            .map((item) => WorkspaceModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.data is Map<String, dynamic>) {
        // ถ้า API ส่งข้อมูลเป็น Map เดียว
        return [WorkspaceModel.fromJson(response.data as Map<String, dynamic>)];
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      rethrow;
    }
  }
}

// Provider สำหรับ WorkSpaceAPI
final apiWorkSpace = Provider<WorkSpaceAPI>((ref) => WorkSpaceAPI(ref: ref));