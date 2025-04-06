import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:todo_native/widgets/add_todo.dart';
import 'package:todo_native/widgets/todo_item.dart';
import '../models/todo.dart';
import '../services/todo_storage_service.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoStorageService _storage = TodoStorageService();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _storage.loadTodoList();
    setState(() {
      _todos = todos;
    });
  }

  Future<void> _addTodo(String title) async {
    final newTodo = Todo(title: title, isDone: false);
    setState(() {
      _todos.insert(0, newTodo); // Add the new task at the start of the list
    });
    await _storage.saveTodoList(_todos);
  }

  Future<void> _updateTodo(String title, int index) async {
    setState(() {
      _todos[index] = Todo(title: title, isDone: _todos[index].isDone);
    });
    await _storage.saveTodoList(_todos);
  }

  Future<void> _deleteTodo(int index) async {
    setState(() {
      _todos.removeAt(index);
    });
    await _storage.saveTodoList(_todos);
  }

  Future<void> _toggleTodo(int index) async {
    setState(() {
      final toggled = _todos[index].copyWith(isDone: !_todos[index].isDone);

      // Remove the item from its current position
      _todos.removeAt(index);

      if (toggled.isDone) {
        // If the item is marked as done, move it to the end
        _todos.add(toggled);
      } else {
        // If the item is unchecked and already at the top, don't reorder
        if (index == 0) {
          _todos.insert(0, toggled);
        } else {
          _todos.insert(index, toggled);
        }
      }
    });

    await _storage.saveTodoList(_todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: ImplicitlyAnimatedReorderableList<Todo>(
        onReorderStarted: (item, index) {},
        items: _todos,
        areItemsTheSame: (oldItem, newItem) => oldItem.title == newItem.title,
        onReorderFinished: (item, from, to, newItems) {
          setState(() {
            _todos
              ..clear()
              ..addAll(newItems);
          });
        },
        itemBuilder: (context, itemAnimation, todo, index) {
          return Reorderable(
            key: ValueKey(todo.title),
            builder: (context, dragAnimation, inDrag) {
              final t = dragAnimation.value; // Animation value for drag
              final elevation = lerpDouble(0, 8, t);
              final color = Color.lerp(
                Colors.white,
                Colors.white.withValues(alpha: 0.8),
                t,
              );
              return SizeFadeTransition(
                sizeFraction: 1,
                curve: Curves.easeInOut,
                animation: itemAnimation,
                child: AnimatedScale(
                  scale:
                      inDrag
                          ? 1.1
                          : 1.0, // Scale up while dragging, reset after drop
                  duration: const Duration(
                    milliseconds: 200,
                  ), // Smooth transition duration
                  curve: Curves.easeInOut, // Smooth easing curve
                  child: Material(
                    color: color,
                    elevation: elevation!,
                    type: MaterialType.transparency,
                    child: TodoItem(
                      onDelete: () => _deleteTodo(index),
                      onToggle: (val) {
                        _toggleTodo(index);
                      },
                      onUpdate: (newTitle) {
                        _updateTodo(newTitle, index);
                      },
                      todo: todo,
                    ),
                  ),
                ),
              );
            },
          );
        },
        shrinkWrap: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AddTodoDialog(onAdd: _addTodo),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
