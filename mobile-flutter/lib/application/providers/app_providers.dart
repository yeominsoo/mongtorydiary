import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/navigation/home_tab.dart';
import 'package:mongtory_diary/application/navigation/home_tab_controller.dart';
import 'package:mongtory_diary/application/reminder/writing_reminder_controller.dart';
import 'package:mongtory_diary/application/session/session_controller.dart';
import 'package:mongtory_diary/application/session/session_state.dart';
import 'package:mongtory_diary/core/config/app_config.dart';
import 'package:mongtory_diary/core/network/api_client.dart';
import 'package:mongtory_diary/data/datasources/mock/mock_auth_datasource.dart';
import 'package:mongtory_diary/data/datasources/mock/mock_calendar_datasource.dart';
import 'package:mongtory_diary/data/datasources/mock/mock_diary_datasource.dart';
import 'package:mongtory_diary/data/datasources/mock/mock_emotion_datasource.dart';
import 'package:mongtory_diary/data/datasources/mock/mock_todo_datasource.dart';
import 'package:mongtory_diary/data/datasources/remote/remote_auth_datasource.dart';
import 'package:mongtory_diary/data/datasources/remote/remote_calendar_datasource.dart';
import 'package:mongtory_diary/data/datasources/remote/remote_diary_datasource.dart';
import 'package:mongtory_diary/data/datasources/remote/remote_emotion_datasource.dart';
import 'package:mongtory_diary/data/datasources/remote/remote_todo_datasource.dart';
import 'package:mongtory_diary/data/repositories/api_auth_repository.dart';
import 'package:mongtory_diary/data/repositories/api_calendar_repository.dart';
import 'package:mongtory_diary/data/repositories/api_diary_repository.dart';
import 'package:mongtory_diary/data/repositories/api_emotion_repository.dart';
import 'package:mongtory_diary/data/repositories/api_todo_repository.dart';
import 'package:mongtory_diary/data/repositories/mock_auth_repository.dart';
import 'package:mongtory_diary/data/repositories/mock_calendar_repository.dart';
import 'package:mongtory_diary/data/repositories/mock_diary_repository.dart';
import 'package:mongtory_diary/data/repositories/mock_emotion_repository.dart';
import 'package:mongtory_diary/data/repositories/mock_todo_repository.dart';
import 'package:mongtory_diary/domain/models/calendar_month.dart';
import 'package:mongtory_diary/domain/models/diary_detail.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/domain/models/emotion_type.dart';
import 'package:mongtory_diary/domain/models/todo_item.dart';
import 'package:mongtory_diary/domain/repositories/auth_repository.dart';
import 'package:mongtory_diary/domain/repositories/calendar_repository.dart';
import 'package:mongtory_diary/domain/repositories/diary_repository.dart';
import 'package:mongtory_diary/domain/repositories/emotion_repository.dart';
import 'package:mongtory_diary/domain/repositories/todo_repository.dart';

final dataSourceModeProvider = Provider(
  (ref) => AppConfig.configuredDataSourceMode,
);
final apiBaseUrlProvider = Provider((ref) => AppConfig.defaultApiBaseUrl);
final dataSourceModeLabelProvider = Provider((ref) {
  final mode = ref.read(dataSourceModeProvider);
  return mode == DataSourceMode.remote ? 'remote' : 'mock';
});
final apiClientProvider = Provider(
  (ref) => ApiClient(baseUrl: ref.read(apiBaseUrlProvider)),
);
final accessTokenProvider = Provider<String?>((ref) {
  return ref.watch(
    sessionControllerProvider.select((state) => state.session?.accessToken),
  );
});

final mockAuthDataSourceProvider = Provider(
  (ref) => const MockAuthDataSource(),
);
final mockDiaryDataSourceProvider = Provider(
  (ref) => const MockDiaryDataSource(),
);
final mockCalendarDataSourceProvider = Provider(
  (ref) => const MockCalendarDataSource(),
);
final mockEmotionDataSourceProvider = Provider(
  (ref) => const MockEmotionDataSource(),
);
final mockTodoDataSourceProvider = Provider(
  (ref) => const MockTodoDataSource(),
);

final remoteAuthDataSourceProvider = Provider(
  (ref) => RemoteAuthDataSource(ref.read(apiClientProvider)),
);
final remoteDiaryDataSourceProvider = Provider(
  (ref) => RemoteDiaryDataSource(
    ref.read(apiClientProvider),
    ref.watch(accessTokenProvider),
  ),
);
final remoteCalendarDataSourceProvider = Provider(
  (ref) => RemoteCalendarDataSource(
    ref.read(apiClientProvider),
    ref.watch(accessTokenProvider),
  ),
);
final remoteEmotionDataSourceProvider = Provider(
  (ref) => RemoteEmotionDataSource(ref.read(apiClientProvider)),
);
final remoteTodoDataSourceProvider = Provider(
  (ref) => RemoteTodoDataSource(
    ref.read(apiClientProvider),
    ref.watch(accessTokenProvider),
  ),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final mode = ref.read(dataSourceModeProvider);

  if (mode == DataSourceMode.remote) {
    return ApiAuthRepository(ref.read(remoteAuthDataSourceProvider));
  }

  return MockAuthRepository(ref.read(mockAuthDataSourceProvider));
});

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  final mode = ref.read(dataSourceModeProvider);

  if (mode == DataSourceMode.remote) {
    return ApiDiaryRepository(ref.read(remoteDiaryDataSourceProvider));
  }

  return MockDiaryRepository(ref.read(mockDiaryDataSourceProvider));
});

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final mode = ref.read(dataSourceModeProvider);

  if (mode == DataSourceMode.remote) {
    return ApiCalendarRepository(ref.read(remoteCalendarDataSourceProvider));
  }

  return MockCalendarRepository(ref.read(mockCalendarDataSourceProvider));
});

final emotionRepositoryProvider = Provider<EmotionRepository>((ref) {
  final mode = ref.read(dataSourceModeProvider);

  if (mode == DataSourceMode.remote) {
    return ApiEmotionRepository(ref.read(remoteEmotionDataSourceProvider));
  }

  return MockEmotionRepository(ref.read(mockEmotionDataSourceProvider));
});

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final mode = ref.read(dataSourceModeProvider);

  if (mode == DataSourceMode.remote) {
    return ApiTodoRepository(ref.read(remoteTodoDataSourceProvider));
  }

  return MockTodoRepository(ref.read(mockTodoDataSourceProvider));
});

final sessionControllerProvider =
    StateNotifierProvider<SessionController, SessionState>(
      (ref) => SessionController(ref.read(authRepositoryProvider)),
    );

final homeTabControllerProvider =
    StateNotifierProvider<HomeTabController, HomeTab>(
      (ref) => HomeTabController(),
    );

final writingReminderControllerProvider =
    StateNotifierProvider<WritingReminderController, WritingReminderSettings>(
      (ref) => WritingReminderController(),
    );

final diaryListProvider = FutureProvider.autoDispose<List<DiarySummary>>((
  ref,
) async {
  final repository = ref.read(diaryRepositoryProvider);
  return repository.getDiarySummaries();
});

final diarySearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final diarySelectedTagProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

final diaryHomeListProvider = FutureProvider.autoDispose<List<DiarySummary>>((
  ref,
) async {
  final repository = ref.read(diaryRepositoryProvider);
  final query = ref.watch(diarySearchQueryProvider);
  final tag = ref.watch(diarySelectedTagProvider);
  return repository.getDiarySummaries(query: query, tag: tag);
});

final diaryTodayMemoriesProvider =
    FutureProvider.autoDispose<List<DiarySummary>>((ref) async {
      final repository = ref.read(diaryRepositoryProvider);
      final today = DateTime.now();
      return repository.getDiaryMemories(month: today.month, day: today.day);
    });

final diaryDetailProvider = FutureProvider.autoDispose.family<DiaryDetail, int>(
  (ref, diaryId) async {
    final repository = ref.read(diaryRepositoryProvider);
    return repository.getDiaryDetail(diaryId);
  },
);

final calendarVisibleMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

final calendarSelectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final calendarMonthProvider = FutureProvider.autoDispose<CalendarMonth>((
  ref,
) async {
  final repository = ref.read(calendarRepositoryProvider);
  final visibleMonth = ref.watch(calendarVisibleMonthProvider);
  return repository.getCalendarMonth(
    year: visibleMonth.year,
    month: visibleMonth.month,
  );
});

final visibleMonthTodoListProvider = FutureProvider.autoDispose<List<TodoItem>>(
  (ref) async {
    final repository = ref.read(todoRepositoryProvider);
    final visibleMonth = ref.watch(calendarVisibleMonthProvider);
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month);
    final lastDay = DateTime(visibleMonth.year, visibleMonth.month + 1, 0);

    return repository.getTodos(from: firstDay, to: lastDay);
  },
);

final emotionListProvider = FutureProvider.autoDispose<List<EmotionType>>((
  ref,
) async {
  final repository = ref.read(emotionRepositoryProvider);
  return repository.getEmotions();
});
