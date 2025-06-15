import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_native/models/note.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addNote(String title) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    final note = Note(
      title: title,
      data: null,
      lastUpdated: DateTime.now(),
      createdAt: DateTime.now(),
    );
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .add(note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    final snapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notes')
            .orderBy('lastUpdated', descending: true)
            .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add the document ID to the Note object
      return Note.fromMap(data);
    }).toList();
  }

  Future<void> updateNote(Note note) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(note.id)
        .update(note.toMap());
  }

  Future<void> updateNoteData(String id, String json) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(id)
        .update({
          'data': json,
          'lastUpdated': DateTime.now().toIso8601String(),
        });
  }

  Future<void> updateNoteTitle(String id, String title) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(id)
        .update({
          'title': title,
          'lastUpdated': DateTime.now().toIso8601String(),
        });
  }

  Future<void> deleteNote(String id) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(id)
        .delete();
  }

  Future<void> deleteMultipleNotes(List<String> ids) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    WriteBatch batch = _firestore.batch();

    for (String id in ids) {
      final noteDoc = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notes')
          .doc(id);
      batch.delete(noteDoc);
    }

    await batch.commit();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotesSnapshot() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.empty(); // Return an empty stream if user is not authenticated
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .snapshots();
  }
}
