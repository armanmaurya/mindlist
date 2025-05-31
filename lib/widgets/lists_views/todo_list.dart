import 'package:flutter/material.dart';
import 'package:todo_native/models/todo_list.dart';
import 'package:todo_native/widgets/list_tiles/todo_list_tile.dart';

class TodoListsView extends StatefulWidget {
  final List<TodoList> lists;
  final ThemeData theme;
  final void Function(String id)? onListSelected;
  final List<String> selectedListIds;
  final bool isSelectionModeEnabled;
  final void Function(List<String> selectedIds)? onSelectionChanged;

  const TodoListsView({
    super.key,
    required this.lists,
    required this.theme,
    this.onListSelected,
    this.selectedListIds = const [],
    this.onSelectionChanged,
    required this.isSelectionModeEnabled,
  });

  @override
  State<TodoListsView> createState() => _TodoListsViewState();
}

class _TodoListsViewState extends State<TodoListsView> {
  late List<String> _selectedIds;
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = List<String>.from(widget.selectedListIds);
    _selectionMode = widget.isSelectionModeEnabled;
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
      _selectionMode = _selectedIds.isNotEmpty;
      if (widget.onSelectionChanged != null) {
        widget.onSelectionChanged!(_selectedIds);
      }
    });
  }

  void _handleTap(String id) {
    if (_selectionMode) {
      _toggleSelection(id);
    } else if (widget.onListSelected != null) {
      widget.onListSelected!(id);
    }
  }

  void _handleListSelect(String id) {
    if (!_selectionMode) {
      setState(() {
        _selectionMode = true;
      });
    }
    _toggleSelection(id);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.lists.isEmpty
          ? const NoListsView()
          : ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: widget.lists.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final list = widget.lists[index];
                final isSelected = _selectedIds.contains(list.id);
                return TodoListTile(
                  isSelected: isSelected,
                  list: list,
                  theme: widget.theme,
                  onTap: () => _handleTap(list.id),
                  onLongPress: () => _handleListSelect(list.id),
                );
              },
            ),
    );
  }
}

class NoListsView extends StatelessWidget {
  const NoListsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
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
    );
  }
}
