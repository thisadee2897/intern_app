import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/user_login_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class LoginAPI {
  final Ref ref;
  final String _path = 'security/login';
  LoginAPI({required this.ref});
  Future<UserLoginModel> post({required Map<String, dynamic> body}) async {
    try {
      Response response = await ref.read(apiClientProvider).post(_path, data: body);
      Map<String, dynamic> datas = Map<String, dynamic>.from(response.data);
      return UserLoginModel.fromJson(datas);
    } catch (e) {
      rethrow;
    }
  }
}

final apiLogin = Provider<LoginAPI>((ref) => LoginAPI(ref: ref));
