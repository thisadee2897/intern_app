import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/project_data/get_project_by_user.dart';
import 'package:project/apis/project_data/insert_or_update_project_hd.dart';
import 'package:project/apis/project_data/delete_project_hd.dart';
import 'package:project/models/project_h_d_model.dart';

/// 🔁 ตัวควบคุมการจัดการ Project (โหลด, เพิ่ม, ลบ, แก้ไข)
class ProjectController {
  final Ref ref;
  ProjectController(this.ref);

  /// 🔄 โหลดโปรเจกต์ทั้งหมด หรือเฉพาะ categoryId ที่กำหนด
  Future<List<ProjectHDModel>> getProjects({String categoryId = '0'}) async {
    return await ref.read(apiGetProjectByUser).get(categoryId: categoryId);
  }

  /// ✅ เพิ่มหรืออัปเดตโปรเจกต์ (project_id == '' แปลว่า insert)
  Future<ProjectHDModel> addOrUpdateProject(Map<String, dynamic> body) async {
    return await ref.read(apiInsertOrUpdateProjectHD).post(body: body);
  }

  /// ❌ ลบโปรเจกต์ตาม ID
  Future<void> deleteProject(String projectId) async {
    await ref.read(apiDeleteProjectHD).delete(projectHDId: projectId);
  }
}

/// ✅ Provider สำหรับ ProjectController
final projectControllerProvider = Provider<ProjectController>(
  (ref) => ProjectController(ref),
);

/// ✅ FutureProvider โหลดโปรเจกต์ทั้งหมด
final projectListProvider = FutureProvider<List<ProjectHDModel>>((ref) async {
  return await ref.read(projectControllerProvider).getProjects();
});

/// ✅ FutureProvider.family โหลดโปรเจกต์ตาม categoryId
final projectListByCategoryProvider = FutureProvider.family<List<ProjectHDModel>, String>((ref, categoryId) async {
  return await ref.read(projectControllerProvider).getProjects(categoryId: categoryId);
});
