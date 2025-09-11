import 'dart:async';
import 'package:project/components/export.dart';
import 'package:project/screens/auth/providers/apis/check_email_for_register.dart';

class ValidateEmailNotifier extends StateNotifier<AsyncValue<int>> {
  ValidateEmailNotifier(this.ref) : super(const AsyncValue.data(0));
  final Ref ref;
  Future<void> get({required String email}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        int response = await ref.read(apiCheckEmailForRegister).get(email: email);
        return response;
      } catch (e) {
        rethrow;
      }
    });
  }
}

final validateEmailProvider = StateNotifierProvider<ValidateEmailNotifier, AsyncValue<int>>((ref) => ValidateEmailNotifier(ref));
final countEmailProvider = StateProvider<int>((ref) => ref.watch(validateEmailProvider).maybeWhen(data: (data) => data, orElse: () => 0));
final validateEmailTimer2SecondProvider = Provider<Function(void Function())>((ref) {
  Timer? _debounce;
  return (void Function() callback) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), callback);
  };
});

