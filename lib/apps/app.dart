import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/config/routes/app_router.dart';
import 'package:project/config/theme/app_theme.dart';
class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    final appRouter = ref.read(appRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      title: 'Printer',
      // localizationsDelegates: const [Trans.delegate],
      // supportedLocales: Trans.delegate.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
