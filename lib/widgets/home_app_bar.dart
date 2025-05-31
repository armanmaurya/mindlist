import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_native/models/todo_list.dart';
import 'package:todo_native/providers/todo_provider.dart';
import 'package:todo_native/screens/create_list_screen.dart';
import 'package:todo_native/services/firestore_service.dart';
import 'package:todo_native/widgets/list_selector_bottom_sheet.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  void initState() {
    super.initState();
    _loadSelectedListFromPrefs();
  }

  Future<void> _loadSelectedListFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedListId = prefs.getString('selectedListId');
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    if (selectedListId != null && selectedListId.isNotEmpty) {
      final doc =
          await FirestoreService().todoListDocStream(selectedListId).first;
      if (doc.exists) {
        final selectedList = TodoList.fromJson(doc.data()!..['id'] = doc.id);
        todoProvider.setSelectedList(selectedList);
      }
    } else {
      final firstDoc = await FirestoreService().getFirstTodoList();
      if (firstDoc != null) {
        final doc =
            await FirestoreService().todoListDocStream(firstDoc.id).first;
        if (doc.exists) {
          final selectedList = TodoList.fromJson(doc.data()!..['id'] = doc.id);
          todoProvider.setSelectedList(selectedList);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final selectedList = todoProvider.selectedList;
    return AppBar(
      title: IntrinsicWidth(
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            // final selectedListId = await Navigator.of(context).push(
            //   CupertinoPageRoute(builder: (context) => ListsScreen()),
            // );
            showModalBottomSheet(
              useSafeArea: true,
              isScrollControlled: true,
              isDismissible: true,
              context: context,
              builder: (context) => ListSelectorBottomSheet(
                onListSelected: (selectedList) async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('selectedListId', selectedList.id);
                  todoProvider.setSelectedList(selectedList);
                  Navigator.of(context).pop();
                },
                onCreateListBtnClicked: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const CreateListScreen(),
                    ),
                  );
                },
              ),
            );
          },
          child: Row(
            children: [
              Flexible(
                child: Text(
                  selectedList != null ? selectedList.title : 'No List',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const Icon(
                Icons.arrow_right_outlined,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
