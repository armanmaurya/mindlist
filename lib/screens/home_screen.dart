import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_native/controllers/todo_controller.dart';
import 'package:todo_native/screens/google_signin_screen.dart';
import 'package:todo_native/widgets/add_todo.dart';
import 'package:todo_native/widgets/todo_list_view.dart';
import 'package:todo_native/widgets/home_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      appBar: AppBar(
        title: HomeAppBar(todoController: _todoController),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              GoogleSignIn().signOut();
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => const GoogleSignInScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: TodoListView(controller: _todoController),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) => AddTodoBottomSheet(onAdd: _todoController.addTodo),
            useSafeArea: true,
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
