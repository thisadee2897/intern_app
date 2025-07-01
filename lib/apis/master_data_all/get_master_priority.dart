import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/priority_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class MasterPriorityApi {
  final Ref ref;
  final String _path = 'master_data_all/get_master_priority';
  MasterPriorityApi({required this.ref});
  Future<List<PriorityModel>> get() async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path);
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((e) => PriorityModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiMasterPriority = Provider<MasterPriorityApi>((ref) => MasterPriorityApi(ref: ref));
