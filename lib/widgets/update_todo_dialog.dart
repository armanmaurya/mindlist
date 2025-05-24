import 'package:flutter/material.dart';
import 'package:todo_native/controllers/todo_controller.dart';

class UpdateTodoBottomSheet extends StatefulWidget {
  final Function(String title) onUpdate;
  final Function() onDelete;
  final String initialValue;
  const UpdateTodoBottomSheet({
    super.key,
    required this.onUpdate,
    required this.initialValue,
    required this.onDelete,
  });

  @override
  State<UpdateTodoBottomSheet> createState() => _UpdateTodoBottomSheetState();
}

class _UpdateTodoBottomSheetState extends State<UpdateTodoBottomSheet> {
  late TextEditingController controller;
  
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Update Todo",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            autocorrect: true,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Enter Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
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
                          const SnackBar(content: Text("Duplicate Todo Title")),
                        );
                      }
                    }
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                widget.onDelete();
                Navigator.of(context).pop();
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}