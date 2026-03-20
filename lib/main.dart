import 'package:flutter/material.dart';
import 'models/todo.dart';
import 'services/todo_storage.dart';
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
  List<Todo> _activeTodos = [];
  List<Todo> _completedTodos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final data = await TodoStorage.load();
    setState(() {
      _activeTodos = data.active;
      _completedTodos = data.completed;
      _isLoading = false;
    });
  }

  Future<void> _persist() async {
    await TodoStorage.save(
      active: _activeTodos,
      completed: _completedTodos,
    );
  }

  void _addTodo(Todo todo) {
    setState(() => _activeTodos.add(todo));
    _persist();
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
    _persist();
  }

  void _completeTodo(String id) {
    setState(() {
      final index = _activeTodos.indexWhere((t) => t.id == id);
      if (index != -1) {
        final todo = _activeTodos.removeAt(index);
        _completedTodos.add(todo.copyWith(isCompleted: true));
      }
    });
    _persist();
  }

  void _deleteTodo(String id) {
    setState(() {
      _activeTodos.removeWhere((t) => t.id == id);
      _completedTodos.removeWhere((t) => t.id == id);
    });
    _persist();
  }

  void _reorderTodos(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final todo = _activeTodos.removeAt(oldIndex);
      _activeTodos.insert(newIndex, todo);
    });
    _persist();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
