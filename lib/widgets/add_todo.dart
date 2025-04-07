import 'package:flutter/material.dart';
import 'package:todo_native/controllers/todo_controller.dart';

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
        decoration: const InputDecoration(hintText: "Enter todo Title"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final text = controller.text.trim();
            if (text.isNotEmpty) {
              try {
                await onAdd(text);
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
          child: Text("Add"),
        ),
      ],
    );
  }
}
