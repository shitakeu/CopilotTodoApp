import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'todo_add_view.dart';
import 'todo_edit_view.dart';

class TodoListView extends StatelessWidget {
  final List<Todo> todos;
  final void Function(Todo) onAdd;
  final void Function(Todo) onUpdate;
  final void Function(String) onDelete;

  const TodoListView({
    super.key,
    required this.todos,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOリスト'),
      ),
      body: todos.isEmpty
          ? const Center(child: Text('TODOがありません'))
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: todo.deadline != null
                      ? Text(
                          '締切: ${_formatDate(todo.deadline!)}',
                          style: TextStyle(
                            color: todo.deadline!.isBefore(DateTime.now())
                                ? Colors.red
                                : null,
                          ),
                        )
                      : null,
                  onTap: () async {
                    final updated = await Navigator.push<Todo>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TodoEditView(
                          todo: todo,
                          onDelete: () => onDelete(todo.id),
                        ),
                      ),
                    );
                    if (updated != null) {
                      onUpdate(updated);
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await Navigator.push<Todo>(
            context,
            MaterialPageRoute(builder: (_) => const TodoAddView()),
          );
          if (newTodo != null) {
            onAdd(newTodo);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}
