import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/application/session/session_state.dart';
import 'package:mongtory_diary/core/router/app_routes.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(sessionControllerProvider, (previous, next) {
      if (next.status == SessionStatus.signedIn) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        return;
      }

      if (next.status == SessionStatus.failure && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    final sessionState = ref.watch(sessionControllerProvider);
    final dataSourceModeLabel = ref.watch(dataSourceModeLabelProvider);
    final apiBaseUrl = ref.watch(apiBaseUrlProvider);
    final isLoading = sessionState.status == SessionStatus.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mongtory Diary 시작',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '초기 MVP에서는 이메일 또는 소셜 로그인 진입점을 이 화면에 배치합니다.',
            ),
            const SizedBox(height: 12),
            Text(
              '현재 데이터 소스: $dataSourceModeLabel',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (dataSourceModeLabel == 'remote') ...[
              const SizedBox(height: 4),
              Text(
                'API: $apiBaseUrl',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                await ref.read(sessionControllerProvider.notifier).signIn(
                      email: 'user@example.com',
                      password: 'password123!',
                    );
              },
              child: Text(isLoading ? '로그인 중...' : '임시 로그인으로 계속'),
            ),
            if (sessionState.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                sessionState.errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
