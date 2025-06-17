// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import '../models/todo.dart';
// import '../models/todo_list.dart';

// class DuplicateTodoTitleException implements Exception {
//   final String message;
//   DuplicateTodoTitleException(this.message);

//   @override
//   String toString() => message;
// }

// /// To-doController is responsible for managing the todo lists and their items.
// class TodoController {
//   final Box<TodoList> _box = Hive.box<TodoList>('todoLists');
//   final ValueNotifier<List<Todo>> todos = ValueNotifier([]);
//   final ValueNotifier<String> currentTitle = ValueNotifier('');

//   late int _activeListIndex = 0;
//   int _lastTodoId = 0;

//   /// Set the active list you're currently editing.
//   void loadTodosForList(int index) {
//     _activeListIndex = index;
//     todos.value = _box.getAt(index)?.items ?? [];
//     currentTitle.value = _box.getAt(index)?.title ?? '';
//     // Update _lastTodoId to max id in current list
//     if (todos.value.isNotEmpty) {
//       final maxId = todos.value
//           .map((t) => int.tryParse(t.id) ?? 0)
//           .fold<int>(0, (prev, curr) => curr > prev ? curr : prev);
//       _lastTodoId = maxId;
//     }
//   }

//   /// Create a new List
//   Future<void> createList(String title) async {
//     final newList = TodoList(title: title, items: []);
//     await _box.add(newList);
//     _activeListIndex = _box.length - 1; // Set the new list as active
//     todos.value = newList.items;
//     currentTitle.value = newList.title; // Update title
//   }

//   // Delete List 
//   Future<void> deleteList(int index) async {
//     await _box.deleteAt(index);
//     if (_box.isNotEmpty) {
//       _activeListIndex = index == 0 ? 0 : index - 1; // Set the previous list as active
//       loadTodosForList(_activeListIndex);
//     } else {
//       todos.value = []; // Clear todos if no lists are left
//       currentTitle.value = ''; // Clear title
//     }
//   }

//   /// Save current todos back to Hive
//   Future<void> _saveToBox() async {
//     final currentList = _box.getAt(_activeListIndex);
//     if (currentList != null) {
//       currentList.items = todos.value;
//       await currentList.save(); // since it's a HiveObject
//     }
//   }

//   List<TodoList> getAllLists() => _box.values.toList();

//   TodoList getList(int index) => _box.getAt(index)!;

//   Future<void> addTodo(String title) async {
//     if (todos.value.any((todo) => todo.title == title)) {
//       throw DuplicateTodoTitleException('Todo "$title" already exists.');
//     }
//     _lastTodoId++;
//     final newTodo = Todo(title: title, isDone: false, id: _lastTodoId.toString());
//     todos.value = [newTodo, ...todos.value];
//     await _saveToBox();
//   }

//   Future<void> updateTodo(String title, String id) async {
//     if (todos.value.any((todo) => todo.title == title && todo.id != id)) {
//       throw DuplicateTodoTitleException('Todo "$title" already exists.');
//     }
//     final updated = todos.value.toList();
//     final idx = updated.indexWhere((t) => t.id == id);
//     if (idx == -1) return;
//     updated[idx] = Todo(title: title, isDone: updated[idx].isDone, id: id);
//     todos.value = updated;
//     await _saveToBox();
//   }

//   Future<void> deleteTodo(String id) async {
//     final updated = todos.value.toList();
//     updated.removeWhere((t) => t.id == id);
//     todos.value = updated;
//     await _saveToBox();
//   }

//   Future<void> saveReorderedTodos(List<Todo> newList) async {
//     todos.value = newList;
//     await _saveToBox();
//   }

//   Future<void> toggleTodo(String id) async {
//     final updated = todos.value.toList();
//     final idx = updated.indexWhere((t) => t.id == id);
//     if (idx == -1) return;
//     updated[idx] = Todo(
//       title: updated[idx].title,
//       isDone: !updated[idx].isDone,
//       id: id,
//     );
//     todos.value = updated;
//     await _saveToBox();
//   }
// }
