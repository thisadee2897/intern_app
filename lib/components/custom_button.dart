import 'package:flutter/material.dart';
import 'package:project/utils/extension/hex_color.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;
  final double width;

  const CustomButton({super.key, required this.onPressed, this.isLoading = false, this.text = 'เข้าสู่ระบบ', this.width = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: width,
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
          padding: EdgeInsets.symmetric(horizontal: 2),
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
                    : Text(text),
          ),
        ),
      ),
    );
  }
}