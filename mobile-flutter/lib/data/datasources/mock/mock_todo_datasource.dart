import 'package:mongtory_diary/data/dto/todo_item_response_dto.dart';
import 'package:mongtory_diary/data/dto/todo_upsert_request_dto.dart';

class MockTodoDataSource {
  const MockTodoDataSource();

  static final List<TodoItemResponseDto> _todos = [
    const TodoItemResponseDto(
      id: 301,
      dueDate: '2026-03-20',
      content: '출품용 캘린더 화면 다듬기',
      completed: false,
      createdAt: '2026-03-20T09:00:00',
      updatedAt: '2026-03-20T09:00:00',
    ),
    const TodoItemResponseDto(
      id: 302,
      dueDate: '2026-03-20',
      content: '몽토리 메뉴 점검',
      completed: true,
      createdAt: '2026-03-20T10:00:00',
      updatedAt: '2026-03-20T10:30:00',
    ),
  ];

  Future<List<TodoItemResponseDto>> getTodos({
    required String from,
    required String to,
  }) async {
    final fromDate = DateTime.parse(from);
    final toDate = DateTime.parse(to);

    return _todos.where((todo) {
      final dueDate = DateTime.parse(todo.dueDate);
      return !dueDate.isBefore(fromDate) && !dueDate.isAfter(toDate);
    }).toList();
  }

  Future<TodoItemResponseDto> createTodo(TodoUpsertRequestDto request) async {
    final now = DateTime.now();
    final todo = TodoItemResponseDto(
      id: _nextId,
      dueDate: request.dueDate,
      content: request.content,
      completed: request.completed,
      createdAt: _formatDateTime(now),
      updatedAt: _formatDateTime(now),
    );
    _todos.add(todo);
    return todo;
  }

  Future<TodoItemResponseDto> updateTodo(
    int todoId,
    TodoUpsertRequestDto request,
  ) async {
    final index = _todos.indexWhere((todo) => todo.id == todoId);
    if (index == -1) {
      throw StateError('Todo item not found');
    }

    final current = _todos[index];
    final updated = TodoItemResponseDto(
      id: current.id,
      dueDate: request.dueDate,
      content: request.content,
      completed: request.completed,
      createdAt: current.createdAt,
      updatedAt: _formatDateTime(DateTime.now()),
    );
    _todos[index] = updated;
    return updated;
  }

  Future<void> deleteTodo(int todoId) async {
    _todos.removeWhere((todo) => todo.id == todoId);
  }

  int get _nextId {
    if (_todos.isEmpty) {
      return 301;
    }

    return _todos.map((todo) => todo.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  String _formatDateTime(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '${value.year}-$month-${day}T$hour:$minute:$second';
  }
}
