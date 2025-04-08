import 'package:flutter/material.dart';
import 'package:todo_native/models/todo.dart';
import 'package:todo_native/models/todo_list.dart';
import 'package:todo_native/screens/home.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Setup Hive
  WidgetsFlutterBinding.ensureInitialized();
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
          Todo(title: 'Read Chapter 1', isDone: false),
          Todo(title: 'Revise Notes', isDone: false),
        ],
      ),
      TodoList(
        title: '🏠 Home',
        items: [
          Todo(title: 'Clean Room', isDone: false),
          Todo(title: 'Do Laundry', isDone: false),
        ],
      ),
      TodoList(
        title: '💻 Work',
        items: [
          Todo(title: 'Finish report', isDone: false),
          Todo(title: 'Reply to emails', isDone: false),
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftDo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}
