import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/workspace_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

// ✅ API เรียก workspace ทั้งหมดของ user
class GetWorkspaceByUserApi {
  final Ref ref;
  final String _path = 'master_data/get_workspace_by_user';

  GetWorkspaceByUserApi({required this.ref});

  Future<List<WorkspaceModel>> get() async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path);

      // Debug: print ดูก่อนก็ได้
      // print('API Response: ${response.data}');

      final Map<String, dynamic> rawData = response.data;

      // ดึง list จริงที่อยู่ใน key 'data'
      final List<dynamic> dataList = rawData['data'] ?? [];

      // map เป็น WorkspaceModel
      return dataList
          .map((data) => WorkspaceModel.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}

// Provider สำหรับเรียกใช้ API
final apiGetWorkspaceByUser = Provider<GetWorkspaceByUserApi>(
  (ref) => GetWorkspaceByUserApi(ref: ref),
);
