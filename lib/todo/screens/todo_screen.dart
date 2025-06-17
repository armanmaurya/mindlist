import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_native/todo/models/todo.dart';
import 'package:todo_native/todo/models/todo_list.dart';
import 'package:todo_native/todo/providers/todo_list_provider.dart';
import 'package:todo_native/shared/widgets/forms/text_edit_form.dart';
import 'package:todo_native/todo/widgets/todo_list_view.dart';
import 'package:todo_native/todo/services/firestore_service.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  List<Todo> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final listProvider = Provider.of<ListProvider>(context, listen: false);
      _listenToTodos(listProvider.selectedList);
    });
  }

  void _listenToTodos(TodoList? selectedList) {
    if (selectedList == null) return;
    setState(() {
      _isLoading = true;
    });
    _todosStreamSub?.cancel();
    _todosStreamSub = FirestoreService()
        .todosStream(selectedList.id)
        .listen((snapshot) {
      final todoList = snapshot.docs.map((doc) {
        final data = doc.data();
        return Todo.fromJson(data..['id'] = doc.id);
      }).toList();
      setState(() {
        _todos = todoList;
        _isLoading = false;
      });
    });
  }

  StreamSubscription? _todosStreamSub;

  @override
  void dispose() {
    _todosStreamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context);
    final selectedList = listProvider.selectedList;
    final undoneTodos = _todos.where((t) => !t.isDone).toList();
    final doneTodos = _todos.where((t) => t.isDone).toList();

    Widget buildBody() {
      if (_isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_todos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'No todos yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          if (undoneTodos.isNotEmpty)
            TodoListView(todos: undoneTodos),
          if (doneTodos.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 16.0),
              child: Text(
                'Completed',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            TodoListView(todos: doneTodos),
          ],
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(selectedList?.title ?? 'Todos')),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) => TextEditForm(
              onSave: (title) async {
                if (title.trim().isNotEmpty && selectedList != null) {
                  FirestoreService().createTodo(
                    listId: selectedList.id,
                    title: title.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              title: 'Create Todo',
              buttonText: 'Create',
              hintText: 'Enter todo title',
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
