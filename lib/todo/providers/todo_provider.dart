import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_native/todo/models/todo.dart';
import 'package:todo_native/todo/models/todo_list.dart';
import 'package:todo_native/todo/services/firestore_service.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  TodoList? _selectedList;
  StreamSubscription? _todosSubscription;

  List<Todo> get todos => _todos;
  TodoList? get selectedList => _selectedList;

  void setSelectedList(TodoList? list) {
    if (_selectedList?.id == list?.id) return; // Prevent unnecessary updates
    _selectedList = list;
    _todosSubscription?.cancel();
    if (list != null) {
      _todosSubscription = FirestoreService().todosStream(list.id).listen((snapshot) {
        _todos = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return Todo.fromJson(data);
        }).toList();
        notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }

  Future<void> addTodo(String title) async {
    print("whatthis");
    print("selectedList: ${_selectedList?.id}");
    if (_selectedList != null) {
      print("alsorunned");
      await FirestoreService().createTodo(title: title, listId: _selectedList!.id);
    }
  }

  @override
  void dispose() {
    _todosSubscription?.cancel();
    super.dispose();
  }
}
