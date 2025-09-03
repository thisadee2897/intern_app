import 'package:flutter/material.dart';
import 'package:project/utils/extension/hex_color.dart';

extension BuildContextExtension on BuildContext {
  // primary color
  Color get primaryColor => Theme.of(this).primaryColor;
  // secondary color
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;
  // DarkBlue1
  Color get darkBlue1 => HexColor.fromHex('#001239');
  BoxDecoration get containerColor => BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: LinearGradient(
      colors: [HexColor.fromHex('#002B77'), HexColor.fromHex('#002156'), HexColor.fromHex('#001437')],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
  BoxDecoration get containerBorder =>
      BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.lightBlueAccent]), borderRadius: BorderRadius.circular(20));
}
