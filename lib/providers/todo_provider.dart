import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_native/models/todo.dart';
import 'package:todo_native/models/todo_list.dart';

class TodoProvider with ChangeNotifier {
  final Box<TodoList> _box = Hive.box<TodoList>('todoLists');
  int _activeListIndex = 0;

  List<Todo> get todos => _box.getAt(_activeListIndex)?.items ?? [];

  void setActiveList(int index) {
    _activeListIndex = index;
    notifyListeners();
  }
}