import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mongtory_diary/app.dart';
import 'package:mongtory_diary/presentation/screens/diary/diary_home_screen.dart';
import 'package:mongtory_diary/presentation/screens/sign_in_screen.dart';

void main() {
  testWidgets('startup screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MongtoryDiaryApp()));

    expect(find.text('Mongtory Diary'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });

  testWidgets('sign in screen validates required inputs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SignInScreen())),
    );

    await tester.tap(find.text('로그인'));
    await tester.pump();

    expect(find.text('이메일을 입력해주세요.'), findsOneWidget);
    expect(find.text('비밀번호를 입력해주세요.'), findsOneWidget);
  });

  testWidgets('sign in screen fills seed account', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SignInScreen())),
    );

    await tester.tap(find.text('테스트 계정 입력'));
    await tester.pump();

    final fields = tester.widgetList<TextFormField>(find.byType(TextFormField));

    expect(fields.elementAt(0).controller?.text, 'user@example.com');
    expect(fields.elementAt(1).controller?.text, 'password123!');
  });

  testWidgets('diary list opens detail screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DiaryHomeScreen())),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('오늘의 기록'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('오늘의 기록'));
    await tester.pumpAndSettle();

    expect(find.text('일기 상세'), findsOneWidget);
    expect(find.text('몽토리와 함께 산책을 했다.'), findsOneWidget);
    expect(find.text('산책'), findsWidgets);
    expect(find.text('첨부된 사진이 없습니다.'), findsOneWidget);
    expect(find.text('작성일'), findsOneWidget);
    expect(find.text('수정일'), findsOneWidget);
  });

  testWidgets('diary home search filters summaries', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DiaryHomeScreen())),
    );
    await tester.pumpAndSettle();

    expect(find.text('오늘의 기록'), findsOneWidget);
    expect(find.text('산책한 날'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '검색'), '공원');
    await tester.pumpAndSettle();

    expect(find.text('오늘의 기록'), findsNothing);
    expect(find.text('산책한 날'), findsOneWidget);
  });

  testWidgets('diary write action opens editor and validates required fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DiaryHomeScreen())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('일기 작성'), findsOneWidget);
    expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    expect(find.text('차분 (CALM)'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '태그'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.calendar_today_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsOneWidget);

    Navigator.of(tester.element(find.byType(DatePickerDialog))).pop();
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('저장'));
    await tester.pump();

    expect(find.text('제목을 입력해주세요.'), findsOneWidget);
    expect(find.text('본문을 입력해주세요.'), findsOneWidget);
  });

  testWidgets('diary editor manages image urls and confirms discard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: DiaryHomeScreen())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('사진 선택'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, '사진 URL 추가'),
      'https://example.com/photo.jpg',
    );
    await tester.ensureVisible(find.byTooltip('사진 URL 추가'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('사진 URL 추가'));
    await tester.pump();

    expect(find.text('https://example.com/photo.jpg'), findsWidgets);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('변경사항을 버릴까요?'), findsOneWidget);

    await tester.tap(find.text('계속 작성'));
    await tester.pumpAndSettle();

    expect(find.text('일기 작성'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('버리기'));
    await tester.pumpAndSettle();

    expect(find.text('오늘의 일기'), findsOneWidget);
  });
}
