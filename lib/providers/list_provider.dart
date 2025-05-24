import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_native/models/todo_list.dart';

class ListProvider with ChangeNotifier {
  final Box<TodoList> _box = Hive.box<TodoList>('todoLists');

  List<String> get list => _box.values.map((list) => list.title).toList();

  void addList(String title) {
    final newList = TodoList(title: title, items: []);
    _box.add(newList);
    notifyListeners();
  }

  void deleteList(int index) {
    _box.deleteAt(index);
    notifyListeners();
  }

  void updateList(int index, String newTitle) {
    final list = _box.getAt(index);
    if (list != null) {
      list.title = newTitle;
      list.save();
      notifyListeners();
    }
  }
}