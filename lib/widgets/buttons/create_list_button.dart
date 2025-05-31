import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_native/screens/create_list_screen.dart';

class CreateListButton extends StatelessWidget {
  const CreateListButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          if (onPressed != null) {
            onPressed!();
          } 
          // else {
          //   Navigator.of(context).pop();
          //   Navigator.of(context).push(
          //     CupertinoPageRoute(
          //       builder: (context) => const CreateListScreen(),
          //     ),
          //   );
          // }
        },
      ),
    );
  }
}
