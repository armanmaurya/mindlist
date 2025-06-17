import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget content;

  const CustomDialog({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: content,
        ),
      ),
    );
  }
}
