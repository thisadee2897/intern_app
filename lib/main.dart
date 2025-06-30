import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project/apps/app.dart';
import 'package:project/utils/services/local_storage_service.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    const lockedSize = Size(400, 720);
    setWindowTitle('My Locked Window');
    setWindowMinSize(lockedSize);
    // setWindowMaxSize(lockedSize);
  }
  final localStorageService = LocalStorageService();
  await localStorageService.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]).then((_) {
    runApp(const ProviderScope(child: App()));
  });
}
