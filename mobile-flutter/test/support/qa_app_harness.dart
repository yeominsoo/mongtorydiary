import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mongtory_diary/app.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/core/config/app_config.dart';
import 'package:mongtory_diary/core/network/api_exception.dart';
import 'package:mongtory_diary/domain/models/auth_session.dart';
import 'package:mongtory_diary/domain/models/calendar_day_summary.dart';
import 'package:mongtory_diary/domain/models/calendar_month.dart';
import 'package:mongtory_diary/domain/models/diary_detail.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/domain/models/diary_upsert.dart';
import 'package:mongtory_diary/domain/models/emotion_type.dart';
import 'package:mongtory_diary/domain/models/user_profile.dart';
import 'package:mongtory_diary/domain/repositories/auth_repository.dart';
import 'package:mongtory_diary/domain/repositories/calendar_repository.dart';
import 'package:mongtory_diary/domain/repositories/diary_repository.dart';
import 'package:mongtory_diary/domain/repositories/emotion_repository.dart';

class QaAppHarness {
  QaAppHarness({
    QaAuthRepository? authRepository,
    QaDiaryRepository? diaryRepository,
    QaCalendarRepository? calendarRepository,
    QaEmotionRepository? emotionRepository,
  }) : authRepository = authRepository ?? QaAuthRepository.success(),
       diaryRepository = diaryRepository ?? QaDiaryRepository.withData(),
       calendarRepository =
           calendarRepository ?? QaCalendarRepository.withData(),
       emotionRepository = emotionRepository ?? QaEmotionRepository.withData();

  final QaAuthRepository authRepository;
  final QaDiaryRepository diaryRepository;
  final QaCalendarRepository calendarRepository;
  final QaEmotionRepository emotionRepository;

  List<Override> get overrides => [
    dataSourceModeProvider.overrideWithValue(DataSourceMode.mock),
    authRepositoryProvider.overrideWithValue(authRepository),
    diaryRepositoryProvider.overrideWithValue(diaryRepository),
    calendarRepositoryProvider.overrideWithValue(calendarRepository),
    emotionRepositoryProvider.overrideWithValue(emotionRepository),
  ];
}

Future<void> pumpQaApp(WidgetTester tester, {QaAppHarness? harness}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: (harness ?? QaAppHarness()).overrides,
      child: const MongtoryDiaryApp(),
    ),
  );
}

Future<void> qaSignInWithSeedAccount(WidgetTester tester) async {
  await tester.tap(find.text('시작하기'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('테스트 계정 입력'));
  await tester.pump();

  await tester.tap(find.text('로그인'));
  await tester.pumpAndSettle();
}

class QaAuthRepository implements AuthRepository {
  QaAuthRepository.success()
    : _session = const AuthSession(
        accessToken: 'qa-access-token',
        refreshToken: 'qa-refresh-token',
        user: UserProfile(id: 1, email: 'user@example.com', nickname: 'QA 몽토리'),
      ),
      _error = null;

  QaAuthRepository.failure(String message)
    : _session = null,
      _error = ApiException(message, statusCode: 401);

  final AuthSession? _session;
  final ApiException? _error;

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final error = _error;
    if (error != null) {
      throw error;
    }

    return _session!;
  }
}

class QaDiaryRepository implements DiaryRepository {
  QaDiaryRepository({required this.summaries, required this.detail});

  factory QaDiaryRepository.withData() {
    final now = DateTime(2026, 3, 20, 12);
    return QaDiaryRepository(
      summaries: [
        DiarySummary(
          id: 1,
          entryDate: DateTime(2026, 3, 20),
          title: 'QA 자동화 일기',
          emotionCode: 'HAPPY',
          createdAt: now,
          updatedAt: now,
        ),
      ],
      detail: DiaryDetail(
        id: 1,
        entryDate: DateTime(2026, 3, 20),
        title: 'QA 자동화 일기',
        content: '하네스 검증용 일기입니다.',
        emotionCode: 'HAPPY',
        imageUrls: const [],
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  final List<DiarySummary> summaries;
  final DiaryDetail detail;

  @override
  Future<DiaryDetail> getDiaryDetail(int diaryId) async => detail;

  @override
  Future<List<DiarySummary>> getDiarySummaries() async => summaries;

  @override
  Future<DiaryDetail> createDiary(DiaryUpsert input) async {
    return DiaryDetail(
      id: 2,
      entryDate: input.entryDate,
      title: input.title,
      content: input.content,
      emotionCode: input.emotionCode,
      imageUrls: input.imageUrls,
      createdAt: DateTime(2026, 3, 21, 12),
      updatedAt: DateTime(2026, 3, 21, 12),
    );
  }

  @override
  Future<DiaryDetail> updateDiary(int diaryId, DiaryUpsert input) async {
    return DiaryDetail(
      id: diaryId,
      entryDate: input.entryDate,
      title: input.title,
      content: input.content,
      emotionCode: input.emotionCode,
      imageUrls: input.imageUrls,
      createdAt: detail.createdAt,
      updatedAt: DateTime(2026, 3, 21, 12),
    );
  }

  @override
  Future<void> deleteDiary(int diaryId) async {}
}

class QaCalendarRepository implements CalendarRepository {
  QaCalendarRepository({required this.month});

  factory QaCalendarRepository.withData() {
    return QaCalendarRepository(
      month: CalendarMonth(
        year: 2026,
        month: 3,
        days: [
          CalendarDaySummary(
            date: DateTime(2026, 3, 20),
            hasEntry: true,
            emotionCode: 'HAPPY',
            entryCount: 1,
          ),
        ],
      ),
    );
  }

  final CalendarMonth month;

  @override
  Future<CalendarMonth> getCalendarMonth({
    required int year,
    required int month,
  }) async {
    return this.month;
  }
}

class QaEmotionRepository implements EmotionRepository {
  QaEmotionRepository({required this.emotions});

  factory QaEmotionRepository.withData() {
    return QaEmotionRepository(
      emotions: const [
        EmotionType(code: 'HAPPY', label: '기쁨', iconKey: 'happy'),
        EmotionType(code: 'CALM', label: '평온', iconKey: 'calm'),
      ],
    );
  }

  final List<EmotionType> emotions;

  @override
  Future<List<EmotionType>> getEmotions() async => emotions;
}
