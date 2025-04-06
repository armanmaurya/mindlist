import 'package:flutter/material.dart';

class UpdateTodoDialog extends StatefulWidget {
  final Function(String title) onUpdate;
  final Function() onDelete;
  final String initialValue;
  const UpdateTodoDialog({
    super.key,
    required this.onUpdate,
    required this.initialValue,
    required this.onDelete
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
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          Text("Update"),
          TextButton(
            onPressed: () {
              widget.onDelete();
              Navigator.of(context).pop();
            }, 
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.red)
            ),
            child: Text("Delete"),
          ),
        ],
      ),
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
          onPressed: () {
            final text = controller.text.trim();
            if (text.isNotEmpty) {
              widget.onUpdate(text);
              Navigator.of(context).pop();
            }
          },
          child: Text("Update"),
        ),
      ],
    );
  }
}
