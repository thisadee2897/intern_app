import 'package:project/components/export.dart';
import 'package:project/screens/auth/providers/apis/register_user_api.dart';
class RegisterNotifier extends StateNotifier<AsyncValue<bool>> {
  RegisterNotifier(this.ref) : super(const AsyncValue.data(false));
  final Ref ref;
  Future<void> get({required String email, required String password}) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 2));
    state = const AsyncValue.data(true);
    state = await AsyncValue.guard(() async {
      try {
        bool response = await ref
            .read(apiRegisterUser)
            .post(body: {"email": email, "password": password});
        return response;
      } catch (e) {
        rethrow;
      }
    });
  }
}

final registerProvider = StateNotifierProvider<RegisterNotifier, AsyncValue<bool>>((ref) => RegisterNotifier(ref));
final textEmailRegisterProvider = StateProvider<String>((ref) => '');
final textPasswordRegisterProvider = StateProvider<String>((ref) => '');
final textConfirmPasswordRegisterProvider = StateProvider<String>((ref) => '');

// Validate Password and Confirm Password
final checkPasswordRegisterProvider = Provider<bool>((ref) {
  // final countEmail = ref.watch(countEmailProvider);
  final password = ref.watch(textPasswordRegisterProvider);
  final confirmPassword = ref.watch(textConfirmPasswordRegisterProvider);
  // print('countEmail: $countEmail, password: $password, confirmPassword: $confirmPassword');
  if (password.isEmpty || confirmPassword.isEmpty) {
    return false;
  } else {
    return password == confirmPassword;
  }
});



final passwordVisibleRegisterProvider = StateProvider<bool>((ref) => false);
final confirmPasswordVisibleRegisterProvider = StateProvider<bool>((ref) => false);