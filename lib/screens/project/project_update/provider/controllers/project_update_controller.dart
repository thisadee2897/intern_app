import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/insert_or_update_project_hd.dart';
import 'package:project/models/project_h_d_model.dart';

class ProjectUpdateController extends StateNotifier<AsyncValue<ProjectHDModel>> {
  final Ref ref;

  ProjectUpdateController(this.ref) : super(const AsyncValue.data(ProjectHDModel()));

  Future<void> submitProjectHD({required Map<String, dynamic> body}) async {
    state = const AsyncValue.loading(); // กำหนดสถานะเป็น loading
    try {
      final result = await ref.read(apiInsertOrUpdateProjectHD).post(body: body);
      state = AsyncValue.data(result); // กำหนดสถานะเป็น data พร้อมผลลัพธ์
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st); // กำหนดสถานะ error พร้อม stacktrace
    }
  }
}

// ตัว provider ที่ expose controller
final projectUpdateControllerProvider = StateNotifierProvider<ProjectUpdateController, AsyncValue<ProjectHDModel>>((ref) => ProjectUpdateController(ref));
