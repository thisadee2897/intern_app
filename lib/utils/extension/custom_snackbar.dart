import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

export 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class CustomSnackbar {
  static void showSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
    Duration duration = const Duration(seconds: 3),
    required MaterialColor color,
  }) {
    final overlay = Overlay.of(context);
    

    late OverlayEntry entry;
    final controller = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 300),
    );

    final animation = Tween<Offset>(
      begin: const Offset(0, -1), // เริ่มนอกจอด้านบน
      end: Offset.zero, // มาที่ตำแหน่งปกติ
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40, // ระยะห่างจากขอบบน
        left: MediaQuery.of(context).size.width * 0.05,  // ขอบซ้าย 5%
        right: MediaQuery.of(context).size.width * 0.05, // ขอบขวา 5%
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: animation,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9, // กว้าง 90% ของจอ
              ),
              child: AwesomeSnackbarContent(
                title: title,
                message: message,
                contentType: contentType,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    controller.forward();

    Future.delayed(duration, () async {
      await controller.reverse();
      entry.remove();
      controller.dispose();
    });
  }
}
