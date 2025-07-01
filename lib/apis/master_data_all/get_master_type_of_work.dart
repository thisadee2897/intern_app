import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/type_of_work_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class MasterTypeOfWorkApi {
  final Ref ref;
  final String _path = 'master_data_all/get_master_type_of_work';
  MasterTypeOfWorkApi({required this.ref});
  Future<List<TypeOfWorkModel>> get() async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path);
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((e) => TypeOfWorkModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiMasterTypeOfWork = Provider<MasterTypeOfWorkApi>((ref) => MasterTypeOfWorkApi(ref: ref));
