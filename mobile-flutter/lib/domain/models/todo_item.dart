class TodoItem {
  const TodoItem({
    required this.id,
    required this.dueDate,
    required this.content,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final DateTime dueDate;
  final String content;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;
}
