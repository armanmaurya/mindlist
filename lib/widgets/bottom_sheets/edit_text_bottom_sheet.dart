import 'package:flutter/material.dart';
import 'package:todo_native/widgets/buttons/primary_buttom.dart';

class EditTextBottomSheet extends StatefulWidget {
  final void Function(String) onSave;
  final String? initialText;
  final String title;
  final String buttonText;
  final String hintText;
  const EditTextBottomSheet({
    super.key,
    required this.onSave,
    this.initialText,
    required this.title,
    required this.buttonText,
    required this.hintText,
  });

  @override
  State<EditTextBottomSheet> createState() => _EditTextBottomSheetState();
}

class _EditTextBottomSheetState extends State<EditTextBottomSheet> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? theme.cardColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            autofocus: true,
            maxLength: 28,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hintText,
              filled: true,
              fillColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: PrimaryButtom(
              text: widget.buttonText,
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  widget.onSave.call(text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
