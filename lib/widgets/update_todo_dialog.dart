import 'package:flutter/material.dart';
import 'package:todo_native/controllers/todo_controller.dart';

class UpdateTodoDialog extends StatefulWidget {
  final Function(String title) onUpdate;
  final Function() onDelete;
  final String initialValue;
  const UpdateTodoDialog({
    super.key,
    required this.onUpdate,
    required this.initialValue,
    required this.onDelete,
  });

  @override
  State<UpdateTodoDialog> createState() => _UpdateTodoDialogState();
}

class _UpdateTodoDialogState extends State<UpdateTodoDialog> {
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Update"),
      content: TextField(
        controller: controller,
        autocorrect: true,
        autofocus: true,
        decoration: const InputDecoration(hintText: "Enter Title"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            final text = controller.text.trim();
            if (text.isNotEmpty) {
              try {
                await widget.onUpdate(text);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } on DuplicateTodoTitleException {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Duplicate Todo Title")),
                  );
                }
              }
            }
          },
          child: Text("Update"),
        ),
      ],
    );
  }
}
