import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_native/shared/widgets/dialogs/custom_dialog.dart';
import 'package:todo_native/shared/widgets/forms/text_edit_form.dart';

void showEditSheetOrDialog(BuildContext context, TextEditForm sheet) {
  final constraints = MediaQuery.of(context).size;
  if (constraints.width >= 700) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: CustomDialog(content: sheet),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeOut.transform(animation.value);
        return Transform.translate(
          offset: Offset(0, -100 + 100 * (1 - curvedValue)),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
    );
  } else {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) => sheet,
    );
  }
}
