import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project/apps/app.dart';
import 'package:project/utils/services/local_storage_service.dart';
import 'package:project/utils/services/auto_update_manager.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  timeago.setLocaleMessages('th', timeago.ThMessages());
  timeago.setLocaleMessages('th_short', timeago.ThShortMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());
  timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
  
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    const lockedSize = Size(1024, 768);
    setWindowTitle('My Locked Window');
    setWindowMinSize(lockedSize);
    // setWindowMaxSize(lockedSize);
    
    // 🚀 Initialize Auto Update Manager
    try {
      await AutoUpdateManager().initialize();
      print('✅ Auto Update Manager initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize Auto Update Manager: $e');
    }
  }
  
  final localStorageService = LocalStorageService();
  await localStorageService.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]).then((_) {
    runApp(const ProviderScope(child: App()));
  });
}
