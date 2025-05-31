import 'package:flutter/material.dart';
import 'package:todo_native/models/todo_list.dart';
import 'package:todo_native/services/firestore_service.dart';

class ListProvider extends ChangeNotifier {
  List<TodoList> _todoLists = [];
  String? _selectedList;

  List<TodoList> get todoLists => _todoLists;
  String? get selectedList => _selectedList;

  void selectList(String title) {
    _selectedList = title;
    notifyListeners();
  }

  void _setTodoLists(List<TodoList> lists) {
    _todoLists = lists;
    notifyListeners();
  }

  void fetchAllTodoLists() {
    FirestoreService().todoListsStream().listen((snapshot) {
      final lists = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return TodoList.fromJson(data);
      }).toList();
      _setTodoLists(lists);
    });
  }
}