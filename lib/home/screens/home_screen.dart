import 'package:flutter/material.dart';
import 'package:todo_native/notes/screen/notes_screen.dart';
import 'package:todo_native/todo/screens/todo_lists_screen.dart';

class HomePageViewScreen extends StatefulWidget {
  const HomePageViewScreen({super.key});

  @override
  State<HomePageViewScreen> createState() => _HomePageViewScreenState();
}

class _HomePageViewScreenState extends State<HomePageViewScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = const [TodoListsScreen(), NotesScreen()];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use left navigation for wide screens (web/desktop), bottom nav for narrow/mobile
        if (constraints.maxWidth >= 700) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.list_alt),
                      label: Text('Todo Lists'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.note),
                      label: Text('Notes'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: _pages,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: _pages,
            ),
            bottomNavigationBar: Theme(
              data: Theme.of(
                context,
              ).copyWith(splashFactory: NoSplash.splashFactory),
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
      },
    );
  }
}
