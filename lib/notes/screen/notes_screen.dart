import 'package:flutter/material.dart';
import 'package:todo_native/notes/models/note.dart';
import 'package:todo_native/shared/widgets/forms/edit_text_responsive_form.dart';
import 'package:todo_native/shared/widgets/forms/text_edit_form.dart';
import 'package:todo_native/notes/widgets/cards/notes_card.dart';
import 'package:todo_native/notes/services/notes_service.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    try {
      // Fetch notes snapshot from the service
      NotesService().getNotesSnapshot().listen((snapshot) {
        // Map the snapshot to a list of Note objects
        final notes =
            snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id; // Add the document ID to the data
              return Note.fromMap(data);
            }).toList();

        // Update the state with the fetched notes
        if (mounted) {
          setState(() {
            _notes = notes;
          });
        }
      });
    } catch (error) {
      // Handle error
      if (!context.mounted) return; // Check if context is still mounted
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching notes: $error')));
    }
  }

  void _handleSaveNote(String text) {
    // Handle the save action
    NotesService()
        .addNote(text)
        .then((value) {
          if (!context.mounted) return;
          Navigator.pop(context);
          // Optionally, you can refresh the notes list
          _fetchNotes();
        })
        .catchError((error) {
          // Handle error
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $error')));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children:
              _notes.map((note) {
                return NotesCard(note: note);
              }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showEditSheetOrDialog(
            context,
            TextEditForm(
              onSave: _handleSaveNote,
              title: 'Add Note',
              buttonText: 'Save',
              hintText: 'Enter your note here...',
            ),
          );
          // Navigator.pushNamed(context, '/quill-editor');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
