import 'dart:io';

import 'package:project/apis/image/delete_image.dart';
import 'package:project/apis/image/uploadimage.dart';
import 'package:project/components/export.dart';

final projectImageProvider =
    StateNotifierProvider<ProjectImageNotifier, AsyncValue<String?>>((ref) {
  return ProjectImageNotifier(ref);
});

class ProjectImageNotifier extends StateNotifier<AsyncValue<String?>> {
  final Ref ref;
  ProjectImageNotifier(this.ref) : super(const AsyncValue.data(null));

  /// อัพโหลดรูปโปรเจกต์ → return imageUrl จาก server
  Future<String> uploadProjectImage(File imageFile) async {
    try {
      state = const AsyncValue.loading();

      //  ส่งไฟล์ไป API อัปโหลด
      final imagePath = await ref.read(apiUploadImage).post(file: imageFile);

      // บันทึก url ที่ได้
      state = AsyncValue.data(imagePath);

      return imagePath;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// ลบรูปโปรเจกต์
  Future<void> deleteProjectImage(String imageUrl) async {
    if (imageUrl.isNotEmpty) {
      try {
        await ref.read(apiDeleteImage).delete(imageUrl: imageUrl);
        state = const AsyncValue.data(null);
      } catch (e, st) {
        state = AsyncValue.error(e, st);
        rethrow;
      }
    }
  }
}