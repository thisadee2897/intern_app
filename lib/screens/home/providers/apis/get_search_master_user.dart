
import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/user_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class GetSearchMasterUser {
  final Ref ref;
  final String _path = 'master_data/search_master_user';
  GetSearchMasterUser({required this.ref});

Future<List<UserModel>> get({String keyword = ''}) async {
  try {
    Response response = await ref.read(apiClientProvider).get(
      _path,
      queryParameters: {'search': keyword}, 
      // ถ้าไม่ส่ง keyword = ค่าว่าง
    );

     // Debug print raw response จาก server
    print("✅Response.data: ${response.data}");

    List<Map<String, dynamic>> datas =
        List<Map<String, dynamic>>.from(response.data);

      // Debug print หลังแปลงเป็น UserModel
    final users = datas.map((data) => UserModel.fromJson(data)).toList();
    print("✅Parsed Users: $users");

    return datas.map((data) => UserModel.fromJson(data)).toList();
  } catch (e) {
    rethrow;
  }
}
}
final apiGetSearchMasterUser = Provider<GetSearchMasterUser>((ref) => GetSearchMasterUser(ref: ref));


