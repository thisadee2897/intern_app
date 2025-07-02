import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class ProjectApi {
  final Ref ref;
  final String _path = 'project_data/get_project_by_user';
  ProjectApi({required this.ref});

  Future<List<ProjectHDModel>> getProjects({Map<String, dynamic>? params}) async {
    final response = await ref.read(apiClientProvider).get(_path, queryParameters: params);
    // ตรวจสอบว่า response.data เป็น List หรือ Map
    final data = response.data is List
        ? response.data
        : (response.data['data'] ?? []);
    List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(data);
    return datas.map((e) => ProjectHDModel.fromJson(e)).toList();
  }
}

final apiProject = Provider<ProjectApi>((ref) => ProjectApi(ref: ref));
