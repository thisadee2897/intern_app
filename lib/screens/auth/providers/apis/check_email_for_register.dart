import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/utils/services/rest_api_service.dart';
class CheckEmailForRegisterAPI {
  final Ref ref;
  final String _path = 'master_data/check_email_for_register';
  CheckEmailForRegisterAPI({required this.ref});
  Future<int> get({required String email}) async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'email': email});
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

final apiCheckEmailForRegister = Provider<CheckEmailForRegisterAPI>((ref) => CheckEmailForRegisterAPI(ref: ref));
