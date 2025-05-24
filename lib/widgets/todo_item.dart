import 'package:flutter/material.dart';
import 'package:todo_native/models/todo.dart';
import 'package:todo_native/widgets/bottomSheets/delete_bottom_sheet.dart';
import 'package:todo_native/widgets/bottomSheets/menu_bottom_sheet.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;
  // final Function(bool? val) onToggle;
  // final Function(String newTitle) onUpdate;
  // final Function() onDelete;

  const TodoItem({
    super.key,
    // required this.onToggle,
    // required this.onUpdate,
    // required this.onDelete,
    required this.todo,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final completedColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;
    final activeColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;

    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: widget.todo.isDone ? completedColor : activeColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Handle(
          delay: const Duration(milliseconds: 100),
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
                  onChanged:(value) {
                    
                  },
                  activeColor: theme.colorScheme.primary,
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
                  color: theme.colorScheme.primary.withOpacity(0.7),
                  size: 20,
                ),
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return MenuBottomSheet(
                        onDelete: () {
                          
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
