import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final flipToRegisterProvider = StateProvider<bool>((ref) => false);

class LoginRegisterFlip extends ConsumerWidget {
  const LoginRegisterFlip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showRegister = ref.watch(flipToRegisterProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF011031), Color(0xFF001B4B), Color(0xFF004AAF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              ref.read(flipToRegisterProvider.notifier).state = !showRegister;
            },
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0, end: showRegister ? 1 : 0),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                final angle = value * pi;
                final isBack = angle > pi / 2;

                return Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // perspective
                        ..rotateY(angle),
                  child:
                      isBack
                          ? Transform(alignment: Alignment.center, transform: Matrix4.identity()..rotateY(pi), child: const RegisterForm())
                          : const LoginForm(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white,
      child: SizedBox(width: 300, height: 400, child: Center(child: Text("Login Form", style: Theme.of(context).textTheme.headlineSmall))),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white,
      child: SizedBox(width: 300, height: 400, child: Center(child: Text("Register Form", style: Theme.of(context).textTheme.headlineSmall))),
    );
  }
}
