import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/qa_app_harness.dart';

void main() {
  testWidgets('QA harness signs in and renders diary summary', (tester) async {
    await pumpQaApp(tester);

    await qaSignInWithSeedAccount(tester);

    expect(find.text('오늘의 일기'), findsOneWidget);
    expect(find.text('QA 자동화 일기'), findsOneWidget);
    expect(find.textContaining('mock 데이터 소스 기준 1건'), findsOneWidget);
  });

  testWidgets('QA harness renders calendar and profile tabs', (tester) async {
    await pumpQaApp(tester);
    await qaSignInWithSeedAccount(tester);

    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();

    expect(find.text('월간 캘린더'), findsOneWidget);
    expect(find.text('2026-03-20'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.face_outlined));
    await tester.pumpAndSettle();

    expect(find.text('현재 사용자'), findsOneWidget);
    expect(find.text('이메일: user@example.com'), findsOneWidget);
    expect(find.textContaining('감정 타입 2건'), findsOneWidget);
  });

  testWidgets('QA harness surfaces sign in failures', (tester) async {
    await pumpQaApp(
      tester,
      harness: QaAppHarness(
        authRepository: QaAuthRepository.failure('QA 로그인 실패'),
      ),
    );

    await tester.tap(find.text('시작하기'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'user@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong-password');
    await tester.tap(find.text('로그인'));
    await tester.pumpAndSettle();

    expect(find.text('QA 로그인 실패'), findsWidgets);
  });
}
