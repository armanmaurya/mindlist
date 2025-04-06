import 'package:flutter/material.dart';

class AddTodoDialog extends StatelessWidget {
  final Function(String title) onAdd;
  const AddTodoDialog({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: const Text("Add Todo"),
      content: TextField(
        controller: controller,
        autocorrect: true,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: "Enter todo Title"
        ),
      ),
      actions: [
         TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final text = controller.text.trim();
            if (text.isNotEmpty) {
              onAdd(text);
              Navigator.of(context).pop();
            }
          },
          child: Text("Add"),
        ),
       
      ],
    );
  }
}