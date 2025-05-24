import 'package:flutter/material.dart';
import 'package:todo_native/models/todo.dart';
import 'package:todo_native/models/todo_list.dart';
import 'package:todo_native/screens/home_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_native/screens/google_signin_screen.dart';

void main() async {
  // Setup Hive
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  // Register the adapter
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(TodoListAdapter());

  // Open the box
  final todoBox = await Hive.openBox<TodoList>('todoLists');
  // Add a default list if the box is empty
  if (todoBox.isEmpty) {
    await todoBox.addAll([
      TodoList(
        title: '📝 Study',
        items: [
          Todo(title: 'Read Chapter 1', isDone: false, id: '1'),
          Todo(title: 'Revise Notes', isDone: false, id: '2'),
        ],
      ),
      TodoList(
        title: '🏠 Home',
        items: [
          Todo(title: 'Clean Room', isDone: false, id: '3'),
          Todo(title: 'Do Laundry', isDone: false, id: '4'),
        ],
      ),
      TodoList(
        title: '💻 Work',
        items: [
          Todo(title: 'Finish report', isDone: false, id: '5'),
          Todo(title: 'Reply to emails', isDone: false, id: '6'),
        ],
      ),
    ]);
  }

  // Load the initial data
  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftDo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return HomeScreen();
          } else {
            return const GoogleSignInScreen();
          }
        },
      ),
    );
  }
}
