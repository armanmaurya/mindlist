import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_native/services/firestore_service.dart';
import 'package:todo_native/models/todo_list.dart';
import 'package:todo_native/widgets/bottomSheets/create_list_bottom_sheet.dart';
import 'package:todo_native/widgets/bottomSheets/delete_bottom_sheet.dart';
import 'package:todo_native/widgets/bottomSheets/edit_title_bottom_sheet.dart';
import 'package:todo_native/widgets/list_tiles/todo_list_tile.dart';
import 'package:todo_native/widgets/lists_views/todo_list.dart';
import 'package:todo_native/providers/todo_list_provider.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  List<String> _selectedListIds = [];
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    listProvider.fetchAllTodoLists();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleTap(String id) {
    if (_selectionMode) {
      toggleSelection(id);
    } else {}
  }

  void _handleLongPress(String id) {
    if (!_selectionMode) {
      setState(() {
        _selectionMode = true;
      });
    }
    toggleSelection(id);
  }

  void _selectAll() {
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    setState(() {
      _selectedListIds = listProvider.todoLists.map((list) => list.id).toList();
      _selectionMode = true;
    });
  }

  Future<void> _deleteSelected() async {
    if (_selectedListIds.isEmpty) return;
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return DeleteBottomSheet(
          onDelete: () async {
            final success = await FirestoreService().deleteMultipleTodoLists(
              _selectedListIds,
            );
            if (success) {
              setState(() {
                _selectedListIds.clear();
                _selectionMode = false;
              });
            }
          },
        );
      },
    );
  }

  void toggleSelection(String id) {
    setState(() {
      if (_selectedListIds.contains(id)) {
        _selectedListIds.remove(id);
      } else {
        _selectedListIds.add(id);
      }
      _selectionMode = _selectedListIds.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<ListProvider>(context);
    return Scaffold(
      appBar:
          _selectionMode
              ? AppBar(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                title: Text(
                  '${_selectedListIds.length} selected',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  color: theme.colorScheme.primary,
                  onPressed: () {
                    setState(() {
                      _selectedListIds.clear();
                      _selectionMode = false;
                    });
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.checklist_rtl_sharp),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      _selectAll();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: theme.colorScheme.primary,
                    onPressed: () async {
                      if (_selectedListIds.isEmpty) return;
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        isDismissible: true,
                        builder: (context) {
                          return DeleteBottomSheet(
                            onDelete: () async {
                              final success = await FirestoreService()
                                  .deleteMultipleTodoLists(_selectedListIds);
                              if (success) {
                                setState(() {
                                  _selectedListIds.clear();
                                  _selectionMode = false;
                                });
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                      );
                    },
                  ),

                  if (_selectedListIds.length == 1)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: theme.colorScheme.primary,
                      onPressed: () {
                        if (_selectedListIds.length != 1) return;
                        final selectedList = provider.todoLists.firstWhere(
                          (list) => list.id == _selectedListIds.first,
                        );
                        showModalBottomSheet(
                          context: context,
                          useSafeArea: true,
                          isScrollControlled: true,
                          isDismissible: true,
                          builder: (context) {
                            return EditTitleBottomSheet(
                              initialTitle: selectedList.title,
                              onSave: (newTitle) async {
                                await FirestoreService().updateTodo(
                                  listId: selectedList.id,
                                  todoId: _selectedListIds.first,
                                  newTitle: newTitle,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                ],
              )
              : AppBar(title: const Text('Todo Lists')),
      body: Consumer<ListProvider>(
        builder: (context, provider, _) {
          return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            itemCount: provider.todoLists.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8.0),
            itemBuilder: (context, index) {
              final list = provider.todoLists[index];
              return TodoListTile(
                list: list,
                isSelected: _selectedListIds.contains(list.id),
                theme: theme,
                onTap: () {
                  handleTap(list.id);
                },
                onLongPress: () {
                  _handleLongPress(list.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder:
            (child, animation) =>
                ScaleTransition(scale: animation, child: child),
        child:
            !_selectionMode
                ? FloatingActionButton(
                  key: const ValueKey('fab'),
                  onPressed: () {
                    showModalBottomSheet(
                      useSafeArea: true,
                      isScrollControlled: true,
                      isDismissible: true,
                      context: context,
                      builder: (context) {
                        return CreateListBottomSheet(
                          onListCreated: (title) {
                            FirestoreService().createTodoList(title: title);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.add),
                )
                : const SizedBox.shrink(key: ValueKey('empty')),
      ),
    );
  }
}
