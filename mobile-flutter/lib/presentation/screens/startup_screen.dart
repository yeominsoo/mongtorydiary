import 'package:flutter/material.dart';
import 'package:mongtory_diary/core/router/app_routes.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 64,
                color: Color(0xFFE4947C),
              ),
              const SizedBox(height: 20),
              Text(
                'Mongtory Diary',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Flutter 기반 모바일 앱 초기화가 완료되었습니다.\n다음 단계는 인증, 일기 CRUD, 캘린더 구조 설계입니다.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
                },
                child: const Text('시작하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
