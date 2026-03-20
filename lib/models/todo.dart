class Todo {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime? deadline;
  final String content;

  Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    this.deadline,
    this.content = '',
  });

  Todo copyWith({
    String? title,
    DateTime? deadline,
    String? content,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      deadline: deadline ?? this.deadline,
      content: content ?? this.content,
    );
  }
}
