import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_native/providers/todo_provider.dart';
import 'package:todo_native/services/firestore_service.dart';

class CreateListScreen extends StatelessWidget {
  const CreateListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController listNameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: listNameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "List name",
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final newListTitle = listNameController.text.trim();
                  final todoList = await FirestoreService().createTodoList(
                    title: newListTitle,
                  );

                  if (todoList != null) {
                    // Save the new list as selected in SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('selectedListId', todoList.id);
                    // Update the provider with the new list
                    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
                    todoProvider.setSelectedList(todoList);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to create list"),
                      ),
                    );
                  }
                },
                child: const Text("Create"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}