class TodoUpsert {
  const TodoUpsert({
    required this.dueDate,
    required this.content,
    required this.completed,
  });

  final DateTime dueDate;
  final String content;
  final bool completed;
}
