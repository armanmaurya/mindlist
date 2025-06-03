import 'package:flutter/material.dart';
import 'package:todo_native/widgets/bottom_sheets/delete_confirmation_bottom_sheet.dart';

class MenuBottomSheet extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MenuBottomSheet({super.key, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    // final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit option
            _MenuTile(
              icon: Icons.edit_outlined,
              title: 'Edit',
              color: colors.primary,
              onTap: () {
                if (onEdit != null) onEdit!();
              },
            ),
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                thickness: 1,
                color: colors.outline.withOpacity(0.1),
              ),
            ),
            // Delete option
            _MenuTile(
              icon: Icons.delete_outline,
              title: 'Delete',
              color: colors.error,
              onTap: () {
                Navigator.of(context).pop();
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return DeleteBottomSheet(
                      onDelete: () {
                        if (onDelete != null) onDelete!();
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 8), // Extra bottom padding
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withOpacity(0.3),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      minLeadingWidth: 0,
    );
  }
}
