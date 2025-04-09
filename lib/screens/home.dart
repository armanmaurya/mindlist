import 'package:flutter/material.dart';
import 'package:todo_native/controllers/todo_controller.dart';
import 'package:todo_native/widgets/add_todo.dart';
import 'package:todo_native/widgets/create_list_dialog.dart';
import 'package:todo_native/widgets/todo_list_view.dart';
import 'package:todo_native/widgets/list_selector_bottom_sheet.dart';
import 'package:todo_native/widgets/home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoController _todoController = TodoController();

  @override
  void initState() {
    super.initState();
    _todoController.loadTodosForList(0); // Load the first list by default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(todoController: _todoController),
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
