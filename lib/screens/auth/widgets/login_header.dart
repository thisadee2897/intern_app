import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final bool isLarge;

  const LoginHeader({super.key, required this.isLarge});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo
        Container(
          width: isLarge ? 120 : 80,
          height: isLarge ? 120 : 80,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            // border: isLarge
            //     ? Border.all(color: Colors.white.withOpacity(0.3), width: 2)
            //     : null,
          ),
          child: Icon(Icons.account_circle_outlined, size: isLarge ? 60 : 40, color: Theme.of(context).primaryColor),
        ),
        SizedBox(height: isLarge ? 24 : 16),

        // Title
        Text('ยินดีต้อนรับ', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: isLarge ? 32 : 24)),
        SizedBox(height: isLarge ? 8 : 4),

        // Subtitle
        Text(
          'เข้าสู่ระบบเพื่อดำเนินการต่อ',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600], fontSize: isLarge ? 16 : 14),
          textAlign: TextAlign.center,
        ),
        if (isLarge) AspectRatio(aspectRatio: 1.5, child: Image.asset(scale: 1, 'assets/images/login_image.png', fit: BoxFit.fitHeight)),
      ],
    );
  }
}
