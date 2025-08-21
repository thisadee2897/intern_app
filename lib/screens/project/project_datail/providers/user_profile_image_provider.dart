import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/settings/profile/provider/api/profile_api.dart';


// FutureProvider.family สำหรับดึง imageUrl จาก userId
final userProfileImageProvider = FutureProvider.autoDispose.family<String?, String?>((ref, userId) async {
  // โค้ดดึงรูปภาพ
  if (userId == null || userId.isEmpty) return null;
  try {
    final user = await ref.read(apiProfile).getUserById(userId);
    return user.image; // จะเป็น null ถ้า user ไม่มีรูป
  } catch (e) {
    // เช็คว่าเป็น 404
    if (e is DioException && e.response?.statusCode == 404) {
      print('User not found: $userId');
      return null;
    }
    rethrow;
  }
});
