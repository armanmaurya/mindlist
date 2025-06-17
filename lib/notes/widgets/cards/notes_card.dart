import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_native/notes/models/note.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:todo_native/notes/screen/quill_editor_screen.dart';

class NotesCard extends StatelessWidget {
  final Note note;
  const NotesCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder:
                  (context) => QuillEditorScreen(
                    note: note,
                  ),
            ),
          );
        },
        leading: SizedBox(
          width: 28,
          height: 28,
          child: Center(
            child: Icon(
              Icons.note_alt_rounded,
              size: 28,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        title: Text(
          note.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timeago.format(note.lastUpdated, allowFromNow: true),
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
