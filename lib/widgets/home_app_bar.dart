import 'package:flutter/material.dart';
import 'package:todo_native/controllers/todo_controller.dart';
import 'package:todo_native/widgets/list_selector_bottom_sheet.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TodoController todoController;

  const HomeAppBar({super.key, required this.todoController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: IntrinsicWidth(
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return ListSelectorBottomSheet(
                  todoController: todoController,
                );
              },
            );
          },
          child: Row(
            children: [
              ValueListenableBuilder<String>(
                valueListenable: todoController.currentTitle,
                builder: (context, title, child) {
                  return Text(
                    title,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  );
                },
              ),
              const Icon(Icons.arrow_drop_down, color: Color.fromARGB(255, 0, 0, 0)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
