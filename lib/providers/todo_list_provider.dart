import 'package:flutter/material.dart';
import 'package:todo_native/models/todo_list.dart';
import 'package:todo_native/services/firestore_service.dart';

class ListProvider extends ChangeNotifier {
  List<TodoList> _todoLists = [];
  TodoList? _selectedList;

  List<TodoList> get todoLists => _todoLists;
  TodoList? get selectedList => _selectedList;

  void selectList(TodoList list) {
    _selectedList = list;
    notifyListeners();
  }

  void _setTodoLists(List<TodoList> lists) {
    _todoLists = lists;
    notifyListeners();
  }

  void setSelectedList(TodoList list) {
    if (_selectedList == list) return; // Prevent unnecessary updates
    _selectedList = list;
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