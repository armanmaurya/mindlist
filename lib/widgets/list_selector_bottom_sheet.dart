import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_native/controllers/todo_controller.dart';
import 'package:todo_native/models/todo_list.dart';
import 'package:todo_native/screens/create_list_screen.dart';

class ListSelectorBottomSheet extends StatefulWidget {
  final TodoController todoController;

  const ListSelectorBottomSheet({Key? key, required this.todoController})
    : super(key: key);

  @override
  State<ListSelectorBottomSheet> createState() =>
      _ListSelectorBottomSheetState();
}

class _ListSelectorBottomSheetState extends State<ListSelectorBottomSheet> {
  bool _showCreatePanel = false;
  late List<TodoList> _allLists;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allLists = widget.todoController.getAllLists();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 100),
      padding: EdgeInsets.only(bottom: keyboardHeight),
      curve: Curves.easeInOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height:
            _showCreatePanel ? 200 : MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child:
            _showCreatePanel
                ? _buildCreateListPanel(theme)
                : _buildListViewPanel(theme),
      ),
    );
  }

  Widget _buildListTile(TodoList list, int index, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.list_alt_rounded, color: theme.primaryColor),
        ),
        title: Text(
          list.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: theme.textTheme.bodySmall?.color,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          widget.todoController.loadTodosForList(index);
          Navigator.of(context).pop();
        },
        onLongPress: () => _showDeleteDialog(context, index),
      ),
    );
  }

  Widget _buildCreateListPanel(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: theme.primaryColor),
                onPressed: () {
                  setState(() => _showCreatePanel = false);
                  _textController.clear();
                },
              ),
              Text(
                "New List",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  final text = _textController.text.trim();
                  if (text.isNotEmpty) {
                    widget.todoController.createList(text);
                    Navigator.of(context).pop(text);
                  }
                },
                child: const Text("Create"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "List name",
              filled: true,
              fillColor: theme.cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildListViewPanel(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Row(
            children: [
              Text(
                "Your Lists",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.search, color: theme.primaryColor),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child:
              _allLists.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.list_rounded,
                          size: 48,
                          color: theme.disabledColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No lists yet",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.disabledColor,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _allLists.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return _buildListTile(_allLists[index], index, theme);
                    },
                  ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_rounded),
            label: const Text("Create New List"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const CreateListScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete List?'),
          content: Text(
            'Are you sure you want to delete "${_allLists[index].title}"?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                widget.todoController.deleteList(index);
                setState(() {
                  _allLists = widget.todoController.getAllLists();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
