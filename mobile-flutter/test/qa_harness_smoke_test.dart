import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mongtory_diary/domain/models/calendar_day_summary.dart';
import 'package:mongtory_diary/domain/models/calendar_month.dart';

import 'support/qa_app_harness.dart';

void main() {
  testWidgets('QA harness signs in and renders calendar command center', (
    tester,
  ) async {
    await pumpQaApp(tester);

    await qaSignInWithSeedAccount(tester);

    expect(find.text('몽토리 캘린더'), findsOneWidget);
    expect(find.text('오늘의 일정판'), findsOneWidget);
    expect(find.text('2026년 3월'), findsWidgets);
    expect(find.text('월'), findsWidgets);
    expect(find.text('주'), findsOneWidget);
    expect(find.text('일정'), findsOneWidget);
  });

  testWidgets('QA harness renders calendar and profile tabs', (tester) async {
    await pumpQaApp(tester);
    await qaSignInWithSeedAccount(tester);

    expect(find.text('몽토리 캘린더'), findsOneWidget);
    expect(find.text('2026년 3월'), findsWidgets);
    expect(find.text('TODO 완료'), findsOneWidget);
    expect(find.text('20'), findsWidgets);

    await tester.ensureVisible(find.text('20').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('20').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('QA TODO 확인'));
    await tester.pumpAndSettle();

    expect(find.text('2026년 3월 20일 금요일'), findsOneWidget);
    expect(find.text('QA TODO 확인'), findsOneWidget);
    expect(find.text('QA 자동화 일기'), findsWidgets);

    await tester.tap(find.text('QA 자동화 일기').last);
    await tester.pumpAndSettle();

    expect(find.text('일기 상세'), findsOneWidget);
    expect(find.text('하네스 검증용 일기입니다.'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.face_outlined));
    await tester.pumpAndSettle();

    expect(find.text('몽토리 컨디션'), findsOneWidget);
    expect(find.text('이메일: user@example.com'), findsOneWidget);

    expect(find.text('성장 기록'), findsOneWidget);
    expect(find.text('작성 리마인더'), findsOneWidget);
    expect(find.text('감정 팔레트'), findsNothing);
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

  testWidgets('QA harness opens dated create flow from empty calendar date', (
    tester,
  ) async {
    await pumpQaApp(
      tester,
      harness: QaAppHarness(
        calendarRepository: QaCalendarRepository(
          month: CalendarMonth(
            year: 2026,
            month: 3,
            days: [
              CalendarDaySummary(
                date: DateTime(2026, 3, 22),
                hasEntry: false,
                entryCount: 0,
              ),
            ],
          ),
        ),
      ),
    );
    await qaSignInWithSeedAccount(tester);

    await tester.tap(find.text('캘린더'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('22').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('22').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('등록된 TODO가 없습니다.'));
    await tester.pumpAndSettle();

    expect(find.text('2026년 3월 22일 일요일'), findsOneWidget);
    expect(find.text('이 날짜에 작성된 일기가 없습니다.'), findsOneWidget);
    expect(find.text('등록된 TODO가 없습니다.'), findsOneWidget);

    await tester.ensureVisible(find.text('작성'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('작성'));
    await tester.pumpAndSettle();

    expect(find.text('일기 작성'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '2026-03-22'), findsOneWidget);
  });

  testWidgets('QA harness adds and completes calendar todo', (tester) async {
    await pumpQaApp(tester);
    await qaSignInWithSeedAccount(tester);

    await tester.tap(find.text('캘린더'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.widgetWithText(TextField, 'TODO 추가'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'TODO 추가'),
      '새 QA TODO',
    );
    await tester.tap(find.text('추가'));
    await tester.pumpAndSettle();

    expect(find.text('새 QA TODO'), findsOneWidget);
    expect(find.textContaining('TODO 1/3'), findsOneWidget);

    await tester.tap(find.widgetWithText(CheckboxListTile, '새 QA TODO'));
    await tester.pumpAndSettle();

    expect(find.textContaining('TODO 2/3'), findsOneWidget);
  });

  testWidgets('QA harness covers diary create update and delete', (
    tester,
  ) async {
    await pumpQaApp(tester);
    await qaSignInWithSeedAccount(tester);

    await tester.tap(find.text('일기').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('일기 작성'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), 'CRUD 작성 일기');
    await tester.enterText(find.byType(TextFormField).at(2), '생성 회귀 검증 본문입니다.');
    expect(find.text('평온 (CALM)'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('저장'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(find.text('CRUD 작성 일기'), findsOneWidget);

    await tester.ensureVisible(find.text('CRUD 작성 일기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CRUD 작성 일기'));
    await tester.pumpAndSettle();

    expect(find.text('일기 상세'), findsOneWidget);
    expect(find.text('생성 회귀 검증 본문입니다.'), findsOneWidget);

    await tester.tap(find.text('수정'));
    await tester.pumpAndSettle();

    expect(find.text('일기 수정'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), 'CRUD 수정 일기');
    await tester.enterText(find.byType(TextFormField).at(2), '수정 회귀 검증 본문입니다.');
    await tester.enterText(find.widgetWithText(TextFormField, '태그'), 'QA, 수정');
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('저장'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(find.text('CRUD 수정 일기'), findsOneWidget);
    expect(find.text('수정 회귀 검증 본문입니다.'), findsOneWidget);
    expect(find.text('수정'), findsWidgets);

    await tester.tap(find.text('삭제'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('삭제').last);
    await tester.pumpAndSettle();

    expect(find.text('오늘의 일기'), findsOneWidget);
    expect(find.text('CRUD 수정 일기'), findsNothing);
  });
}
