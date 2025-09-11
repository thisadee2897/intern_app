import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/auth/widgets/widgets.dart';
import 'package:project/screens/auth/view/register_screen.dart' show RegisterScreen;
import 'package:project/utils/extension/hex_color.dart';

final flipToRegisterProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends BaseStatefulWidget {
  const LoginScreen({super.key});

  @override
  BaseState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen> {
  @override
Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
  final showRegister = ref.watch(flipToRegisterProvider);

  return Scaffold(
    body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          transform: const GradientRotation(-45),
          colors: [
            HexColor.fromHex('#011031'),
            HexColor.fromHex('#001B4B'),
            HexColor.fromHex('#004AAF'),
          ],
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left side - Brand/Image with Abstract Background
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
              child: const LoginHeader(isLarge: true),
            ),

            // Right side - Flip Card
            Container(
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 400, maxWidth: 600),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      tween: Tween(begin: 0, end: showRegister ? 1.0 : 0.0),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        final angle = value * 3.1416; // 0 -> π
                        final isBack = angle > 3.1416 / 2;
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001) // perspective
                            ..rotateY(angle),
                          child: FloatingCard(
                            padding: const EdgeInsets.all(32),
                            child: isBack
                                ? Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()..rotateY(3.1416),
                                    child: const RegisterScreen(),
                                  )
                                : const LoginForm(),
                          ),
                        );
                      },
                    ),
                  ),
                  // const SizedBox(height: 20),
                  // // ปุ่มสลับ
                  // TextButton(
                  //   onPressed: () {
                  //     ref.read(flipToRegisterProvider.notifier).state = !showRegister;
                  //   },
                  //   child: Text(
                  //     showRegister ? "Back to Login" : "Go to Register",
                  //     style: const TextStyle(color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  @override
  Widget buildTablet(BuildContext context, SizingInformation sizingInformation) {
    return Scaffold(
      body: AbstractBackground(
        isLeftSide: false,
        child: SafeArea(
          child: Stack(
            children: [
              const AnimatedFloatingBubbles(isLeftSide: false),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Expanded(flex: 1, child: LoginHeader(isLarge: false)),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Column(children: [SizedBox(width: 400, child: FloatingCard(padding: const EdgeInsets.all(24), child: LoginForm()))]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildMobile(BuildContext context, SizingInformation sizingInformation) {
    return Scaffold(
      body: AbstractBackground(
        isLeftSide: false,
        child: SafeArea(
          child: Stack(
            children: [
              const AnimatedFloatingBubbles(isLeftSide: false),
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [const SizedBox(height: 40), const LoginHeader(isLarge: false), const SizedBox(height: 40), FloatingCard(child: LoginForm())],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
