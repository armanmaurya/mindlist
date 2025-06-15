import 'package:flutter/material.dart';
import 'package:todo_native/screens/notes_screen.dart';
import 'package:todo_native/screens/todo_lists_screen.dart';
import 'package:todo_native/screens/quill_editor_screen.dart';

class HomePageViewScreen extends StatefulWidget {
  const HomePageViewScreen({super.key});

  @override
  State<HomePageViewScreen> createState() => _HomePageViewScreenState();
}

class _HomePageViewScreenState extends State<HomePageViewScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          TodoListsScreen(),
          NotesScreen(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Todo Lists',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note),
              label: 'Notes',
            ),
          ],
        ),
      ),
    );
  }
}
