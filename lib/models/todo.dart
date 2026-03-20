class Todo {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime? deadline;
  final String content;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    this.deadline,
    this.content = '',
    this.isCompleted = false,
  });

  Todo copyWith({
    String? title,
    DateTime? deadline,
    String? content,
    bool? isCompleted,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      deadline: deadline ?? this.deadline,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'content': content,
      'isCompleted': isCompleted,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      content: json['content'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
