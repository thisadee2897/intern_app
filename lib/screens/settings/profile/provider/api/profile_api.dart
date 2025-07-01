import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/user_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class ProfileApi {
  // เพิ่มเมธอดสำหรับอัปเดต user profile
  Future<void> updateProfile(String id, Map<String, dynamic> body) async {
    try {
      // สมมติ endpoint PUT ตามมาตรฐาน RESTful
      await ref.read(apiClientProvider).put('master_data/update_master_user_profile', data: body);
    } catch (e) {
      rethrow;
    }
  }
  final Ref ref;
  ProfileApi({required this.ref});

  Future<UserModel> getProfile() async {
    try {
      Response response = await ref.read(apiClientProvider).get('master_data/get_master_user_profile');
      Map<String, dynamic> datas = Map<String, dynamic>.from(response.data);
      return UserModel.fromJson(datas);
    } catch (e) {
      rethrow;
    }
  }
}

final apiProfile = Provider<ProfileApi>((ref) => ProfileApi(ref: ref));
