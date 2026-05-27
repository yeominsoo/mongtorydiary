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
                '오늘의 일정, TODO, 감정 일기를 한 화면에서 정리하세요.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.5),
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
