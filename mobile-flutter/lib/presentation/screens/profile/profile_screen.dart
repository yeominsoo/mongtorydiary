import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/application/reminder/writing_reminder_controller.dart';
import 'package:mongtory_diary/application/session/session_state.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/domain/models/emotion_type.dart';
import 'package:mongtory_diary/domain/models/todo_item.dart';
import 'package:mongtory_diary/presentation/widgets/section_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final emotions = ref.watch(emotionListProvider);
    final diaries = ref.watch(diaryListProvider);
    final todos = ref.watch(visibleMonthTodoListProvider);
    final reminder = ref.watch(writingReminderControllerProvider);
    final dataSourceModeLabel = ref.watch(dataSourceModeLabelProvider);
    final userName = session.status == SessionStatus.signedIn
        ? session.session?.user.nickname ?? '몽토리 사용자'
        : '게스트';
    final userEmail = session.status == SessionStatus.signedIn
        ? session.session?.user.email ?? 'unknown'
        : 'guest';

    return Scaffold(
      appBar: AppBar(title: const Text('몽토리')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ContentWidth(
            child: _MongtoryStatusCard(
              userName: userName,
              userEmail: userEmail,
              dataSourceModeLabel: dataSourceModeLabel,
              diaries: diaries.valueOrNull ?? const [],
              todos: todos.valueOrNull ?? const [],
            ),
          ),
          const SizedBox(height: 16),
          _ContentWidth(
            child: _MonthlyRhythmCard(
              diaries: diaries.valueOrNull ?? const [],
              todos: todos.valueOrNull ?? const [],
            ),
          ),
          const SizedBox(height: 16),
          _ContentWidth(
            child: _WritingReminderCard(
              settings: reminder,
              onEnabledChanged: (value) {
                ref
                    .read(writingReminderControllerProvider.notifier)
                    .setEnabled(value);
              },
              onPickTime: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: reminder.hour,
                    minute: reminder.minute,
                  ),
                );

                if (picked == null) {
                  return;
                }

                ref
                    .read(writingReminderControllerProvider.notifier)
                    .setTime(hour: picked.hour, minute: picked.minute);
              },
            ),
          ),
          const SizedBox(height: 16),
          _ContentWidth(
            child: emotions.when(
              data: (items) => _EmotionPaletteCard(items: items),
              loading: () => const SectionCard(
                title: '감정 팔레트',
                description: '감정 데이터를 불러오는 중입니다.',
              ),
              error: (error, _) => SectionCard(
                title: '감정 팔레트',
                description: '감정 데이터를 불러오지 못했습니다. $error',
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ContentWidth(
            child: _WidgetPreviewCard(
              diaries: diaries.valueOrNull ?? const [],
              todos: todos.valueOrNull ?? const [],
            ),
          ),
        ],
      ),
    );
  }
}

class _WritingReminderCard extends StatelessWidget {
  const _WritingReminderCard({
    required this.settings,
    required this.onEnabledChanged,
    required this.onPickTime,
  });

  final WritingReminderSettings settings;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '작성 리마인더',
      description: settings.enabled ? '매일 ${settings.timeLabel}' : '꺼짐',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile(
            value: settings.enabled,
            onChanged: onEnabledChanged,
            contentPadding: EdgeInsets.zero,
            title: const Text('사용'),
            secondary: const Icon(Icons.notifications_active_outlined),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: settings.enabled ? onPickTime : null,
              icon: const Icon(Icons.schedule_outlined),
              label: const Text('시간 변경'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MongtoryStatusCard extends StatelessWidget {
  const _MongtoryStatusCard({
    required this.userName,
    required this.userEmail,
    required this.dataSourceModeLabel,
    required this.diaries,
    required this.todos,
  });

  final String userName;
  final String userEmail;
  final String dataSourceModeLabel;
  final List<DiarySummary> diaries;
  final List<TodoItem> todos;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayDiaries = diaries
        .where((diary) => _isSameDate(diary.entryDate, today))
        .length;
    final todayTodos = todos
        .where((todo) => _isSameDate(todo.dueDate, today))
        .toList();
    final completedTodos = todayTodos.where((todo) => todo.completed).length;
    final message = todayDiaries > 0
        ? '오늘 기록을 남겼습니다.'
        : todayTodos.isNotEmpty
        ? '오늘 TODO를 먼저 정리했습니다.'
        : '오늘의 기록을 기다리는 중입니다.';

    return SectionCard(
      title: '몽토리 컨디션',
      description: '$userName · $dataSourceModeLabel 데이터',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 34,
            child: Text(
              '몽',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text('이메일: $userEmail'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetricChip(
                      icon: Icons.menu_book_outlined,
                      label: '오늘 일기 $todayDiaries',
                    ),
                    _MetricChip(
                      icon: Icons.check_circle_outline,
                      label: '오늘 TODO $completedTodos/${todayTodos.length}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyRhythmCard extends StatelessWidget {
  const _MonthlyRhythmCard({required this.diaries, required this.todos});

  final List<DiarySummary> diaries;
  final List<TodoItem> todos;

  @override
  Widget build(BuildContext context) {
    final streak = _calculateStreak(diaries);
    final completedTodos = todos.where((todo) => todo.completed).length;
    final emotionCount = diaries
        .map((diary) => diary.emotionCode)
        .toSet()
        .length;

    return SectionCard(
      title: '성장 기록',
      description: '연속 기록 $streak일 · TODO 완료 $completedTodos/${todos.length}',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _StatTile(
            icon: Icons.local_fire_department_outlined,
            label: '연속 기록',
            value: '$streak일',
          ),
          _StatTile(
            icon: Icons.auto_graph_outlined,
            label: '누적 일기',
            value: '${diaries.length}건',
          ),
          _StatTile(
            icon: Icons.task_alt,
            label: 'TODO 완료',
            value: '$completedTodos/${todos.length}',
          ),
          _StatTile(
            icon: Icons.palette_outlined,
            label: '감정 폭',
            value: '$emotionCount종',
          ),
        ],
      ),
    );
  }
}

class _EmotionPaletteCard extends StatelessWidget {
  const _EmotionPaletteCard({required this.items});

  final List<EmotionType> items;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '감정 팔레트',
      description: '사용 가능한 감정 ${items.length}종',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items.map((item) => _EmotionChip(item: item)).toList(),
      ),
    );
  }
}

class _WidgetPreviewCard extends StatelessWidget {
  const _WidgetPreviewCard({required this.diaries, required this.todos});

  final List<DiarySummary> diaries;
  final List<TodoItem> todos;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final latestDiary = _firstDiaryOnDate(diaries, today);
    final todayTodos = todos
        .where((todo) => _isSameDate(todo.dueDate, today))
        .toList();
    final completedTodos = todayTodos.where((todo) => todo.completed).length;

    return SectionCard(
      title: '홈 위젯 미리보기',
      description: latestDiary == null
          ? '오늘 일기 없음 · TODO $completedTodos/${todayTodos.length}'
          : '${latestDiary.title} · TODO $completedTodos/${todayTodos.length}',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.widgets_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                latestDiary?.title ?? '오늘의 일기를 기다리는 중',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Text('$completedTodos/${todayTodos.length}'),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 16), label: Text(label));
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(height: 10),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _EmotionChip extends StatelessWidget {
  const _EmotionChip({required this.item});

  final EmotionType item;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('${item.label} (${item.code})'));
  }
}

class _ContentWidth extends StatelessWidget {
  const _ContentWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840),
        child: child,
      ),
    );
  }
}

int _calculateStreak(List<DiarySummary> diaries) {
  final diaryDates = diaries
      .map(
        (diary) => DateTime(
          diary.entryDate.year,
          diary.entryDate.month,
          diary.entryDate.day,
        ),
      )
      .toSet();
  var cursor = DateTime.now();
  var streak = 0;

  while (diaryDates.contains(DateTime(cursor.year, cursor.month, cursor.day))) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }

  return streak;
}

bool _isSameDate(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

DiarySummary? _firstDiaryOnDate(List<DiarySummary> diaries, DateTime date) {
  for (final diary in diaries) {
    if (_isSameDate(diary.entryDate, date)) {
      return diary;
    }
  }

  return null;
}
