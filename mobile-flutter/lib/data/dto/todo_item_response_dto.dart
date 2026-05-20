class TodoItemResponseDto {
  const TodoItemResponseDto({
    required this.id,
    required this.dueDate,
    required this.content,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String dueDate;
  final String content;
  final bool completed;
  final String createdAt;
  final String updatedAt;

  factory TodoItemResponseDto.fromJson(Map<String, dynamic> json) {
    return TodoItemResponseDto(
      id: json['id'] as int? ?? 0,
      dueDate: json['dueDate'] as String? ?? '',
      content: json['content'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}
