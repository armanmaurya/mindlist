import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoStorageService {
  static const String _key = "todo-list";

  Future<void> saveTodoList(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final todoStrings = todos.map((todo) => json.encode(todo.toJson())).toList();
    await prefs.setStringList(_key, todoStrings);
  }


  Future<List<Todo>> loadTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    final todoStrings = prefs.getStringList(_key);

    if (todoStrings == null) return [];

    return todoStrings.map((str) {
      final jsonMap = json.decode(str);
      return Todo.fromJson(jsonMap);
    }).toList();
  }

  Future<void> clearTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}