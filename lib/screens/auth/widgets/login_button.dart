import 'package:flutter/material.dart';
import 'package:project/utils/extension/hex_color.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const LoginButton({super.key, required this.onPressed, this.isLoading = false, this.text = 'เข้าสู่ระบบ'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero, // ต้องใช้ Ink เพื่อให้ gradient เต็ม
          backgroundColor: Colors.transparent, // ทำพื้นหลังโปร่งใส
          shadowColor: Colors.transparent, // ไม่มีเงา
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18), // มุมโค้งมน
          ),
        ),
        child: Ink(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [HexColor.fromHex('#004EF7'), HexColor.fromHex('#0033A2')], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child:
                isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                    : Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
