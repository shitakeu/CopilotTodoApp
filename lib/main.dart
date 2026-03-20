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
  final List<Todo> _activeTodos = [];
  final List<Todo> _completedTodos = [];

  void _addTodo(Todo todo) {
    setState(() => _activeTodos.add(todo));
  }

  void _updateTodo(Todo updated) {
    setState(() {
      final activeIndex = _activeTodos.indexWhere((t) => t.id == updated.id);
      if (activeIndex != -1) {
        _activeTodos[activeIndex] = updated;
        return;
      }
      final completedIndex =
          _completedTodos.indexWhere((t) => t.id == updated.id);
      if (completedIndex != -1) {
        _completedTodos[completedIndex] = updated;
      }
    });
  }

  void _completeTodo(String id) {
    setState(() {
      final index = _activeTodos.indexWhere((t) => t.id == id);
      if (index != -1) {
        final todo = _activeTodos.removeAt(index);
        _completedTodos.add(todo.copyWith(isCompleted: true));
      }
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      _activeTodos.removeWhere((t) => t.id == id);
      _completedTodos.removeWhere((t) => t.id == id);
    });
  }

  void _reorderTodos(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final todo = _activeTodos.removeAt(oldIndex);
      _activeTodos.insert(newIndex, todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TodoListView(
      activeTodos: _activeTodos,
      completedTodos: _completedTodos,
      onAdd: _addTodo,
      onUpdate: _updateTodo,
      onComplete: _completeTodo,
      onDelete: _deleteTodo,
      onReorder: _reorderTodos,
    );
  }
}
