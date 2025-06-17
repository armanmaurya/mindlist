import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_native/todo/models/todo.dart';
import 'package:todo_native/todo/providers/todo_list_provider.dart';
import 'package:todo_native/todo/services/firestore_service.dart';
import 'package:todo_native/shared/widgets/forms/text_edit_form.dart';
import 'package:todo_native/shared/widgets/bottom_sheets/menu_bottom_sheet.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    // Use theme color for the todo card
    final completedColor = theme.colorScheme.surfaceContainerHighest;
    final activeColor = theme.colorScheme.surfaceContainerLow;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.todo.isDone ? completedColor : activeColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          leading: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              value: widget.todo.isDone,
              onChanged: (value) async {
                final todoProvider = Provider.of<ListProvider>(
                  context,
                  listen: false,
                );
                final selectedList = todoProvider.selectedList;
                if (selectedList != null) {
                  await FirestoreService().toggleTodo(
                    listId: selectedList.id,
                    todoId: widget.todo.id,
                    isDone: value ?? false,
                  );
                }
              },
              activeColor: theme.colorScheme.primary,
              checkColor: isDarkMode ? Colors.black : Colors.white,
              side: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.6),
                width: 1.5,
              ),
            ),
          ),
          title: Text(
            widget.todo.title,
            style: theme.textTheme.bodyLarge?.copyWith(
              decoration:
                  widget.todo.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
              color:
                  widget.todo.isDone
                      ? theme.textTheme.bodyLarge?.color?.withOpacity(0.5)
                      : theme.textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
              color:
                  theme.brightness == Brightness.dark
                      ? theme.colorScheme.primary.withOpacity(0.85)
                      : theme.colorScheme.primary.withOpacity(0.7),
              size: 20,
            ),
            onPressed: () async {
              final todoProvider = Provider.of<ListProvider>(
                context,
                listen: false,
              );
              final selectedList = todoProvider.selectedList;
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return MenuBottomSheet(
                    onDelete: () async {
                      if (selectedList != null) {
                        await FirestoreService().deleteTodo(
                          listId: selectedList.id,
                          todoId: widget.todo.id,
                        );
                      }
                    },
                    onEdit: () {
                      Navigator.pop(context); // Close the menu
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        isDismissible: true,
                        builder: (context) {
                          return TextEditForm(
                            initialText: widget.todo.title,
                            onSave: (newText) async {
                              if (selectedList != null) {
                                FirestoreService().updateTodo(
                                  listId: selectedList.id,
                                  todoId: widget.todo.id,
                                  newTitle: newText,
                                );
                                Navigator.pop(context);
                              }
                            },
                            title: 'Edit Todo',
                            buttonText: 'Save',
                            hintText: 'Enter new todo title',
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
