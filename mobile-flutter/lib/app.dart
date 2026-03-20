import 'package:flutter/material.dart';
import 'package:mongtory_diary/core/router/app_routes.dart';
import 'package:mongtory_diary/core/theme/app_theme.dart';
import 'package:mongtory_diary/presentation/screens/home_shell_screen.dart';
import 'package:mongtory_diary/presentation/screens/sign_in_screen.dart';
import 'package:mongtory_diary/presentation/screens/startup_screen.dart';

class MongtoryDiaryApp extends StatelessWidget {
  const MongtoryDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mongtory Diary',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.startup,
      routes: {
        AppRoutes.startup: (_) => const StartupScreen(),
        AppRoutes.signIn: (_) => const SignInScreen(),
        AppRoutes.home: (_) => const HomeShellScreen(),
      },
    );
  }
}
