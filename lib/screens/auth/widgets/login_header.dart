import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final bool isLarge;

  const LoginHeader({super.key, required this.isLarge});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: isLarge ? 24 : 16,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLarge) AspectRatio(aspectRatio: 2, child: Image.asset(scale: 1, 'assets/icons/OHO-Task-IconOnly.png', fit: BoxFit.fitHeight)),
        // SizedBox(height: isLarge ? 24 : 16),
        // Title
        Text(
          'ยินดีต้อนรับ',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: isLarge ? 64 : 48, color: Colors.white),
        ),
        // SizedBox(height: isLarge ? 8 : 4),
        // Subtitle
        Text(
          'เข้าสู่ระบบเพื่อดำเนินการต่อ',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontSize: isLarge ? 32 : 28),
          textAlign: TextAlign.center,
        ),
        if (isLarge)
          SizedBox(
            width: isLarge ? 400 : 200,
            height: isLarge ? 200 : 100,
            child: Image.asset(scale: 1, 'assets/icons/OHO-Task-TextOnly.png', fit: BoxFit.fitHeight),
          ),
      ],
    );
  }
}
