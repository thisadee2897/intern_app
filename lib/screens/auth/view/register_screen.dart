import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/auth/providers/controllers/check_email_for_register_controller.dart';
import 'package:project/screens/auth/providers/controllers/register_user_contoller.dart';
import 'package:project/screens/auth/view/login.dart';
import 'package:project/screens/auth/widgets/auth_validators.dart';
import 'package:project/screens/auth/widgets/custom_text_field.dart';
import 'package:project/screens/auth/widgets/login_button.dart';
import 'package:project/utils/extension/hex_color.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      ref.read(textEmailRegisterProvider.notifier).state = '';
      ref.read(textPasswordRegisterProvider.notifier).state = '';
      ref.read(textConfirmPasswordRegisterProvider.notifier).state = '';
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Email validation - ใช้ AuthValidators
  String? _validateEmail(String? value) {
    // return AuthValidators.validateEmail(value);
    final emailError = AuthValidators.validateEmail(value);
    if (emailError == null) {
      var text = ref
          .watch(validateEmailProvider)
          .when(
            data: (data) {
              if (data == 0) {
                return null;
              } else if (data > 0) {
                return 'อีเมลนี้ถูกใช้งานแล้ว';
              } else {
                return null;
              }
            },
            loading: () => null,
            error: (error, stack) => 'เกิดข้อผิดพลาดในการตรวจสอบอีเมล',
          );
      // ref.read(textErrorProvider.notifier).state = text;
      return text;
    } else {
      // ref.read(textErrorProvider.notifier).state = emailError;
      return emailError;
    }
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(registerProvider.notifier).get(email: emailController.text, password: passwordController.text);
      if (ref.read(registerProvider).maybeWhen(data: (data) => data, orElse: () => false)) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('สมัครสมาชิกสำเร็จ! กรุณาเข้าสู่ระบบด้วยอีเมลและรหัสผ่านของคุณ'), backgroundColor: Colors.green));
          ref.read(flipToRegisterProvider.notifier).state = false;
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('สมัครสมาชิกไม่สำเร็จ กรุณาลองใหม่อีกครั้ง'), backgroundColor: Colors.red));
        }
      }
    } else {
      // Validation failed, you can show an error message if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final showRegister = ref.watch(flipToRegisterProvider);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'สมัครสมาชิก',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w400, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          // const SizedBox(height: 32),
          // Email Field
          CustomTextField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: emailController,
            label: 'อีเมล',
            hint: 'อีเมล',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            onChanged: (value) {
              ref.read(validateEmailTimer2SecondProvider)((() {
                ref.read(textEmailRegisterProvider.notifier).state = value;
                ref.read(validateEmailProvider.notifier).get(email: value);
              }));
            },
            suffix:
                _validateEmail(emailController.text) == null
                    ? ref
                        .watch(validateEmailProvider)
                        .when(
                          data: (data) {
                            if (data == 0) {
                              return Icon(Icons.check_circle, color: Colors.green);
                            } else if (data > 0) {
                              return Icon(Icons.error, color: Colors.red);
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                          loading: () => SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                          error: (error, stack) => SizedBox.shrink(),
                        )
                    : null,
          ),
          SizedBox(height: 20.0),
          // Password Field
          CustomTextField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: passwordController,
            label: 'รหัสผ่าน',
            hint: 'รหัสผ่าน',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            onChanged: (p0) {
              ref.read(textPasswordRegisterProvider.notifier).state = p0;
            },
            validator: (value) => AuthValidators.validatePassword(value),
          ),
          SizedBox(height: 20.0),
          // Confirm Password Field
          CustomTextField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: confirmPasswordController,
            label: 'ยืนยันรหัสผ่าน',
            hint: 'ยืนยันรหัสผ่าน',
            onChanged: (p0) {
              ref.read(textConfirmPasswordRegisterProvider.notifier).state = p0;
            },
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณายืนยันรหัสผ่าน';
              }
              if (value != passwordController.text) {
                return 'รหัสผ่านไม่ตรงกัน';
              }
              return null;
            },
          ),
          SizedBox(height: 24.0),
          // Register Button
          LoginButton(
            isLoading: ref.watch(registerProvider).isLoading,
            disabled: ref.watch(checkPasswordRegisterProvider) == false,
            onPressed: _handleRegister,
            text: 'สมัครสมาชิก',
          ),
          const SizedBox(height: 24),
          // Divider
          Row(
            children: [
              Expanded(child: Container(height: 3, decoration: BoxDecoration(color: HexColor.fromHex('#002B77'), borderRadius: BorderRadius.circular(20)))),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('หรือ', style: TextStyle(color: Colors.white, fontSize: 14))),
              Expanded(child: Container(height: 3, decoration: BoxDecoration(color: HexColor.fromHex('#002B77'), borderRadius: BorderRadius.circular(20)))),
            ],
          ),
          const SizedBox(height: 24),
          // Login Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('มีบัญชีอยู่แล้ว? ', style: TextStyle(color: Colors.white, fontSize: 14)),
              TextButton(
                onPressed: () {
                  // _showSnackBar('ฟีเจอร์สมัครสมาชิกกำลังพัฒนา', Colors.orange);
                  ref.read(flipToRegisterProvider.notifier).state = !showRegister;
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Text('เข้าสู่ระบบ', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
