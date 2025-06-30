import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/auth/providers/controllers/auth_controller.dart';
import 'package:project/screens/auth/widgets/widgets.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberPassword = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLoginData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Load saved login data when widget initializes
  Future<void> _loadSavedLoginData() async {
    try {
      final loginData = await LoginPreferences.loadSavedLoginData();

      if (mounted) {
        setState(() {
          _emailController.text = loginData['email'] ?? '';
          _passwordController.text = loginData['password'] ?? '';
          _rememberPassword = loginData['rememberPassword'] ?? false;
        });
      }
    } catch (e) {
      debugPrint('Error loading login data: $e');
    }
  }

  // Email validation - ใช้ AuthValidators
  String? _validateEmail(String? value) {
    return AuthValidators.validateEmail(value);
  }

  // Password validation - ใช้ validation ที่เรียบง่ายกว่าสำหรับ login
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    }
    if (value.length < 6) {
      return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
    }
    return null;
  }

  // Handle login
  Future<void> _handleLogin() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ตัวอย่าง:
      await ref.read(loginProvider.notifier).get(userName: _emailController.text.trim(), password: _passwordController.text);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Save login data if login is successful
      await LoginPreferences.saveLoginData(email: _emailController.text.trim(), password: _passwordController.text, rememberPassword: _rememberPassword);
      // Show success message
      if (mounted) {
        _showSnackBar('เข้าสู่ระบบสำเร็จ', Colors.green);
        // context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('เข้าสู่ระบบไม่สำเร็จ: ${e.toString()}', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title for form
          Text(
            'เข้าสู่ระบบ',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[800]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Email Field
          CustomTextField(
            controller: _emailController,
            label: 'อีเมล',
            hint: 'กรุณากรอกอีเมลของคุณ',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 20),

          // Password Field
          CustomTextField(
            controller: _passwordController,
            label: 'รหัสผ่าน',
            hint: 'กรุณากรอกรหัสผ่านของคุณ',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onTogglePasswordVisibility: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            validator: _validatePassword,
          ),
          const SizedBox(height: 16),

          // Remember Password & Forgot Password Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Remember Password Checkbox
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _rememberPassword,
                      onChanged: (value) {
                        setState(() {
                          _rememberPassword = value ?? false;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rememberPassword = !_rememberPassword;
                      });
                    },
                    child: Text('จำรหัสผ่าน', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  ),
                ],
              ),

              // Forgot Password Link
              TextButton(
                onPressed: () {
                  _showSnackBar('ฟีเจอร์นี้กำลังพัฒนา', Colors.orange);
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Text('ลืมรหัสผ่าน?', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Login Button
          LoginButton(onPressed: _handleLogin, isLoading: _isLoading),
          const SizedBox(height: 24),

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300])),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('หรือ', style: TextStyle(color: Colors.grey[500], fontSize: 14))),
              Expanded(child: Divider(color: Colors.grey[300])),
            ],
          ),
          const SizedBox(height: 24),

          // Register Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ยังไม่มีบัญชี? ', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              TextButton(
                onPressed: () {
                  _showSnackBar('ฟีเจอร์สมัครสมาชิกกำลังพัฒนา', Colors.orange);
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Text('สมัครสมาชิก', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
