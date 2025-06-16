import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project/apps/app.dart';

void main() async {
  // setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]).then((_) {
    runApp(const ProviderScope(child: App()));
  });
}
