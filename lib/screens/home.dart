import 'package:flutter/material.dart';
import 'package:todo_native/controllers/todo_controller.dart';
import 'package:todo_native/widgets/add_todo.dart';
import 'package:todo_native/widgets/todo_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoController _todoController = TodoController();

  @override
  void initState() {
    super.initState();
    _todoController.loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: TodoListView(controller: _todoController),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AddTodoDialog(onAdd: _todoController.addTodo),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
