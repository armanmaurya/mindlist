
import 'package:flutter/material.dart';
import 'package:todo_native/models/todo.dart';
import 'package:todo_native/services/todo_storage_service.dart';

class TodoController {
  final TodoStorageService _storage = TodoStorageService();

  final ValueNotifier<List<Todo>> todos = ValueNotifier([]);

  Future<void> loadTodos() async {
    todos.value = await _storage.loadTodoList();
  }

  Future<void> addTodo(String title) async {
    final newTodo = Todo(title: title, isDone: false);
    todos.value = [newTodo, ...todos.value];
    await _storage.saveTodoList(todos.value);
  }

  Future<void> updateTodo(String title, int index) async {
    final updated = todos.value.toList();
    updated[index] = Todo(title: title, isDone: updated[index].isDone);
    todos.value = updated;
    await _storage.saveTodoList(todos.value);
  }

  Future<void> deleteTodo(int index) async {
    final updated = todos.value.toList()..removeAt(index);
    todos.value = updated;
    await _storage.saveTodoList(todos.value);
  }

  Future<void> toggleTodo(int index) async {
    final updated = todos.value.toList();
    final toggled = updated[index].copyWith(isDone: !updated[index].isDone);
    updated.removeAt(index);
    if (toggled.isDone) {
      updated.add(toggled);
    } else {
      updated.insert(index == 0 ? 0 : index, toggled);
    }
    todos.value = updated;
    await _storage.saveTodoList(updated);
  }

  Future<void> saveReorderedTodos(List<Todo> newList) async {
    todos.value = newList;
    await _storage.saveTodoList(newList);
  }

}