import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/user_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class SearchMasterUserApi {
  final Ref ref;
  final String _path = 'master_data/search_master_user';
  SearchMasterUserApi({required this.ref});
  Future<List<UserModel>> get() async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path, queryParameters: {'search': ''});
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((data) => UserModel.fromJson(data)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiSearchMasterUser = Provider<SearchMasterUserApi>((ref) => SearchMasterUserApi(ref: ref));
