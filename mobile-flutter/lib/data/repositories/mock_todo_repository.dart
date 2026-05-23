import 'package:mongtory_diary/data/datasources/mock/mock_todo_datasource.dart';
import 'package:mongtory_diary/data/mappers/todo_mapper.dart';
import 'package:mongtory_diary/domain/models/todo_item.dart';
import 'package:mongtory_diary/domain/models/todo_upsert.dart';
import 'package:mongtory_diary/domain/repositories/todo_repository.dart';

class MockTodoRepository implements TodoRepository {
  const MockTodoRepository(this._dataSource);

  final MockTodoDataSource _dataSource;

  @override
  Future<List<TodoItem>> getTodos({
    required DateTime from,
    required DateTime to,
  }) async {
    final dtos = await _dataSource.getTodos(
      from: _formatDate(from),
      to: _formatDate(to),
    );
    return dtos.map(TodoMapper.toDomain).toList();
  }

  @override
  Future<TodoItem> createTodo(TodoUpsert input) async {
    final dto = await _dataSource.createTodo(TodoMapper.toUpsertRequest(input));
    return TodoMapper.toDomain(dto);
  }

  @override
  Future<TodoItem> updateTodo(int todoId, TodoUpsert input) async {
    final dto = await _dataSource.updateTodo(
      todoId,
      TodoMapper.toUpsertRequest(input),
    );
    return TodoMapper.toDomain(dto);
  }

  @override
  Future<void> deleteTodo(int todoId) {
    return _dataSource.deleteTodo(todoId);
  }

  String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
