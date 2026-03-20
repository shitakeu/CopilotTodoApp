import 'package:flutter/material.dart';
import 'models/todo.dart';
import 'views/todo_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CopilotTodoApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoApp(),
    );
  }
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final List<Todo> _todos = [];

  void _addTodo(Todo todo) {
    setState(() => _todos.add(todo));
  }

  void _updateTodo(Todo updated) {
    setState(() {
      final index = _todos.indexWhere((t) => t.id == updated.id);
      if (index != -1) _todos[index] = updated;
    });
  }

  void _deleteTodo(String id) {
    setState(() => _todos.removeWhere((t) => t.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return TodoListView(
      todos: _todos,
      onAdd: _addTodo,
      onUpdate: _updateTodo,
      onDelete: _deleteTodo,
    );
  }
}
