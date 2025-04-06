import 'package:flutter/material.dart';
import 'package:todo_native/widgets/add_todo.dart';
import '../models/todo.dart';
import '../services/todo_storage_service.dart';

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

  Future<void> _toggleTodo(int index) async {
    setState(() {
      _todos[index] = Todo(
        title: _todos[index].title,
        isDone: !_todos[index].isDone,
      );
    });
    await _storage.saveTodoList(_todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return ListTile(
            title: Text(todo.title),
            leading: Checkbox(
              value: todo.isDone,
              onChanged: (val) => _toggleTodo(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AddTodoDialog(onAdd: _addTodo)
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
