import 'package:flutter/material.dart';
import 'package:todo_native/controllers/todo_controller.dart';
import 'package:todo_native/widgets/add_todo.dart';
import 'package:todo_native/widgets/todo_list_view.dart';

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
    // _todoController.loadTodos();
    _todoController.loadTodosForList(0); // Load the first list by default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IntrinsicWidth(
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  final allList = _todoController.getAllLists();
                  if (allList.isEmpty) {
                    return const Center(child: Text("No lists available"));
                  }
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: ListView.builder(
                        itemCount: allList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              allList[index].title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              _todoController.loadTodosForList(index);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            child: Row(
              children: [
                ValueListenableBuilder<String>( // Use ValueListenableBuilder
                  valueListenable: _todoController.currentTitle,
                  builder: (context, title, child) {
                    return Text(
                      title, // Dynamic title from ValueNotifier
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
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
