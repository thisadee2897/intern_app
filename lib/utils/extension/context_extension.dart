import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  // primary color
  Color get primaryColor => Theme.of(this).primaryColor;
}