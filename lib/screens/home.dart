import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:todo_native/widgets/add_todo.dart';
import 'package:todo_native/widgets/todo_item.dart';
import '../models/todo.dart';
import '../services/todo_storage_service.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoStorageService _storage = TodoStorageService();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _storage.loadTodoList();
    setState(() {
      _todos = todos;
    });
  }

  Future<void> _addTodo(String title) async {
    final newTodo = Todo(title: title, isDone: false);
    setState(() {
      _todos.add(newTodo);
    });
    await _storage.saveTodoList(_todos);
  }

  Future<void> _updateTodo(String title, int index) async {
    setState(() {
      _todos[index] = Todo(title: title, isDone: _todos[index].isDone);
    });
    await _storage.saveTodoList(_todos);
  }

  Future<void> _toggleTodo(int index) async {
    setState(() {
      final toggled = _todos[index].copyWith(isDone: !_todos[index].isDone);
      _todos.removeAt(index);

      if (toggled.isDone) {
        _todos.add(toggled); // move to end
      } else {
        _todos.insert(0, toggled); // move to top if unchecked
      }
    });

    await _storage.saveTodoList(_todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: ImplicitlyAnimatedList<Todo>(
        items: _todos,
        areItemsTheSame: (oldItem, newItem) => oldItem.title == newItem.title,
        itemBuilder: (context, animation, todo, index) {
          return SizeFadeTransition(
            animation: animation,
            key: ValueKey(todo.title),
            child: TodoItem(
              onToggle: (val) {
                _toggleTodo(index);
              },
              onUpdate: (newTitle) {
                _updateTodo(newTitle, index);
              },
              todo: todo,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AddTodoDialog(onAdd: _addTodo),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
