
// import 'dart:io';

// import 'package:project/apis/image/delete_image.dart';
// import 'package:project/apis/image/uploadimage.dart';
// import 'package:project/components/export.dart';

// final workspaceImageProvider =
//     StateNotifierProvider<WorkspaceImageNotifier, AsyncValue<String?>>((ref) {
//   return WorkspaceImageNotifier(ref);
// });

// class WorkspaceImageNotifier extends StateNotifier<AsyncValue<String?>> {
//   final Ref ref;
//   WorkspaceImageNotifier(this.ref) : super(const AsyncValue.data(null));

//   /// อัพโหลดรูปโปรเจกต์ → return imageUrl จาก server
//   Future<String> uploadWorkspaceImage(File imageFile) async {
//     try {
//       state = const AsyncValue.loading();

//       //  ส่งไฟล์ไป API อัปโหลด
//       final imagePath = await ref.read(apiUploadImage).post(file: imageFile);

//       // บันทึก url ที่ได้
//       state = AsyncValue.data(imagePath);

//       return imagePath;
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//       rethrow;
//     }
//   }

//   /// ลบรูปโปรเจกต์
//   Future<void> deleteWorkspaceImage(String imageUrl) async {
//     if (imageUrl.isNotEmpty) {
//       try {
//         await ref.read(apiDeleteImage).delete(imageUrl: imageUrl);
//         state = const AsyncValue.data(null);
//       } catch (e, st) {
//         state = AsyncValue.error(e, st);
//         rethrow;
//       }
//     }
//   }
// }



import 'dart:io';
import 'package:project/apis/image/delete_image.dart';
import 'package:project/apis/image/uploadimage.dart';
import 'package:project/components/export.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workspaceImageProvider = StateNotifierProvider.family<
    WorkspaceImageNotifier, AsyncValue<String?>, String>((ref, workspaceId) {
  return WorkspaceImageNotifier(ref, workspaceId);
});

class WorkspaceImageNotifier extends StateNotifier<AsyncValue<String?>> {
  final Ref ref;
  WorkspaceImageNotifier(this.ref, this.workspaceId)
      : super(const AsyncValue.data(null));
  final String workspaceId;

  

  /// upload
  Future<String> uploadWorkspaceImage(File imageFile) async {
    try {
      state = const AsyncValue.loading();

      final imagePath = await ref.read(apiUploadImage).post(file: imageFile);

      state = AsyncValue.data(imagePath);

      return imagePath;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// delete
  Future<void> deleteWorkspaceImage(String imageUrl) async {
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
