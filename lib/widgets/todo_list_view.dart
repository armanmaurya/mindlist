import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:todo_native/controllers/todo_controller.dart';
import 'package:todo_native/models/todo.dart';
import 'package:todo_native/widgets/todo_item.dart';

// class TodoListView extends StatefulWidget {
//   const TodoListView({super.key});

//   @override
//   State<TodoListView> createState() => _TodoListViewState();
// }

class TodoListView extends StatelessWidget{
  final TodoController controller;

  const TodoListView({
    super.key,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Todo>>(
      valueListenable: controller.todos,
      builder: (context, todos, _) {
        if (todos.isEmpty) {
          return const Center(child: Text("List is Empty"));
        }

        return _buildListView(todos);
      },
    );
  }

  Widget _buildListView(List<Todo> todos) {
    return ImplicitlyAnimatedReorderableList<Todo>(
      onReorderStarted:(item, index) {
        // Print dragging
        print("Dragging $item at index $index");
      },
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      items: todos,
      areItemsTheSame: (oldItem, newItem) => oldItem.title == newItem.title,
      onReorderFinished: (item, from, to, newItems) {
        controller.saveReorderedTodos(newItems);
      },
      itemBuilder: (context, itemAnimation, todo, index) {
        return Reorderable(
          key: ValueKey(todo.title),
          builder: (context, dragAnimation, inDrag) {
            final t = dragAnimation.value;
            final elevation = lerpDouble(0, 8, t);
            final color = Color.lerp(
              Colors.white,
              Colors.white.withValues(alpha: 0.8),
              t,
            );
            return SizeFadeTransition(
              sizeFraction: 0.7,
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
                    onDelete: () => controller.deleteTodo(index),
                    onToggle: (_) => controller.toggleTodo(index),
                    onUpdate:
                        (newTitle) => controller.updateTodo(newTitle, index),
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
}
