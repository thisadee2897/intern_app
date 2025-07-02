import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/user_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class UpdateMasterUserProfileApi {
  final Ref ref;
  final String _path = 'master_data/update_master_user_profile';
  UpdateMasterUserProfileApi({required this.ref});
  Future<UserModel> put({required Map<String,dynamic> body}) async {
    try {
      Response response = await ref.read(apiClientProvider).put(_path,data: body);
      Map<String, dynamic> datas = Map<String, dynamic>.from(response.data);
      return UserModel.fromJson(datas);
    } catch (e) {
      rethrow;
    }
  }
}

final apiUpdateMasterUserProfile = Provider<UpdateMasterUserProfileApi>((ref) => UpdateMasterUserProfileApi(ref: ref));
