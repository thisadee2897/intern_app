import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/user_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class GetMasterUserProfileApi {
  final Ref ref;
  final String _path = 'master_data/get_master_user_profile';
  GetMasterUserProfileApi({required this.ref});
  Future<UserModel> get() async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path);
      Map<String, dynamic> datas = Map<String, dynamic>.from(response.data);
      return UserModel.fromJson(datas);
    } catch (e) {
      rethrow;
    }
  }
}

final apiGetMasterUserProfile = Provider<GetMasterUserProfileApi>((ref) => GetMasterUserProfileApi(ref: ref));
