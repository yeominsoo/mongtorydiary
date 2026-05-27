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
import 'package:mongtory_diary/domain/models/todo_item.dart';
import 'package:mongtory_diary/domain/models/todo_upsert.dart';
import 'package:mongtory_diary/domain/models/user_profile.dart';
import 'package:mongtory_diary/domain/repositories/auth_repository.dart';
import 'package:mongtory_diary/domain/repositories/calendar_repository.dart';
import 'package:mongtory_diary/domain/repositories/diary_repository.dart';
import 'package:mongtory_diary/domain/repositories/emotion_repository.dart';
import 'package:mongtory_diary/domain/repositories/todo_repository.dart';

class QaAppHarness {
  QaAppHarness({
    QaAuthRepository? authRepository,
    QaDiaryRepository? diaryRepository,
    QaCalendarRepository? calendarRepository,
    QaEmotionRepository? emotionRepository,
    QaTodoRepository? todoRepository,
  }) : authRepository = authRepository ?? QaAuthRepository.success(),
       diaryRepository = diaryRepository ?? QaDiaryRepository.withData(),
       calendarRepository =
           calendarRepository ?? QaCalendarRepository.withData(),
       emotionRepository = emotionRepository ?? QaEmotionRepository.withData(),
       todoRepository = todoRepository ?? QaTodoRepository.withData();

  final QaAuthRepository authRepository;
  final QaDiaryRepository diaryRepository;
  final QaCalendarRepository calendarRepository;
  final QaEmotionRepository emotionRepository;
  final QaTodoRepository todoRepository;

  List<Override> get overrides => [
    dataSourceModeProvider.overrideWithValue(DataSourceMode.mock),
    calendarVisibleMonthProvider.overrideWith((ref) => DateTime(2026, 3)),
    calendarSelectedDateProvider.overrideWith((ref) => DateTime(2026, 3, 20)),
    authRepositoryProvider.overrideWithValue(authRepository),
    diaryRepositoryProvider.overrideWithValue(diaryRepository),
    calendarRepositoryProvider.overrideWithValue(calendarRepository),
    emotionRepositoryProvider.overrideWithValue(emotionRepository),
    todoRepositoryProvider.overrideWithValue(todoRepository),
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

  await tester.tap(find.text('테스트 계정으로 접속'));
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
  QaDiaryRepository({
    required List<DiarySummary> summaries,
    required DiaryDetail detail,
  }) : summaries = List.of(summaries),
       _details = {detail.id: detail},
       _nextId = detail.id + 1;

  factory QaDiaryRepository.withData() {
    final now = DateTime(2026, 3, 20, 12);
    return QaDiaryRepository(
      summaries: [
        DiarySummary(
          id: 1,
          entryDate: DateTime(2026, 3, 20),
          title: 'QA 자동화 일기',
          emotionCode: 'HAPPY',
          locationName: 'QA 연구실',
          weatherSummary: '맑음',
          tags: const ['QA', '회고'],
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
        locationName: 'QA 연구실',
        weatherSummary: '맑음',
        tags: const ['QA', '회고'],
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  final List<DiarySummary> summaries;
  final Map<int, DiaryDetail> _details;
  int _nextId;

  @override
  Future<DiaryDetail> getDiaryDetail(int diaryId) async => _details[diaryId]!;

  @override
  Future<List<DiarySummary>> getDiarySummaries({
    String? query,
    String? tag,
  }) async {
    final normalizedQuery = query?.trim().toLowerCase();
    final normalizedTag = tag?.trim().toLowerCase();

    return summaries.where((item) {
      final matchesQuery = normalizedQuery == null || normalizedQuery.isEmpty
          ? true
          : item.title.toLowerCase().contains(normalizedQuery) ||
                _containsOptionalText(item.locationName, normalizedQuery) ||
                _containsOptionalText(item.weatherSummary, normalizedQuery) ||
                item.tags.any(
                  (tag) => tag.toLowerCase().contains(normalizedQuery),
                );
      final matchesTag = normalizedTag == null || normalizedTag.isEmpty
          ? true
          : item.tags.any((tag) => tag.toLowerCase() == normalizedTag);

      return matchesQuery && matchesTag;
    }).toList();
  }

  @override
  Future<List<DiarySummary>> getDiaryMemories({
    required int month,
    required int day,
  }) async {
    final currentYear = DateTime.now().year;
    return summaries.where((item) {
      return item.entryDate.year < currentYear &&
          item.entryDate.month == month &&
          item.entryDate.day == day;
    }).toList();
  }

  @override
  Future<String> uploadDiaryImage({
    required String fileName,
    required List<int> bytes,
  }) async {
    return 'https://example.com/qa-uploads/$fileName';
  }

  @override
  Future<DiaryDetail> createDiary(DiaryUpsert input) async {
    final now = DateTime(2026, 3, 21, 12);
    final detail = DiaryDetail(
      id: _nextId++,
      entryDate: input.entryDate,
      title: input.title,
      content: input.content,
      emotionCode: input.emotionCode,
      imageUrls: input.imageUrls,
      locationName: input.locationName,
      weatherSummary: input.weatherSummary,
      tags: input.tags,
      createdAt: now,
      updatedAt: now,
    );
    _details[detail.id] = detail;
    summaries.insert(0, _summaryFromDetail(detail));

    return detail;
  }

  @override
  Future<DiaryDetail> updateDiary(int diaryId, DiaryUpsert input) async {
    final current = _details[diaryId]!;
    final updated = DiaryDetail(
      id: diaryId,
      entryDate: input.entryDate,
      title: input.title,
      content: input.content,
      emotionCode: input.emotionCode,
      imageUrls: input.imageUrls,
      locationName: input.locationName,
      weatherSummary: input.weatherSummary,
      tags: input.tags,
      createdAt: current.createdAt,
      updatedAt: DateTime(2026, 3, 21, 12),
    );
    _details[diaryId] = updated;

    final index = summaries.indexWhere((item) => item.id == diaryId);
    if (index != -1) {
      summaries[index] = _summaryFromDetail(updated);
    }

    return updated;
  }

  @override
  Future<void> deleteDiary(int diaryId) async {
    _details.remove(diaryId);
    summaries.removeWhere((item) => item.id == diaryId);
  }

  DiarySummary _summaryFromDetail(DiaryDetail detail) {
    return DiarySummary(
      id: detail.id,
      entryDate: detail.entryDate,
      title: detail.title,
      emotionCode: detail.emotionCode,
      locationName: detail.locationName,
      weatherSummary: detail.weatherSummary,
      tags: detail.tags,
      createdAt: detail.createdAt,
      updatedAt: detail.updatedAt,
    );
  }

  bool _containsOptionalText(String? value, String normalizedQuery) {
    return value != null && value.toLowerCase().contains(normalizedQuery);
  }
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
            todoCount: 2,
            completedTodoCount: 1,
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

class QaTodoRepository implements TodoRepository {
  QaTodoRepository({required List<TodoItem> todos})
    : todos = List.of(todos),
      _nextId = todos.isEmpty
          ? 1
          : todos.map((todo) => todo.id).reduce((a, b) => a > b ? a : b) + 1;

  factory QaTodoRepository.withData() {
    final now = DateTime(2026, 3, 20, 9);
    return QaTodoRepository(
      todos: [
        TodoItem(
          id: 1,
          dueDate: DateTime(2026, 3, 20),
          content: 'QA TODO 확인',
          completed: false,
          createdAt: now,
          updatedAt: now,
        ),
        TodoItem(
          id: 2,
          dueDate: DateTime(2026, 3, 20),
          content: '완료된 QA TODO',
          completed: true,
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );
  }

  final List<TodoItem> todos;
  int _nextId;

  @override
  Future<List<TodoItem>> getTodos({
    required DateTime from,
    required DateTime to,
  }) async {
    return todos.where((todo) {
      return !todo.dueDate.isBefore(from) && !todo.dueDate.isAfter(to);
    }).toList();
  }

  @override
  Future<TodoItem> createTodo(TodoUpsert input) async {
    final now = DateTime(2026, 3, 21, 12);
    final todo = TodoItem(
      id: _nextId++,
      dueDate: input.dueDate,
      content: input.content,
      completed: input.completed,
      createdAt: now,
      updatedAt: now,
    );
    todos.add(todo);
    return todo;
  }

  @override
  Future<TodoItem> updateTodo(int todoId, TodoUpsert input) async {
    final index = todos.indexWhere((todo) => todo.id == todoId);
    final current = todos[index];
    final updated = TodoItem(
      id: current.id,
      dueDate: input.dueDate,
      content: input.content,
      completed: input.completed,
      createdAt: current.createdAt,
      updatedAt: DateTime(2026, 3, 21, 12),
    );
    todos[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteTodo(int todoId) async {
    todos.removeWhere((todo) => todo.id == todoId);
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
