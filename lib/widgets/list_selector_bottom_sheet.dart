import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_native/models/todo_list.dart';
import 'package:todo_native/providers/todo_list_provider.dart';
import 'package:todo_native/services/firestore_service.dart';
import 'package:todo_native/widgets/buttons/create_list_button.dart';
import 'package:todo_native/widgets/lists_views/todo_list.dart';

class ListSelectorBottomSheet extends StatefulWidget {
  final void Function(TodoList selectedList)? onListSelected;
  final void Function()? onCreateListBtnClicked;

  const ListSelectorBottomSheet({super.key, this.onListSelected, this.onCreateListBtnClicked});

  @override
  State<ListSelectorBottomSheet> createState() =>
      _ListSelectorBottomSheetState();
}

class _ListSelectorBottomSheetState extends State<ListSelectorBottomSheet> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    listProvider.fetchAllTodoLists();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Local state for selection
    List<String> _selectedListIds = [];
    bool _selectionMode = false;

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
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
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return Column(
            children: [
              Expanded(
                child: TodoListsView(
                  onSelectionChanged: (selectedIds) {
                    setModalState(() {
                      _selectedListIds = selectedIds;
                      _selectionMode = selectedIds.isNotEmpty;
                    });
                  },
                  selectedListIds: _selectedListIds,
                  isSelectionModeEnabled: _selectionMode,
                  lists: Provider.of<ListProvider>(context).todoLists,
                  theme: theme,
                  onListSelected: (id) {
                    final lists = Provider.of<ListProvider>(context, listen: false).todoLists;
                    final selectedList = lists.firstWhere((list) => list.id == id);
                    if (widget.onListSelected != null) {
                      widget.onListSelected!(selectedList);
                    }
                  },
                ),
              ),
              CreateListButton(
                onPressed: () {
                  if (widget.onCreateListBtnClicked != null) {
                    widget.onCreateListBtnClicked!();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
