import 'package:mongtory_diary/data/dto/todo_item_response_dto.dart';
import 'package:mongtory_diary/data/dto/todo_upsert_request_dto.dart';
import 'package:mongtory_diary/domain/models/todo_item.dart';
import 'package:mongtory_diary/domain/models/todo_upsert.dart';

class TodoMapper {
  const TodoMapper._();

  static TodoItem toDomain(TodoItemResponseDto dto) {
    return TodoItem(
      id: dto.id,
      dueDate: DateTime.parse(dto.dueDate),
      content: dto.content,
      completed: dto.completed,
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: DateTime.parse(dto.updatedAt),
    );
  }

  static TodoUpsertRequestDto toUpsertRequest(TodoUpsert input) {
    return TodoUpsertRequestDto(
      dueDate: _formatDate(input.dueDate),
      content: input.content,
      completed: input.completed,
    );
  }

  static String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
