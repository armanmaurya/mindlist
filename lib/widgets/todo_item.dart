import 'package:flutter/material.dart';
import 'package:todo_native/models/todo.dart';
import 'package:todo_native/widgets/update_todo_dialog.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;
  final Function(bool? val) onToggle;
  final Function(String newTitle) onUpdate;
  const TodoItem({
    super.key,
    required this.onToggle,
    required this.onUpdate,
    required this.todo,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5
      ),
      decoration: BoxDecoration(
        color: widget.todo.isDone ? Colors.grey[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: [
          Checkbox(
            shape: CircleBorder(),
            value: widget.todo.isDone,
            onChanged: (bool? value) {
              widget.onToggle(value);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              foregroundColor: widget.todo.isDone ? Colors.grey[600] : Colors.black,
            ),
            onPressed: () async {
              await showDialog(
                context: context,
                builder:
                    (context) => UpdateTodoDialog(
                      onUpdate: widget.onUpdate,
                      initialValue: widget.todo.title,
                    ),
              );
            },
            child: Text(widget.todo.title),
          ),
        ],
      ),
    );
  }
}
