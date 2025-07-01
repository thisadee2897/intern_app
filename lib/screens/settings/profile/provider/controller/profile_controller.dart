import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/user_model.dart';
import 'package:project/screens/settings/profile/provider/api/profile_api.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<UserModel>>(
        (ref) => ProfileController(ref));

class ProfileController extends StateNotifier<AsyncValue<UserModel>> {
  final Ref ref;
  ProfileController(this.ref) : super(const AsyncLoading());

  Future<void> fetchProfile() async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(apiProfile).getProfile();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    state = const AsyncLoading();
    try {
      final id = updatedUser.id ?? '';
      final data = updatedUser.toJson();
      await ref.read(apiProfile).updateProfile(id, data);
      await fetchProfile(); // โหลดใหม่หลังอัปเดต
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
