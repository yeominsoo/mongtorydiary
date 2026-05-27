import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongtory_diary/application/providers/app_providers.dart';
import 'package:mongtory_diary/domain/models/calendar_day_summary.dart';
import 'package:mongtory_diary/domain/models/calendar_month.dart';
import 'package:mongtory_diary/domain/models/diary_summary.dart';
import 'package:mongtory_diary/domain/models/todo_item.dart';
import 'package:mongtory_diary/domain/models/todo_upsert.dart';
import 'package:mongtory_diary/presentation/screens/diary/diary_detail_screen.dart';
import 'package:mongtory_diary/presentation/screens/diary/diary_edit_screen.dart';

enum _CalendarViewMode { month, week, agenda }

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  _CalendarViewMode _mode = _CalendarViewMode.month;

  @override
  Widget build(BuildContext context) {
    final visibleMonth = ref.watch(calendarVisibleMonthProvider);
    final selectedDate = ref.watch(calendarSelectedDateProvider);
    final month = ref.watch(calendarMonthProvider);
    final diaryList = ref.watch(diaryListProvider);
    final todoList = ref.watch(visibleMonthTodoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('몽토리 캘린더'),
        actions: [
          IconButton(
            tooltip: '오늘로 이동',
            onPressed: _goToday,
            icon: const Icon(Icons.today_outlined),
          ),
          IconButton(
            tooltip: '일기 작성',
            onPressed: () => _openCreateDiary(selectedDate),
            icon: const Icon(Icons.edit_note),
          ),
        ],
      ),
      body: month.when(
        data: (calendar) => todoList.when(
          data: (todos) => diaryList.when(
            data: (diaries) => _CalendarWorkspace(
              visibleMonth: visibleMonth,
              selectedDate: selectedDate,
              calendar: calendar,
              diaries: diaries,
              todos: todos,
              mode: _mode,
              onModeChanged: (mode) => setState(() => _mode = mode),
              onMonthChanged: _setVisibleMonth,
              onDateSelected: _setSelectedDate,
              onToday: _goToday,
              onCreateDiary: _openCreateDiary,
            ),
            loading: () => const _LoadingSurface(message: '일기를 불러오는 중입니다.'),
            error: (error, _) =>
                _ErrorSurface(title: '일기 로드 실패', message: '$error'),
          ),
          loading: () => const _LoadingSurface(message: 'TODO를 불러오는 중입니다.'),
          error: (error, _) =>
              _ErrorSurface(title: 'TODO 로드 실패', message: '$error'),
        ),
        loading: () => const _LoadingSurface(message: '캘린더를 불러오는 중입니다.'),
        error: (error, _) =>
            _ErrorSurface(title: '캘린더 로드 실패', message: '$error'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '선택일 일기 작성',
        onPressed: () => _openCreateDiary(selectedDate),
        child: const Icon(Icons.edit_note),
      ),
    );
  }

  void _setVisibleMonth(DateTime month) {
    ref.read(calendarVisibleMonthProvider.notifier).state = DateTime(
      month.year,
      month.month,
    );
  }

  void _setSelectedDate(DateTime date) {
    ref.read(calendarSelectedDateProvider.notifier).state = DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  void _goToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _setVisibleMonth(today);
    _setSelectedDate(today);
  }

  Future<void> _openCreateDiary(DateTime date) async {
    final didSave = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => DiaryEditScreen(initialDate: date),
      ),
    );

    if (didSave == true) {
      ref.invalidate(diaryListProvider);
      ref.invalidate(diaryHomeListProvider);
      ref.invalidate(calendarMonthProvider);
    }
  }
}

class _CalendarWorkspace extends StatelessWidget {
  const _CalendarWorkspace({
    required this.visibleMonth,
    required this.selectedDate,
    required this.calendar,
    required this.diaries,
    required this.todos,
    required this.mode,
    required this.onModeChanged,
    required this.onMonthChanged,
    required this.onDateSelected,
    required this.onToday,
    required this.onCreateDiary,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final CalendarMonth calendar;
  final List<DiarySummary> diaries;
  final List<TodoItem> todos;
  final _CalendarViewMode mode;
  final ValueChanged<_CalendarViewMode> onModeChanged;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onToday;
  final ValueChanged<DateTime> onCreateDiary;

  @override
  Widget build(BuildContext context) {
    final selectedDiaries = _diariesOnDate(diaries, selectedDate);
    final selectedTodos = _todosOnDate(todos, selectedDate);
    final monthTodos = _todosInMonth(todos, visibleMonth);

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1100;
        final content = [
          _CalendarRail(
            visibleMonth: visibleMonth,
            selectedDate: selectedDate,
            calendar: calendar,
            diaries: diaries,
            todos: monthTodos,
            onDateSelected: onDateSelected,
          ),
          _CalendarBoard(
            visibleMonth: visibleMonth,
            selectedDate: selectedDate,
            calendar: calendar,
            diaries: diaries,
            todos: monthTodos,
            mode: mode,
            onModeChanged: onModeChanged,
            onMonthChanged: onMonthChanged,
            onDateSelected: onDateSelected,
            onToday: onToday,
            onCreateDiary: () => onCreateDiary(selectedDate),
          ),
          _SelectedDateAgenda(
            date: selectedDate,
            diaries: selectedDiaries,
            todos: selectedTodos,
            onCreateDiary: () => onCreateDiary(selectedDate),
          ),
        ];

        if (!wide) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                content[0],
                const SizedBox(height: 14),
                content[1],
                const SizedBox(height: 14),
                content[2],
              ],
            ),
          );
        }

        final minHeight = constraints.maxHeight > 32
            ? constraints.maxHeight - 32
            : 0.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 260, child: content[0]),
                const SizedBox(width: 14),
                Expanded(child: content[1]),
                const SizedBox(width: 14),
                SizedBox(width: 360, child: content[2]),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CalendarRail extends StatelessWidget {
  const _CalendarRail({
    required this.visibleMonth,
    required this.selectedDate,
    required this.calendar,
    required this.diaries,
    required this.todos,
    required this.onDateSelected,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final CalendarMonth calendar;
  final List<DiarySummary> diaries;
  final List<TodoItem> todos;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final entries = _totalEntries(calendar.days);
    final completedTodos = todos.where((todo) => todo.completed).length;
    final activeDays = _activeDays(calendar.days, todos);

    return _SurfacePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '오늘의 일정판',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _MiniMonthGrid(
            visibleMonth: visibleMonth,
            selectedDate: selectedDate,
            activeDates: activeDays,
            onDateSelected: onDateSelected,
          ),
          const SizedBox(height: 16),
          _MetricBlock(
            icon: Icons.menu_book_outlined,
            label: '이번 달 일기',
            value: '$entries건',
          ),
          _MetricBlock(
            icon: Icons.task_alt_outlined,
            label: 'TODO 완료',
            value: '$completedTodos/${todos.length}',
          ),
          _MetricBlock(
            icon: Icons.calendar_today_outlined,
            label: '기록 있는 날',
            value: '${activeDays.length}일',
          ),
          const Divider(height: 28),
          const _CalendarSourceLegend(),
        ],
      ),
    );
  }
}

class _MiniMonthGrid extends StatelessWidget {
  const _MiniMonthGrid({
    required this.visibleMonth,
    required this.selectedDate,
    required this.activeDates,
    required this.onDateSelected,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final Set<String> activeDates;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final days = _buildMonthCells(visibleMonth);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          '${visibleMonth.year}년 ${visibleMonth.month}월',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        const _WeekdayHeader(compact: true),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final date = days[index];
            if (date == null) {
              return const SizedBox.shrink();
            }

            final selected = _isSameDate(date, selectedDate);
            final active = activeDates.contains(_dateKey(date));

            return Tooltip(
              message: _formatKoreanDate(date),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onDateSelected(date),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: selected ? scheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: active && !selected
                        ? Border.all(color: scheme.primary)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: selected ? scheme.onPrimary : null,
                        fontWeight: selected || active
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CalendarSourceLegend extends StatelessWidget {
  const _CalendarSourceLegend();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _LegendLine(color: Color(0xFFE4947C), label: '일기'),
        SizedBox(height: 8),
        _LegendLine(color: Color(0xFF4F9D69), label: '완료 TODO'),
        SizedBox(height: 8),
        _LegendLine(color: Color(0xFF5A7DCE), label: '남은 TODO'),
      ],
    );
  }
}

class _LegendLine extends StatelessWidget {
  const _LegendLine({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

class _CalendarBoard extends StatelessWidget {
  const _CalendarBoard({
    required this.visibleMonth,
    required this.selectedDate,
    required this.calendar,
    required this.diaries,
    required this.todos,
    required this.mode,
    required this.onModeChanged,
    required this.onMonthChanged,
    required this.onDateSelected,
    required this.onToday,
    required this.onCreateDiary,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final CalendarMonth calendar;
  final List<DiarySummary> diaries;
  final List<TodoItem> todos;
  final _CalendarViewMode mode;
  final ValueChanged<_CalendarViewMode> onModeChanged;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onToday;
  final VoidCallback onCreateDiary;

  @override
  Widget build(BuildContext context) {
    return _SurfacePanel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
            child: _CalendarCommandBar(
              visibleMonth: visibleMonth,
              mode: mode,
              onModeChanged: onModeChanged,
              onPrevious: () => onMonthChanged(
                DateTime(visibleMonth.year, visibleMonth.month - 1),
              ),
              onNext: () => onMonthChanged(
                DateTime(visibleMonth.year, visibleMonth.month + 1),
              ),
              onToday: onToday,
              onCreateDiary: onCreateDiary,
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(18),
            child: _BoardBody(
              visibleMonth: visibleMonth,
              selectedDate: selectedDate,
              calendar: calendar,
              diaries: diaries,
              todos: todos,
              mode: mode,
              onDateSelected: onDateSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarCommandBar extends StatelessWidget {
  const _CalendarCommandBar({
    required this.visibleMonth,
    required this.mode,
    required this.onModeChanged,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
    required this.onCreateDiary,
  });

  final DateTime visibleMonth;
  final _CalendarViewMode mode;
  final ValueChanged<_CalendarViewMode> onModeChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final VoidCallback onCreateDiary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        IconButton.outlined(
          tooltip: '이전 달',
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
        ),
        IconButton.outlined(
          tooltip: '다음 달',
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
        ),
        SizedBox(
          width: 190,
          child: Text(
            '${visibleMonth.year}년 ${visibleMonth.month}월',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: onToday,
          icon: const Icon(Icons.today_outlined),
          label: const Text('오늘'),
        ),
        SegmentedButton<_CalendarViewMode>(
          segments: const [
            ButtonSegment(value: _CalendarViewMode.month, label: Text('월')),
            ButtonSegment(value: _CalendarViewMode.week, label: Text('주')),
            ButtonSegment(value: _CalendarViewMode.agenda, label: Text('일정')),
          ],
          selected: {mode},
          onSelectionChanged: (selection) {
            if (selection.isNotEmpty) {
              onModeChanged(selection.first);
            }
          },
          showSelectedIcon: false,
        ),
        FilledButton.icon(
          onPressed: onCreateDiary,
          icon: const Icon(Icons.edit_note),
          label: const Text('새 일기'),
        ),
      ],
    );
  }
}

class _BoardBody extends StatelessWidget {
  const _BoardBody({
    required this.visibleMonth,
    required this.selectedDate,
    required this.calendar,
    required this.diaries,
    required this.todos,
    required this.mode,
    required this.onDateSelected,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final CalendarMonth calendar;
  final List<DiarySummary> diaries;
  final List<TodoItem> todos;
  final _CalendarViewMode mode;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final summaryByDate = {
      for (final summary in calendar.days) _dateKey(summary.date): summary,
    };
    final diariesByDate = _groupDiariesByDate(diaries);
    final todosByDate = _groupTodosByDate(todos);

    if (mode == _CalendarViewMode.agenda) {
      return _AgendaTimeline(
        visibleMonth: visibleMonth,
        summaryByDate: summaryByDate,
        diariesByDate: diariesByDate,
        todosByDate: todosByDate,
        selectedDate: selectedDate,
        onDateSelected: onDateSelected,
      );
    }

    final dates = mode == _CalendarViewMode.week
        ? _buildWeekCells(selectedDate)
        : _buildMonthCells(visibleMonth);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final spacing = compact ? 4.0 : 8.0;
        final cellExtent = _calendarDayCellExtent(
          boardWidth: constraints.maxWidth,
          spacing: spacing,
          compact: compact,
        );

        return Column(
          children: [
            _WeekdayHeader(compact: compact),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                mainAxisExtent: cellExtent,
              ),
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final date = dates[index];
                if (date == null) {
                  return const SizedBox.shrink();
                }

                final key = _dateKey(date);
                final dayTodos = todosByDate[key] ?? const [];
                final dayDiaries = diariesByDate[key] ?? const [];
                final summary = summaryByDate[key];

                return _CalendarDayCell(
                  date: date,
                  inVisibleMonth: date.month == visibleMonth.month,
                  isToday: _isSameDate(date, DateTime.now()),
                  isSelected: _isSameDate(date, selectedDate),
                  summary: summary,
                  diaries: dayDiaries,
                  todos: dayTodos,
                  compact: compact,
                  onTap: () => onDateSelected(date),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _AgendaTimeline extends StatelessWidget {
  const _AgendaTimeline({
    required this.visibleMonth,
    required this.summaryByDate,
    required this.diariesByDate,
    required this.todosByDate,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime visibleMonth;
  final Map<String, CalendarDaySummary> summaryByDate;
  final Map<String, List<DiarySummary>> diariesByDate;
  final Map<String, List<TodoItem>> todosByDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final days = _daysInMonth(visibleMonth).where((date) {
      final key = _dateKey(date);
      return summaryByDate.containsKey(key) ||
          (diariesByDate[key]?.isNotEmpty ?? false) ||
          (todosByDate[key]?.isNotEmpty ?? false);
    }).toList();

    if (days.isEmpty) {
      return const _EmptyState(
        icon: Icons.event_available_outlined,
        title: '이번 달 일정이 비어 있습니다.',
        message: '날짜를 선택해 일기나 TODO를 추가하세요.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final date in days)
          _AgendaDayRow(
            date: date,
            selected: _isSameDate(date, selectedDate),
            diaries: diariesByDate[_dateKey(date)] ?? const [],
            todos: todosByDate[_dateKey(date)] ?? const [],
            onTap: () => onDateSelected(date),
          ),
      ],
    );
  }
}

class _AgendaDayRow extends StatelessWidget {
  const _AgendaDayRow({
    required this.date,
    required this.selected,
    required this.diaries,
    required this.todos,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final List<DiarySummary> diaries;
  final List<TodoItem> todos;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final completed = todos.where((todo) => todo.completed).length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected
            ? scheme.primaryContainer.withValues(alpha: 0.5)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 54,
                  child: Column(
                    children: [
                      Text(
                        '${date.day}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      Text(_weekdayLabel(date)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final diary in diaries.take(2))
                        _EventChip(
                          icon: Icons.menu_book_outlined,
                          label: diary.title,
                          color: scheme.primary,
                        ),
                      if (todos.isNotEmpty)
                        _EventChip(
                          icon: Icons.task_alt_outlined,
                          label: 'TODO $completed/${todos.length}',
                          color: completed == todos.length
                              ? scheme.tertiary
                              : scheme.secondary,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.inVisibleMonth,
    required this.isToday,
    required this.isSelected,
    required this.summary,
    required this.diaries,
    required this.todos,
    required this.compact,
    required this.onTap,
  });

  final DateTime date;
  final bool inVisibleMonth;
  final bool isToday;
  final bool isSelected;
  final CalendarDaySummary? summary;
  final List<DiarySummary> diaries;
  final List<TodoItem> todos;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final completedTodos = todos.where((todo) => todo.completed).length;
    final diaryCount = diaries.isNotEmpty
        ? diaries.length
        : summary?.entryCount ?? 0;
    final todoCount = todos.isNotEmpty ? todos.length : summary?.todoCount ?? 0;
    final completedCount = todos.isNotEmpty
        ? completedTodos
        : summary?.completedTodoCount ?? 0;

    final background = isSelected
        ? scheme.primaryContainer.withValues(alpha: 0.72)
        : isToday
        ? scheme.tertiaryContainer.withValues(alpha: 0.45)
        : scheme.surface;
    final border = isSelected
        ? scheme.primary
        : isToday
        ? scheme.tertiary
        : scheme.outlineVariant;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(compact ? 6 : 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border, width: isSelected ? 2 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${date.day}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: inVisibleMonth
                          ? scheme.onSurface
                          : scheme.onSurfaceVariant.withValues(alpha: 0.55),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  if (diaryCount > 0 || todoCount > 0)
                    _DotCluster(
                      diaryCount: diaryCount,
                      todoCount: todoCount,
                      completedTodoCount: completedCount,
                    ),
                ],
              ),
              if (!compact) ...[
                const SizedBox(height: 8),
                if (diaries.isNotEmpty)
                  _EventChip(
                    icon: Icons.menu_book_outlined,
                    label: diaries.first.title,
                    color: scheme.primary,
                  )
                else if (diaryCount > 0)
                  _EventChip(
                    icon: Icons.menu_book_outlined,
                    label: '일기 $diaryCount건',
                    color: scheme.primary,
                  ),
                if (todoCount > 0) ...[
                  const SizedBox(height: 6),
                  _EventChip(
                    icon: Icons.task_alt_outlined,
                    label: 'TODO $completedCount/$todoCount',
                    color: completedCount == todoCount
                        ? scheme.tertiary
                        : scheme.secondary,
                  ),
                ],
                if (diaryCount == 0 && todoCount == 0) const Spacer(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DotCluster extends StatelessWidget {
  const _DotCluster({
    required this.diaryCount,
    required this.todoCount,
    required this.completedTodoCount,
  });

  final int diaryCount;
  final int todoCount;
  final int completedTodoCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (diaryCount > 0) _Dot(color: scheme.primary),
        if (todoCount > 0) ...[
          const SizedBox(width: 3),
          _Dot(
            color: completedTodoCount == todoCount
                ? scheme.tertiary
                : scheme.secondary,
          ),
        ],
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _EventChip extends StatelessWidget {
  const _EventChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 26),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedDateAgenda extends ConsumerWidget {
  const _SelectedDateAgenda({
    required this.date,
    required this.diaries,
    required this.todos,
    required this.onCreateDiary,
  });

  final DateTime date;
  final List<DiarySummary> diaries;
  final List<TodoItem> todos;
  final VoidCallback onCreateDiary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedCount = todos.where((todo) => todo.completed).length;

    return _SurfacePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _formatKoreanDate(date),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusPill(
                icon: Icons.menu_book_outlined,
                label: '일기 ${diaries.length}건',
              ),
              _StatusPill(
                icon: Icons.task_alt_outlined,
                label: 'TODO $completedCount/${todos.length}',
              ),
              const _StatusPill(icon: Icons.lock_outline, label: '비공개'),
            ],
          ),
          const SizedBox(height: 14),
          _PanelHeader(
            title: '일기',
            action: TextButton.icon(
              onPressed: onCreateDiary,
              icon: const Icon(Icons.edit_note),
              label: const Text('작성'),
            ),
          ),
          if (diaries.isEmpty)
            const _EmptyLine(text: '이 날짜에 작성된 일기가 없습니다.')
          else
            ...diaries.map((item) => _DateDiaryAction(item: item)),
          const SizedBox(height: 14),
          const _PanelHeader(title: 'TODO'),
          if (todos.isEmpty) const _EmptyLine(text: '등록된 TODO가 없습니다.'),
          ...todos.map((todo) => _TodoTile(todo: todo)),
          const SizedBox(height: 8),
          _TodoComposer(date: date),
          const SizedBox(height: 16),
          const _AvailabilityStrip(),
        ],
      ),
    );
  }
}

class _AvailabilityStrip extends StatelessWidget {
  const _AvailabilityStrip();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: 0.44),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.link_outlined, color: scheme.secondary),
            const SizedBox(width: 10),
            const Expanded(child: Text('가용성: 기록 가능')),
          ],
        ),
      ),
    );
  }
}

class _TodoTile extends ConsumerWidget {
  const _TodoTile({required this.todo});

  final TodoItem todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CheckboxListTile(
      dense: true,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 320;
        final input = TextField(
          controller: _controller,
          enabled: !_saving,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'TODO 추가',
            hintText: '할 일을 입력하세요',
          ),
          onSubmitted: (_) => _submit(),
        );
        final button = FilledButton.icon(
          onPressed: _saving ? null : _submit,
          icon: const Icon(Icons.add),
          label: const Text('추가'),
        );

        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [input, const SizedBox(height: 8), button],
          );
        }

        return Row(
          children: [
            Expanded(child: input),
            const SizedBox(width: 8),
            button,
          ],
        );
      },
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
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 16,
        child: Text(item.emotionCode.substring(0, 1)),
      ),
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

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: scheme.primary),
              const SizedBox(width: 10),
              Expanded(child: Text(label)),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Chip(
      avatar: Icon(icon, size: 17, color: scheme.primary),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({this.compact = false});

  final bool compact;

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
                  fontSize: compact ? 11 : null,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SurfacePanel extends StatelessWidget {
  const _SurfacePanel({
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(icon, size: 38, color: scheme.primary),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _LoadingSurface extends StatelessWidget {
  const _LoadingSurface({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 320,
        child: _SurfacePanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LinearProgressIndicator(),
              const SizedBox(height: 14),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorSurface extends StatelessWidget {
  const _ErrorSurface({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: SizedBox(
        width: 420,
        child: _SurfacePanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: scheme.error),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

double _calendarDayCellExtent({
  required double boardWidth,
  required double spacing,
  required bool compact,
}) {
  final usableWidth = boardWidth - spacing * 6;
  final columnWidth = usableWidth > 0 ? usableWidth / 7 : 0.0;
  final lowerBound = compact ? 54.0 : 96.0;
  final upperBound = compact ? 68.0 : 112.0;
  final preferred = compact ? columnWidth * 0.72 : columnWidth * 0.64;

  return preferred.clamp(lowerBound, upperBound).toDouble();
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

List<DateTime> _buildWeekCells(DateTime selectedDate) {
  final start = selectedDate.subtract(Duration(days: selectedDate.weekday % 7));
  return [
    for (var index = 0; index < 7; index++)
      DateTime(start.year, start.month, start.day + index),
  ];
}

List<DateTime> _daysInMonth(DateTime visibleMonth) {
  final lastDay = DateTime(visibleMonth.year, visibleMonth.month + 1, 0);
  return [
    for (var day = 1; day <= lastDay.day; day++)
      DateTime(visibleMonth.year, visibleMonth.month, day),
  ];
}

List<DiarySummary> _diariesOnDate(List<DiarySummary> diaries, DateTime date) {
  return diaries.where((item) => _isSameDate(item.entryDate, date)).toList();
}

List<TodoItem> _todosOnDate(List<TodoItem> todos, DateTime date) {
  return todos.where((item) => _isSameDate(item.dueDate, date)).toList();
}

List<TodoItem> _todosInMonth(List<TodoItem> todos, DateTime visibleMonth) {
  return todos.where((item) {
    return item.dueDate.year == visibleMonth.year &&
        item.dueDate.month == visibleMonth.month;
  }).toList();
}

Map<String, List<DiarySummary>> _groupDiariesByDate(
  List<DiarySummary> diaries,
) {
  final grouped = <String, List<DiarySummary>>{};
  for (final diary in diaries) {
    final key = _dateKey(diary.entryDate);
    grouped.putIfAbsent(key, () => []).add(diary);
  }
  return grouped;
}

Map<String, List<TodoItem>> _groupTodosByDate(List<TodoItem> todos) {
  final grouped = <String, List<TodoItem>>{};
  for (final todo in todos) {
    final key = _dateKey(todo.dueDate);
    grouped.putIfAbsent(key, () => []).add(todo);
  }
  return grouped;
}

Set<String> _activeDays(List<CalendarDaySummary> days, List<TodoItem> todos) {
  return {
    for (final day in days)
      if (day.entryCount > 0 || day.todoCount > 0) _dateKey(day.date),
    for (final todo in todos) _dateKey(todo.dueDate),
  };
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
  return '${value.year}년 ${value.month}월 ${value.day}일 ${_weekdayLabel(value)}요일';
}

String _weekdayLabel(DateTime value) {
  return ['월', '화', '수', '목', '금', '토', '일'][value.weekday - 1];
}
