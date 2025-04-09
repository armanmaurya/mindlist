import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/todo.dart';
import '../models/todo_list.dart';

class DuplicateTodoTitleException implements Exception {
  final String message;
  DuplicateTodoTitleException(this.message);

  @override
  String toString() => message;
}

class TodoController {
  final Box<TodoList> _box = Hive.box<TodoList>('todoLists');
  final ValueNotifier<List<Todo>> todos = ValueNotifier([]);
  final ValueNotifier<String> currentTitle = ValueNotifier(''); // Add this line

  late int _activeListIndex = 0;

  /// Set the active list you're currently editing.
  void loadTodosForList(int index) {
    _activeListIndex = index;
    todos.value = _box.getAt(index)?.items ?? [];
    currentTitle.value = _box.getAt(index)?.title ?? ''; // Update title
  }

  // Create a new List
  Future<void> createNewList(String title) async {
    final newList = TodoList(title: title, items: []);
    await _box.add(newList);
    _activeListIndex = _box.length - 1; // Set the new list as active
    todos.value = newList.items;
    currentTitle.value = newList.title; // Update title
  }

  /// Save current todos back to Hive
  Future<void> _saveToBox() async {
    final currentList = _box.getAt(_activeListIndex);
    if (currentList != null) {
      currentList.items = todos.value;
      await currentList.save(); // since it's a HiveObject
    }
  }

  List<TodoList> getAllLists() => _box.values.toList();

  TodoList getList(int index) => _box.getAt(index)!;

  Future<void> addTodo(String title) async {
    if (todos.value.any((todo) => todo.title == title)) {
      throw DuplicateTodoTitleException('Todo "$title" already exists.');
    }
    final newTodo = Todo(title: title, isDone: false);
    todos.value = [newTodo, ...todos.value];
    await _saveToBox();
  }

  Future<void> updateTodo(String title, int index) async {
    if (todos.value.any((todo) =>
        todo.title == title && todos.value.indexOf(todo) != index)) {
      throw DuplicateTodoTitleException('Todo "$title" already exists.');
    }

    final updated = todos.value.toList();
    updated[index] = Todo(title: title, isDone: updated[index].isDone);
    todos.value = updated;
    await _saveToBox();
  }

  Future<void> deleteTodo(int index) async {
    final updated = todos.value.toList();
    updated.removeAt(index);
    todos.value = updated;
    await _saveToBox();
  }

  Future<void> saveReorderedTodos(List<Todo> newList) async {
    todos.value = newList;
    await _saveToBox();
  }

  Future<void> toggleTodo(int index) async {
    final updated = todos.value.toList();
    updated[index] = Todo(
      title: updated[index].title,
      isDone: !updated[index].isDone,
    );
    todos.value = updated;
    await _saveToBox();
  }
}
