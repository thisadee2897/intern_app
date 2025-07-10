import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class InsertOrUpdateProjectHDApi {
  final Ref ref;
  final String _path = 'project_data/insert_or_update_project_hd';

  InsertOrUpdateProjectHDApi({required this.ref});

  Future<ProjectHDModel> post({required Map<String, dynamic> body}) async {
    try {
      print('📤 Body sent to API: $body');  // Debug ส่ง body
      final response = await ref.read(apiClientProvider).post(_path, data: body);
      print('✅ API response: ${response.data}');  // Debug response

      // แปลง response เป็น Map<String, dynamic>
      final Map<String, dynamic> datas = Map<String, dynamic>.from(response.data);

      // คืนค่า ProjectHDModel ที่แปลงจาก json
      return ProjectHDModel.fromJson(datas);
    } on DioError catch (e) {
      print('❌ API exception: ${e.response?.data ?? e.message}');
      rethrow;
    } catch (e) {
      print('❌ Unknown error: $e');
      rethrow;
    }
  }
}

final aPiInsertOrUpdateProjectHD = Provider<InsertOrUpdateProjectHDApi>(
  (ref) => InsertOrUpdateProjectHDApi(ref: ref),
);
