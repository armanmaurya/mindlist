import 'package:flutter/material.dart';

class UpdateTodoDialog extends StatefulWidget {
  final Function(String title) onUpdate;
  final String initialValue;
  const UpdateTodoDialog({super.key, required this.onUpdate, required this.initialValue});

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
      title: Text("Update To-Do"),
      content: TextField(
        controller: controller,
        autocorrect: true,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: "Enter Title"
        ),
      ),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text("Cancel")),
        TextButton(onPressed: () {
          final text = controller.text.trim();
          if (text.isNotEmpty) {
            widget.onUpdate(text);
            Navigator.of(context).pop();
          }
        }, child: Text("Update")),
      ],
    );
  }
}