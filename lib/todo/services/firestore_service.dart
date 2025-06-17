import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_native/todo/models/todo.dart';
import 'package:todo_native/todo/models/todo_list.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user if not exists
  Future<void> createUserIfNotExists() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        await userDoc.set({
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  // Delete Todo item
  Future<void> deleteTodo({
    required String listId,
    required String todoId,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      await userDoc
          .collection('todoLists')
          .doc(listId)
          .collection('todos')
          .doc(todoId)
          .delete();
    }
  }

  Future<bool> deleteMultipleTodoLists(List<String> ids) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final userDoc = _firestore.collection('users').doc(user.uid);

    WriteBatch batch = _firestore.batch();

    try {
      for (String id in ids) {
        final todoListDoc = userDoc.collection('todoLists').doc(id);

        // Get all todos in the subcollection
        final todosSnapshot = await todoListDoc.collection('todos').get();

        // Delete all todos in batch
        for (final todoDoc in todosSnapshot.docs) {
          batch.delete(todoDoc.reference);
        }

        // Delete the todo list document itself
        batch.delete(todoListDoc);
      }

      await batch.commit();
      return true;
    } catch (e) {
      print("Error deleting multiple todo lists: $e");
      return false;
    }
  }

  // Create a new todo list and return the created TodoList
  Future<TodoList?> createTodoList({required String title}) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docRef = await userDoc.collection('todoLists').add({
        'title': title,
        'createdAt': FieldValue.serverTimestamp(),
      });
      final docSnapshot = await docRef.get();
      final data = docSnapshot.data();
      if (data != null) {
        data['id'] = docSnapshot.id;
        return TodoList.fromJson(data);
      }
    }
    return null;
  }

  // Delete a todo list
  Future<void> deleteTodoList({required String id}) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      await userDoc.collection('todoLists').doc(id).delete();
    }
  }

  // Update a todo list title
  Future<void> updateTodoList({
    required String id,
    required String newTitle,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      await userDoc.collection('todoLists').doc(id).update({
        'title': newTitle,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Create a new todo item in a specific todo list
  Future<bool> createTodo({
    required String title,
    required String listId,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      await userDoc.collection('todoLists').doc(listId).collection('todos').add(
        {
          'title': title,
          'isDone': false,
          'createdAt': FieldValue.serverTimestamp(),
        },
      );
      return true;
    }
    return false;
  }

  // Update a todo item in a specific todo list
  Future<void> toggleTodo({
    required String listId,
    required String todoId,
    required bool isDone,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      await userDoc
          .collection('todoLists')
          .doc(listId)
          .collection('todos')
          .doc(todoId)
          .update({
            'isDone': isDone,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    }
  }

  Future<void> updateTodo({
    required String listId,
    required String todoId,
    required String newTitle,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      await userDoc
          .collection('todoLists')
          .doc(listId)
          .collection('todos')
          .doc(todoId)
          .update({
            'title': newTitle,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    }
  }

  // Get todo list by ID
  Future<DocumentSnapshot<Map<String, dynamic>>?> getTodoListById({
    required String id,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      return await userDoc.collection('todoLists').doc(id).get();
    }
    return null; // Return null if user is not authenticated
  }

  // get all todo of the List not stream
  Future<List<Todo>> getTodos({required String listId}) async {
    final user = _auth.currentUser;
    if (user != null) {
      final querySnapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('todoLists')
              .doc(listId)
              .collection('todos')
              .orderBy('createdAt', descending: false)
              .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Inject the Firestore document ID
        return Todo.fromJson(data);
      }).toList();
    }
    return [];
  }

  Future<List<TodoList>> getTodoLists() async {
    final user = _auth.currentUser;
    if (user != null) {
      final querySnapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('todoLists')
              .orderBy('createdAt', descending: false)
              .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Inject the Firestore document ID
        return TodoList.fromJson(data);
      }).toList();
    }
    return [];
  }

  // Stream of todo in the List
  Stream<QuerySnapshot<Map<String, dynamic>>> todosStream(String listId) {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todoLists')
          .doc(listId)
          .collection('todos')
          .orderBy('createdAt', descending: false)
          .snapshots();
    } else {
      // Return an empty stream if not signed in
      return const Stream.empty();
    }
  }

  // Stream of todo lists for the current user
  Stream<QuerySnapshot<Map<String, dynamic>>> todoListsStream() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todoLists')
          .orderBy('createdAt', descending: false)
          .snapshots();
    } else {
      // Return an empty stream if not signed in
      return const Stream.empty();
    }
  }

  // Stream for a single todo list document by ID
  Stream<DocumentSnapshot<Map<String, dynamic>>> todoListDocStream(String id) {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('todoLists')
          .doc(id)
          .snapshots();
    } else {
      // Return an empty stream if not signed in
      return const Stream.empty();
    }
  }

  // Get the first todo list document for the user
  Future<DocumentSnapshot<Map<String, dynamic>>?> getFirstTodoList() async {
    final user = _auth.currentUser;
    if (user != null) {
      final query =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('todoLists')
              .orderBy('createdAt', descending: false)
              .limit(1)
              .get();
      if (query.docs.isNotEmpty) {
        return query.docs.first;
      }
    }
    return null;
  }
}
