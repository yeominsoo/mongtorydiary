class TodoUpsertRequestDto {
  const TodoUpsertRequestDto({
    required this.dueDate,
    required this.content,
    required this.completed,
  });

  final String dueDate;
  final String content;
  final bool completed;

  Map<String, Object?> toJson() {
    return {'dueDate': dueDate, 'content': content, 'completed': completed};
  }
}
