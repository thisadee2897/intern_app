import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/apis/master_data/update_master_user_profile.dart';
import 'package:project/models/user_model.dart';
import 'package:project/screens/settings/profile/provider/api/profile_api.dart';
import 'package:project/apis/image/uploadimage.dart';
import 'package:project/apis/image/delete_image.dart';

enum MyProfileField { name, email, jobTitle, department, baseIn, phoneNumber, publicName }

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<UserModel>>((ref) => ProfileNotifier(ref));

class ProfileNotifier extends StateNotifier<AsyncValue<UserModel>> {
  final Ref ref;
  ProfileNotifier(this.ref) : super(AsyncValue.loading());

  Future<void> fetchProfile() async {
    state = AsyncValue.loading();
    try {
      final user = await ref.read(apiProfile).getProfile();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile() async {
    final currentUser = state.value;
    if (currentUser == null) return;
    try {
      final id = currentUser.id ?? '';
      final data = currentUser.toJson();
      print(jsonEncode(data));
      state = AsyncValue.loading();
      await ref.read(apiProfile).updateProfile(id, data);
      await fetchProfile(); // โหลดใหม่หลังอัปเดต
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void updateImageUrl(String url) {
    final currentUser = state.asData?.value;
    final updatedUser = currentUser!.copyWith(image: url);
      state = AsyncValue.data(updatedUser);
      ref.read(apiUpdateMasterUserProfile).put(body: state.asData!.value.toJson());
  }

  void updateField(MyProfileField type, String text) {
    switch (type) {
      case MyProfileField.name:
        state = AsyncValue.data(state.asData!.value.copyWith(name: text));
        break;
      case MyProfileField.email:
        state = AsyncValue.data(state.asData!.value.copyWith(email: text));
        break;
      case MyProfileField.jobTitle:
        state = AsyncValue.data(state.asData!.value.copyWith(jobTitle: text));
        break;
      case MyProfileField.department:
        state = AsyncValue.data(state.asData!.value.copyWith(department: text));
        break;
      case MyProfileField.baseIn:
        state = AsyncValue.data(state.asData!.value.copyWith(baseIn: text));
        break;
      case MyProfileField.phoneNumber:
        state = AsyncValue.data(state.asData!.value.copyWith(phoneNumber: text));
        break;
      case MyProfileField.publicName:
        state = AsyncValue.data(state.asData!.value.copyWith(publicName: text));
    }
  }
}

final profileImageProvider = StateNotifierProvider<ProfileImageNotifier, AsyncValue<String?>>((ref) {
  return ProfileImageNotifier(ref);
});

class ProfileImageNotifier extends StateNotifier<AsyncValue<String?>> {
  final Ref ref;
  ProfileImageNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> fetchProfileImage() async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(apiProfile).getProfile();
      state = AsyncValue.data(user.image);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    try {
      state = const AsyncValue.loading();
      final imagePath = await ref.read(apiUploadImage).post(file: imageFile);
      state = AsyncValue.data(imagePath);
      ref.read(profileProvider.notifier).updateImageUrl(imagePath);
    } catch (e, st) {
      print(e);
      print(st);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteProfileImage(String imageUrl) async {
    if (imageUrl.isNotEmpty) {
      try {
        await ref.read(apiDeleteImage).delete(imageUrl: imageUrl);
        ref.read(profileProvider.notifier).updateImageUrl('');
        state = const AsyncValue.data(null);
      } catch (e, st) {
        print(st);
        state = AsyncValue.error(e, st);
      }
    }
  }
}
