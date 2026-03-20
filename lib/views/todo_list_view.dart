import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'todo_add_view.dart';
import 'todo_edit_view.dart';

class TodoListView extends StatefulWidget {
  final List<Todo> activeTodos;
  final List<Todo> completedTodos;
  final void Function(Todo) onAdd;
  final void Function(Todo) onUpdate;
  final void Function(String) onComplete;
  final void Function(String) onDelete;
  final void Function(int oldIndex, int newIndex) onReorder;

  const TodoListView({
    super.key,
    required this.activeTodos,
    required this.completedTodos,
    required this.onAdd,
    required this.onUpdate,
    required this.onComplete,
    required this.onDelete,
    required this.onReorder,
  });

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openAddView() async {
    final newTodo = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (_) => const TodoAddView()),
    );
    if (newTodo != null) widget.onAdd(newTodo);
  }

  Future<void> _openEditView(Todo todo) async {
    final result = await Navigator.push<TodoEditResult>(
      context,
      MaterialPageRoute(
        builder: (_) => TodoEditView(
          todo: todo,
          onDelete: () => widget.onDelete(todo.id),
        ),
      ),
    );
    if (result == null) return;
    if (result.isCompleted) {
      widget.onComplete(todo.id);
    } else {
      widget.onUpdate(result.todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActiveTab = _tabController.index == 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TODOリスト'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'TODO'),
            Tab(text: '完了'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveList(),
          _buildCompletedList(),
        ],
      ),
      floatingActionButton: isActiveTab
          ? FloatingActionButton(
              onPressed: _openAddView,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildActiveList() {
    if (widget.activeTodos.isEmpty) {
      return const Center(child: Text('TODOがありません'));
    }
    return ReorderableListView.builder(
      itemCount: widget.activeTodos.length,
      onReorder: widget.onReorder,
      itemBuilder: (context, index) {
        final todo = widget.activeTodos[index];
        return ListTile(
          key: ValueKey(todo.id),
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
          trailing: const Icon(Icons.drag_handle),
          onTap: () => _openEditView(todo),
        );
      },
    );
  }

  Widget _buildCompletedList() {
    if (widget.completedTodos.isEmpty) {
      return const Center(child: Text('完了したTODOがありません'));
    }
    return ListView.builder(
      itemCount: widget.completedTodos.length,
      itemBuilder: (context, index) {
        final todo = widget.completedTodos[index];
        return ListTile(
          title: Text(
            todo.title,
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
          subtitle: todo.deadline != null
              ? Text(
                  '締切: ${_formatDate(todo.deadline!)}',
                  style: const TextStyle(color: Colors.grey),
                )
              : null,
          onTap: () => _openEditView(todo),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}
