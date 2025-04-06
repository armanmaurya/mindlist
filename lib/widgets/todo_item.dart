import 'package:flutter/material.dart';
import 'package:todo_native/models/todo.dart';
import 'package:todo_native/widgets/update_todo_dialog.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;
  final Function(bool? val) onToggle;
  final Function(String newTitle) onUpdate;
  final Function() onDelete;
  const TodoItem({
    super.key,
    required this.onToggle,
    required this.onUpdate,
    required this.onDelete,
    required this.todo,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: widget.todo.isDone ? Colors.grey[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Handle(
        delay: const Duration(milliseconds: 200),
        vibrate: false,
        child: ListTile(
          leading: Checkbox(
            shape: CircleBorder(),
            value: widget.todo.isDone,
            onChanged: (bool? value) {
              widget.onToggle(value);
            },
          ),
          title: Text(widget.todo.title),
          onTap: () async {
            await showDialog(
              context: context,
              builder:
                  (context) => UpdateTodoDialog(
                    onDelete: widget.onDelete,
                    onUpdate: widget.onUpdate,
                    initialValue: widget.todo.title,
                  ),
            );
          },
          onLongPress: () {},
        ),
      ),
    );
  }
}
