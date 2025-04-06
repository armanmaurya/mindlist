import 'package:flutter/material.dart';

class TodoItem extends StatefulWidget {
  bool isChecked;
  TodoItem({super.key, required this.isChecked});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(),
      child: Row(
        children: [
          Checkbox(
            shape: CircleBorder(),
            value: widget.isChecked,
            onChanged: (bool? value) {
              setState(() {
                widget.isChecked = value!;
              });
            },
          ),
          Text("Name"),
        ],
      ),
    );
  }
}
