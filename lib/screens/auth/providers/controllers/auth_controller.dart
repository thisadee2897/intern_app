import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/user_login_model.dart';
import 'package:project/utils/services/local_storage_service.dart';
import 'package:project/utils/services/rest_api_service.dart';
import '../apis/auth_api.dart';

class LoginNotifier extends StateNotifier<AsyncValue<UserLoginModel?>> {
  LoginNotifier(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;

  Future<void> get({required String userName, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        UserLoginModel response = await ref.read(apiLogin).post(body: {"user_name": userName, "pass_word": password});
        await saveLoginData(response);
        return response;
      } catch (e) {
        rethrow;
      }
    });
    dioError(state);
  }

  Future<void> saveLoginData(UserLoginModel response) async {
    ref.read(localStorageServiceProvider).saveToken(response.accessToken!);
    await ref.read(localStorageServiceProvider).saveUserLogin(response);
    ref.invalidate(isLoggedInProvider);
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, AsyncValue<UserLoginModel?>>((ref) => LoginNotifier(ref));


final isLoggedInProvider = FutureProvider<bool>((ref) async {
  await Future.delayed(const Duration(milliseconds: 1000));
  final token = await ref.watch(localStorageServiceProvider).getToken();
  return token != null;
});

// logout Function
final logoutProvider = FutureProvider<void>((ref) async {
  await ref.watch(localStorageServiceProvider).clear();
  ref.invalidate(isLoggedInProvider);
  ref.invalidate(loginProvider);
});
