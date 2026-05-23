import 'package:mongtory_diary/domain/models/todo_item.dart';
import 'package:mongtory_diary/domain/models/todo_upsert.dart';

abstract class TodoRepository {
  Future<List<TodoItem>> getTodos({
    required DateTime from,
    required DateTime to,
  });

  Future<TodoItem> createTodo(TodoUpsert input);
  Future<TodoItem> updateTodo(int todoId, TodoUpsert input);
  Future<void> deleteTodo(int todoId);
}
