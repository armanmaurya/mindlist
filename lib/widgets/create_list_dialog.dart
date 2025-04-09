import 'package:flutter/material.dart';

class CreateListDialog extends StatelessWidget {
  final Function(String title) onCreate;
  const CreateListDialog({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: const Text("Create New List"),
      content: TextField(
        controller: controller,
        autocorrect: true,
        autofocus: true,
        decoration: const InputDecoration(hintText: "Enter list Title"),
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
              onCreate(text);
              Navigator.of(context).pop(text);
            }
          },
          child: const Text("Create"),
        ),
      ],
    );
  }
}