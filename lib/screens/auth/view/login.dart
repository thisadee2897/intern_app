import 'package:flutter/material.dart';
import 'package:project/components/export.dart';
import 'package:project/screens/auth/widgets/widgets.dart';
import 'package:project/utils/extension/hex_color.dart';

class LoginScreen extends BaseStatefulWidget {
  const LoginScreen({super.key});

  @override
  BaseState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen> {
  @override
  Widget buildDesktop(BuildContext context, SizingInformation sizingInformation) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            transform: const GradientRotation(-45),
            colors: [
              HexColor.fromHex('#011031'), 
              HexColor.fromHex('#001B4B'), 
              HexColor.fromHex('#004AAF')], 
              ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left side - Brand/Image with Abstract Background
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 400, maxWidth: 500),
                child: LoginHeader(isLarge: true)
              ),
              // Right side - Login Form with subtle background
              Container(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 400, maxWidth: 600),
                      child: FloatingCard(padding: const EdgeInsets.all(32), child: LoginForm()),
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
