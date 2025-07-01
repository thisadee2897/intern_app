import 'package:dio/dio.dart';
import 'package:project/components/export.dart';
import 'package:project/models/task_status_model.dart';
import 'package:project/utils/services/rest_api_service.dart';

class MasterTaskStatusApi {
  final Ref ref;
  final String _path = 'master_data_all/get_master_task_status';
  MasterTaskStatusApi({required this.ref});
  Future<List<TaskStatusModel>> get() async {
    try {
      Response response = await ref.read(apiClientProvider).get(_path);
      List<Map<String, dynamic>> datas = List<Map<String, dynamic>>.from(response.data);
      return datas.map((e) => TaskStatusModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final apiMasterTaskStatus = Provider<MasterTaskStatusApi>((ref) => MasterTaskStatusApi(ref: ref));
