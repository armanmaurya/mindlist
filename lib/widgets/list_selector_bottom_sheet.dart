import 'package:flutter/material.dart';
import 'package:todo_native/controllers/todo_controller.dart';
import 'package:todo_native/widgets/create_list_dialog.dart';

class ListSelectorBottomSheet extends StatelessWidget {
  final TodoController todoController;

  const ListSelectorBottomSheet({Key? key, required this.todoController})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allList = todoController.getAllLists();
    if (allList.isEmpty) {
      return const Center(child: Text("No lists available"));
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.grey[100], // Changed to a light grey for better contrast
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: allList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      allList[index].title,
                      style: const TextStyle(
                        fontSize: 16, // Reduced font size for better spacing
                        fontWeight: FontWeight.w500, // Adjusted weight for readability
                        color: Colors.black87, // Slightly lighter black
                      ),
                    ),
                    onTap: () {
                      todoController.loadTodosForList(index);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Changed to blue for better visibility
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16), // Rounded top left corner 
                    topRight: Radius.circular(16), // Rounded top right corner
                  ), // Increased border radius
                ),
                padding: const EdgeInsets.symmetric(vertical: 12), // Adjusted padding
                minimumSize: const Size.fromHeight(48), // Ensures full width
              ),
              onPressed: () {
                Navigator.of(context).pop();
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: "Add Todo",
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeIn,
                        ),
                      ),
                      child: CreateListDialog(
                        onCreate: (todo) {
                          todoController.createNewList(todo);
                        },
                      ),
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 200),
                );
              },
              child: const Text(
                "New List",
                style: TextStyle(
                  fontSize: 16, // Reduced font size for consistency
                  fontWeight: FontWeight.w600, // Adjusted weight for emphasis
                  color: Colors.white, // Changed to white for better contrast
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
