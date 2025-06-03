import 'package:flutter/material.dart';
import 'package:todo_native/models/todo_list.dart';

class TodoListTile extends StatelessWidget {
  final TodoList list;
  final ThemeData theme;
  final bool isSelected;
  final void Function() onLongPress;
  final void Function() onTap;

  const TodoListTile({
    super.key,
    required this.list,
    required this.theme,
    required this.isSelected,
    required this.onLongPress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withOpacity(0.1),
                width: 1.5,
              ),
              color:
                  isSelected
                      ? theme.colorScheme.primary.withOpacity(0.08)
                      : Colors.transparent,
            ),
            child: ListTile(
              leading: SizedBox(
                width: 44,
                height: 44,
                child: Center(child: Icon(Icons.list_alt_rounded, size: 22)),
              ),
              title: Text(
                list.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.4),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
