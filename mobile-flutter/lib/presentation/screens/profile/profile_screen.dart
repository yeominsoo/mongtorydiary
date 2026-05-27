import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/application/reminder/writing_reminder_controller.dart';
import 'package:mongtory_diary/application/session/session_state.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/domain/models/todo_item.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final diaries = ref.watch(diaryListProvider);
    final todos = ref.watch(visibleMonthTodoListProvider);
    final reminder = ref.watch(writingReminderControllerProvider);
    final userName = session.status == SessionStatus.signedIn
        ? session.session?.user.nickname ?? '몽토리 사용자'
        : '게스트';
    final userEmail = session.status == SessionStatus.signedIn
        ? session.session?.user.email ?? 'unknown'
        : 'guest';
    final diaryItems = diaries.valueOrNull ?? const <DiarySummary>[];
    final todoItems = todos.valueOrNull ?? const <TodoItem>[];

    return Scaffold(
      appBar: AppBar(title: const Text('몽토리 컬렉션')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MongtoryCollectionHeader(
                  userName: userName,
                  userEmail: userEmail,
                  diaries: diaryItems,
                  todos: todoItems,
                ),
                const SizedBox(height: 14),
                _CollectionGrid(
                  first: _MonthlyRhythmPanel(
                    diaries: diaryItems,
                    todos: todoItems,
                  ),
                  second: _WritingReminderPanel(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MongtoryCollectionHeader extends StatelessWidget {
  const _MongtoryCollectionHeader({
    required this.userName,
    required this.userEmail,
    required this.diaries,
    required this.todos,
  });

  final String userName;
  final String userEmail;
  final List<DiarySummary> diaries;
  final List<TodoItem> todos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
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

    return _SurfaceFrame(
      padding: const EdgeInsets.all(22),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          final identity = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: SizedBox(
                  width: 76,
                  height: 76,
                  child: Center(
                    child: Text(
                      '몽',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '몽토리 컨디션',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$userName님의 컬렉션',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('이메일: $userEmail'),
                  ],
                ),
              ),
            ],
          );
          final metrics = Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeaderMetric(
                icon: Icons.menu_book_outlined,
                label: '오늘 일기',
                value: '$todayDiaries',
              ),
              _HeaderMetric(
                icon: Icons.task_alt,
                label: '오늘 TODO',
                value: '$completedTodos/${todayTodos.length}',
              ),
            ],
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: identity),
                const SizedBox(width: 20),
                SizedBox(width: 260, child: metrics),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [identity, const SizedBox(height: 18), metrics],
          );
        },
      ),
    );
  }
}

class _CollectionGrid extends StatelessWidget {
  const _CollectionGrid({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 760) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: first),
              const SizedBox(width: 14),
              Expanded(child: second),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [first, const SizedBox(height: 14), second],
        );
      },
    );
  }
}

class _MonthlyRhythmPanel extends StatelessWidget {
  const _MonthlyRhythmPanel({required this.diaries, required this.todos});

  final List<DiarySummary> diaries;
  final List<TodoItem> todos;

  @override
  Widget build(BuildContext context) {
    final streak = _calculateStreak(diaries);
    final completedTodos = todos.where((todo) => todo.completed).length;

    return _SurfaceFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PanelTitle(title: '성장 기록', subtitle: '이번 달 기록 리듬'),
          const SizedBox(height: 14),
          Wrap(
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
            ],
          ),
        ],
      ),
    );
  }
}

class _WritingReminderPanel extends StatelessWidget {
  const _WritingReminderPanel({
    required this.settings,
    required this.onEnabledChanged,
    required this.onPickTime,
  });

  final WritingReminderSettings settings;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return _SurfaceFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelTitle(
            title: '작성 리마인더',
            subtitle: settings.enabled ? '매일 ${settings.timeLabel}' : '꺼짐',
          ),
          const SizedBox(height: 14),
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SwitchListTile(
              value: settings.enabled,
              onChanged: onEnabledChanged,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              title: const Text('사용'),
              secondary: const Icon(Icons.notifications_active_outlined),
            ),
          ),
          const SizedBox(height: 12),
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

class _PanelTitle extends StatelessWidget {
  const _PanelTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 125,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.48),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: scheme.primary),
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
        ),
      ),
    );
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
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 142,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.46),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: scheme.primary),
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
        ),
      ),
    );
  }
}

class _SurfaceFrame extends StatelessWidget {
  const _SurfaceFrame({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(padding: padding, child: child),
    );
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
        constraints: const BoxConstraints(maxWidth: 1000),
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
