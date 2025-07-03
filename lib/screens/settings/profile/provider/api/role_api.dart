import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/user_role_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class RoleApi {
  final Ref ref;
  final String _path = 'master_data/get_master_workspace_role';

  RoleApi({required this.ref});

  Future<List<UserRoleModel>> getRoles() async {
    final dio = ref.read(apiClientProvider); // ✅ ใช้ apiClientProvider ของคุณ
    final response = await dio.get(_path); // ใช้ path ตรง ๆ เพราะ baseUrl ถูกตั้งไว้แล้ว
    return (response.data as List).map((e) => UserRoleModel.fromJson(e)).toList();
  }
}
