import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/activity_type_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class MasterActivityTypeApi {
  final Ref ref;
  final String _path = 'master_data_all/get_master_activity_type';
  MasterActivityTypeApi({required this.ref});
  Future<List<ActivityTypeModel>> get() async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path);
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((e) => ActivityTypeModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiMasterActivityType = Provider<MasterActivityTypeApi>((ref) => MasterActivityTypeApi(ref: ref));
