import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_native/models/todo.dart';
import 'package:todo_native/models/todo_list.dart';
import 'package:todo_native/providers/todo_list_provider.dart';
import 'package:todo_native/widgets/bottom_sheets/edit_text_bottom_sheet.dart';
import 'package:todo_native/widgets/todo_list_view.dart';
import 'package:todo_native/services/firestore_service.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(selectedList?.title ?? 'Todos')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TodoListView(todos: _todos),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) => EditTextBottomSheet(
              onSave: (title) async {
                if (title.trim().isNotEmpty && selectedList != null) {
                  await FirestoreService().createTodo(
                    listId: selectedList.id,
                    title: title.trim(),
                  );
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
