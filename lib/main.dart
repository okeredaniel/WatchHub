import 'package:flutter/material.dart';
import 'package:watchhub/app_theme.dart';
import 'package:watchhub/app_router.dart';

void main() {
  runApp(const WatchHubApp());
}

class WatchHubApp extends StatelessWidget {
  const WatchHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WatchHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRouter.welcome,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}