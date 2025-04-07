import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:todo_native/controllers/todo_controller.dart';
import 'package:todo_native/widgets/add_todo.dart';
import 'package:todo_native/widgets/todo_item.dart';
import '../models/todo.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoController _todoController = TodoController();

  @override
  void initState() {
    super.initState();
    _todoController.loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: ValueListenableBuilder<List<Todo>>(
        valueListenable: _todoController.todos,
        builder:(context, todos, _) {
          if (todos.isEmpty) {
            return const Center(child: Text("List is Empty"));
          }

          return ImplicitlyAnimatedReorderableList<Todo>(
            items: todos,
            areItemsTheSame: (oldItem, newItem) => oldItem.title == newItem.title,
            onReorderFinished: (item, from, to, newItems) {
              _todoController.saveReorderedTodos(newItems);
            },
            itemBuilder: (context, itemAnimation, todo, index) {
              return Reorderable(
                key: ValueKey(todo.title),
                builder: (context, dragAnimation, inDrag) {
                  final t = dragAnimation.value;
                  final elevation = lerpDouble(0, 8, t);
                  final color = Color.lerp(Colors.white, Colors.white.withOpacity(0.8), t);
                  return SizeFadeTransition(
                    sizeFraction: 1,
                    curve: Curves.easeInOut,
                    animation: itemAnimation,
                    child: AnimatedScale(
                      scale: inDrag ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Material(
                        color: color,
                        elevation: elevation!,
                        type: MaterialType.transparency,
                        child: TodoItem(
                          onDelete: () => _todoController.deleteTodo(index),
                          onToggle: (_) => _todoController.toggleTodo(index),
                          onUpdate: (newTitle) => _todoController.updateTodo(newTitle, index),
                          todo: todo,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AddTodoDialog(onAdd: _todoController.addTodo),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
