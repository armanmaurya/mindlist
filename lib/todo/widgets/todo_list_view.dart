import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_native/todo/models/todo.dart';
import 'package:todo_native/todo/widgets/todo_item.dart';

class TodoListView extends StatelessWidget {
  final List<Todo> todos;
  const TodoListView({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return _buildListView(todos);
  }

  Widget _buildListView(List<Todo> todos) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItem(todo: todo);
      },
    );
  }
}
