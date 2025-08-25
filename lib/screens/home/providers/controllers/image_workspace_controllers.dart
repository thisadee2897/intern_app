
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/image/delete_image.dart';
import 'package:project/apis/image/uploadimage.dart';

final workspaceImageProvider = StateNotifierProvider.family<
  WorkspaceImageNotifier,
  AsyncValue<String?>,
  String
>((ref, workspaceId) => WorkspaceImageNotifier(ref, workspaceId));

class WorkspaceImageNotifier extends StateNotifier<AsyncValue<String?>> {
  final Ref ref;
  final String workspaceId;
  WorkspaceImageNotifier(this.ref, this.workspaceId)
    : super(const AsyncValue.data(null));
  void setInitialImage(String? imageUrl) {
    state = AsyncValue.data(imageUrl);
  }

  Future<void> uploadWorkspaceImage(File imageFile) async {
    try {
      state = const AsyncValue.loading();
      final imagePath = await ref.read(apiUploadImage).post(file: imageFile);
      state = AsyncValue.data(imagePath);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deleteWorkspaceImage() async {
    final currentImageUrl = state.value ?? '';
    if (currentImageUrl.isEmpty) return;
    try {
      debugPrint("Deleting workspace image: $currentImageUrl");

      await ref.read(apiDeleteImage).delete(imageUrl: currentImageUrl);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      debugPrint("Delete workspace image failed: $e");
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
