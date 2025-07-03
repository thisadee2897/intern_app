// role_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/user_role_model.dart';
import 'package:project/screens/settings/profile/provider/api/Role_api.dart'; // ปรับ path ให้ตรงกับ model

/// Provider สำหรับโหลด role ทั้งหมดจาก API
final roleControllerProvider = FutureProvider<List<UserRoleModel>>((ref) async {
  final api = RoleApi(ref: ref); // สร้าง instance ของ RoleApi
  return await api.getRoles();   // เรียกเมธอด getRoles() จาก role_api.dart
});
