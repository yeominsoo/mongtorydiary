import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/domain/models/calendar_day_summary.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/domain/models/todo_item.dart';
import 'package:mongtory_diary/domain/models/todo_upsert.dart';
import 'package:mongtory_diary/presentation/screens/diary/diary_detail_screen.dart';
import 'package:mongtory_diary/presentation/screens/diary/diary_edit_screen.dart';
import 'package:mongtory_diary/presentation/widgets/section_card.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleMonth = ref.watch(calendarVisibleMonthProvider);
    final selectedDate = ref.watch(calendarSelectedDateProvider);
    final month = ref.watch(calendarMonthProvider);
    final diaryList = ref.watch(diaryListProvider);
    final todoList = ref.watch(visibleMonthTodoListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('캘린더')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ContentWidth(
            child: month.when(
              data: (calendar) => todoList.when(
                data: (todos) => SectionCard(
                  title: '${visibleMonth.year}년 ${visibleMonth.month}월',
                  description:
                      '일기 ${_totalEntries(calendar.days)}건 · TODO ${todos.length}건',
                  child: _CalendarMonthGrid(
                    visibleMonth: visibleMonth,
                    selectedDate: selectedDate,
                    summaries: calendar.days,
                    todos: todos,
                    onMonthChanged: (month) {
                      ref.read(calendarVisibleMonthProvider.notifier).state =
                          month;
                      ref.read(calendarSelectedDateProvider.notifier).state =
                          DateTime(month.year, month.month, 1);
                    },
                    onDateSelected: (date) {
                      ref.read(calendarSelectedDateProvider.notifier).state =
                          date;
                    },
                  ),
                ),
                loading: () => const SectionCard(
                  title: '월간 캘린더',
                  description: 'TODO를 불러오는 중입니다.',
                ),
                error: (error, _) => SectionCard(
                  title: '월간 캘린더',
                  description: 'TODO를 불러오지 못했습니다. $error',
                ),
              ),
              loading: () => const SectionCard(
                title: '월간 캘린더',
                description: '캘린더 데이터를 불러오는 중입니다.',
              ),
              error: (error, _) => SectionCard(
                title: '월간 캘린더',
                description: '캘린더 데이터를 불러오지 못했습니다. $error',
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ContentWidth(
            child: _SelectedDatePanel(
              date: selectedDate,
              diaries: _diariesOnDate(
                diaryList.valueOrNull ?? const [],
                selectedDate,
              ),
              todos: _todosOnDate(
                todoList.valueOrNull ?? const [],
                selectedDate,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarMonthGrid extends StatelessWidget {
  const _CalendarMonthGrid({
    required this.visibleMonth,
    required this.selectedDate,
    required this.summaries,
    required this.todos,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final List<CalendarDaySummary> summaries;
  final List<TodoItem> todos;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final summaryByDate = {
      for (final summary in summaries) _dateKey(summary.date): summary,
    };
    final todoCountByDate = <String, int>{};
    final completedTodoCountByDate = <String, int>{};

    for (final todo in todos) {
      final key = _dateKey(todo.dueDate);
      todoCountByDate[key] = (todoCountByDate[key] ?? 0) + 1;
      if (todo.completed) {
        completedTodoCountByDate[key] =
            (completedTodoCountByDate[key] ?? 0) + 1;
      }
    }

    final days = _buildMonthCells(visibleMonth);

    return Column(
      children: [
        _CalendarToolbar(
          visibleMonth: visibleMonth,
          onPrevious: () => onMonthChanged(
            DateTime(visibleMonth.year, visibleMonth.month - 1),
          ),
          onNext: () => onMonthChanged(
            DateTime(visibleMonth.year, visibleMonth.month + 1),
          ),
          onToday: () {
            final now = DateTime.now();
            onMonthChanged(DateTime(now.year, now.month));
            onDateSelected(DateTime(now.year, now.month, now.day));
          },
        ),
        const SizedBox(height: 16),
        const _WeekdayHeader(),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 0.92,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final date = days[index];

            if (date == null) {
              return const SizedBox.shrink();
            }

            final key = _dateKey(date);
            final summary = summaryByDate[key];
            final todoCount = todoCountByDate[key] ?? summary?.todoCount ?? 0;
            final completedTodoCount =
                completedTodoCountByDate[key] ??
                summary?.completedTodoCount ??
                0;

            return _CalendarDayCell(
              date: date,
              isToday: _isSameDate(date, DateTime.now()),
              isSelected: _isSameDate(date, selectedDate),
              entryCount: summary?.entryCount ?? 0,
              emotionCode: summary?.emotionCode,
              todoCount: todoCount,
              completedTodoCount: completedTodoCount,
              onTap: () => onDateSelected(date),
            );
          },
        ),
      ],
    );
  }
}

class _CalendarToolbar extends StatelessWidget {
  const _CalendarToolbar({
    required this.visibleMonth,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final DateTime visibleMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton(
          tooltip: '이전 달',
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Text(
            '${visibleMonth.year}.${visibleMonth.month.toString().padLeft(2, '0')}',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(onPressed: onToday, child: const Text('오늘')),
        IconButton(
          tooltip: '다음 달',
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    const labels = ['일', '월', '화', '수', '목', '금', '토'];

    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.entryCount,
    required this.emotionCode,
    required this.todoCount,
    required this.completedTodoCount,
    required this.onTap,
  });

  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final int entryCount;
  final String? emotionCode;
  final int todoCount;
  final int completedTodoCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final borderColor = isSelected
        ? scheme.primary
        : isToday
        ? scheme.tertiary
        : scheme.outlineVariant;
    final background = isSelected
        ? scheme.primaryContainer.withValues(alpha: 0.55)
        : scheme.surfaceContainerHighest.withValues(alpha: 0.42);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${date.day}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isSelected ? scheme.onPrimaryContainer : null,
                ),
              ),
              const Spacer(),
              if (entryCount > 0)
                _MiniMetric(
                  icon: Icons.menu_book_outlined,
                  label: '$entryCount',
                  color: scheme.primary,
                ),
              if (todoCount > 0)
                _MiniMetric(
                  icon: Icons.check_circle_outline,
                  label: '$completedTodoCount/$todoCount',
                  color: completedTodoCount == todoCount
                      ? scheme.tertiary
                      : scheme.secondary,
                ),
              if (entryCount == 0 && todoCount == 0)
                Text(
                  emotionCode ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedDatePanel extends ConsumerWidget {
  const _SelectedDatePanel({
    required this.date,
    required this.diaries,
    required this.todos,
  });

  final DateTime date;
  final List<DiarySummary> diaries;
  final List<TodoItem> todos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedCount = todos.where((todo) => todo.completed).length;

    return SectionCard(
      title: _formatKoreanDate(date),
      description:
          '일기 ${diaries.length}건 · TODO $completedCount/${todos.length}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHeader(
            title: '일기',
            action: TextButton.icon(
              onPressed: () => _openCreateDiary(context, ref),
              icon: const Icon(Icons.edit_note),
              label: const Text('작성'),
            ),
          ),
          if (diaries.isEmpty)
            const _EmptyLine(text: '이 날짜에 작성된 일기가 없습니다.')
          else
            ...diaries.map((item) => _DateDiaryAction(item: item)),
          const SizedBox(height: 16),
          const _PanelHeader(title: 'TODO'),
          if (todos.isEmpty) const _EmptyLine(text: '등록된 TODO가 없습니다.'),
          ...todos.map((todo) => _TodoTile(todo: todo)),
          const SizedBox(height: 8),
          _TodoComposer(date: date),
        ],
      ),
    );
  }

  Future<void> _openCreateDiary(BuildContext context, WidgetRef ref) async {
    final didSave = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => DiaryEditScreen(initialDate: date),
      ),
    );

    if (didSave == true) {
      ref.invalidate(diaryListProvider);
      ref.invalidate(calendarMonthProvider);
    }
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        ?action,
      ],
    );
  }
}

class _EmptyLine extends StatelessWidget {
  const _EmptyLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _TodoTile extends ConsumerWidget {
  const _TodoTile({required this.todo});

  final TodoItem todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: todo.completed,
      title: Text(
        todo.content,
        style: TextStyle(
          decoration: todo.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      secondary: IconButton(
        tooltip: 'TODO 삭제',
        onPressed: () async {
          await ref.read(todoRepositoryProvider).deleteTodo(todo.id);
          ref.invalidate(visibleMonthTodoListProvider);
          ref.invalidate(calendarMonthProvider);
        },
        icon: const Icon(Icons.delete_outline),
      ),
      onChanged: (value) async {
        await ref
            .read(todoRepositoryProvider)
            .updateTodo(
              todo.id,
              TodoUpsert(
                dueDate: todo.dueDate,
                content: todo.content,
                completed: value ?? false,
              ),
            );
        ref.invalidate(visibleMonthTodoListProvider);
        ref.invalidate(calendarMonthProvider);
      },
    );
  }
}

class _TodoComposer extends ConsumerStatefulWidget {
  const _TodoComposer({required this.date});

  final DateTime date;

  @override
  ConsumerState<_TodoComposer> createState() => _TodoComposerState();
}

class _TodoComposerState extends ConsumerState<_TodoComposer> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            enabled: !_saving,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'TODO',
              hintText: '오늘 할 일을 입력하세요',
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: _saving ? null : _submit,
          icon: const Icon(Icons.add),
          label: const Text('추가'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final content = _controller.text.trim();
    if (content.isEmpty) {
      return;
    }

    setState(() => _saving = true);
    try {
      await ref
          .read(todoRepositoryProvider)
          .createTodo(
            TodoUpsert(
              dueDate: widget.date,
              content: content,
              completed: false,
            ),
          );
      _controller.clear();
      ref.invalidate(visibleMonthTodoListProvider);
      ref.invalidate(calendarMonthProvider);
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

class _DateDiaryAction extends StatelessWidget {
  const _DateDiaryAction({required this.item});

  final DiarySummary item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(item.title),
      subtitle: Text(item.emotionCode),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _openDetail(context),
    );
  }

  Future<void> _openDetail(BuildContext context) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => DiaryDetailScreen(diaryId: item.id),
      ),
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
        constraints: const BoxConstraints(maxWidth: 960),
        child: child,
      ),
    );
  }
}

List<DateTime?> _buildMonthCells(DateTime visibleMonth) {
  final firstDay = DateTime(visibleMonth.year, visibleMonth.month);
  final lastDay = DateTime(visibleMonth.year, visibleMonth.month + 1, 0);
  final leadingEmptyDays = firstDay.weekday % 7;
  final days = <DateTime?>[
    ...List<DateTime?>.filled(leadingEmptyDays, null),
    for (var day = 1; day <= lastDay.day; day++)
      DateTime(visibleMonth.year, visibleMonth.month, day),
  ];
  final trailingEmptyDays = (7 - days.length % 7) % 7;
  days.addAll(List<DateTime?>.filled(trailingEmptyDays, null));
  return days;
}

List<DiarySummary> _diariesOnDate(List<DiarySummary> diaries, DateTime date) {
  return diaries.where((item) => _isSameDate(item.entryDate, date)).toList();
}

List<TodoItem> _todosOnDate(List<TodoItem> todos, DateTime date) {
  return todos.where((item) => _isSameDate(item.dueDate, date)).toList();
}

int _totalEntries(List<CalendarDaySummary> days) {
  return days.fold(0, (sum, day) => sum + day.entryCount);
}

bool _isSameDate(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

String _dateKey(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

String _formatKoreanDate(DateTime value) {
  final weekday = ['월', '화', '수', '목', '금', '토', '일'][value.weekday - 1];
  return '${value.year}년 ${value.month}월 ${value.day}일 $weekday요일';
}
