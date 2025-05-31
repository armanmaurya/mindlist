import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_native/models/todo_list.dart';
import 'package:todo_native/widgets/add_todo.dart';
import 'package:todo_native/widgets/todo_list_view.dart';
import 'package:todo_native/widgets/home_app_bar.dart';
import 'package:todo_native/widgets/buttons/logout_button.dart';
import 'package:provider/provider.dart';
import 'package:todo_native/providers/todo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HomeAppBar(
          // onListSelected: (selectedList) {
          //   todoProvider.setSelectedList(selectedList);
          // },
        ), 
        actions: [const LogoutButton()],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, provider, _) {
          if (provider.selectedList == null) {
            return const Center(child: Text('Select a list to view todos.'));
          }
          return TodoListView(todos: provider.todos);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) => AddTodoBottomSheet(
              onAdd: (title) {
                if (title.trim().isNotEmpty) {
                  Provider.of<TodoProvider>(context, listen: false).addTodo(title);
                }
              },
            ),
            useSafeArea: true,
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
