import 'package:auto_print/simple_widget/simple_image.dart';
import 'package:auto_print/simple_widget/simple_text.dart';
import 'package:flutter/material.dart';

enum PopMenuAction { edit, delete }

extension PopMenuActionExtension on PopMenuAction {
  String get actionString {
    switch (this) {
      case PopMenuAction.edit:
        return "Edit";
      case PopMenuAction.delete:
        return "Delete";
      default:
        return "";
    }
  }
}

class SimplePopupMenu extends StatelessWidget {
  const SimplePopupMenu(
      {super.key, required this.onSelected, required this.actions});

  final List<PopMenuAction> actions;

  final Function(PopMenuAction)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: const SimpleImage(
        icon: Icons.more_horiz,
        iconSize: 24,
        color: Colors.black,
      ),
      itemBuilder: (context) {
        return actions
            .map((e) => PopupMenuItem<PopMenuAction>(
                  value: e,
                  child: SimpleText(
                    text: e.actionString,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ))
            .toList();
      },
      onSelected: (value) async {
        onSelected?.call(value);
      },
    );
  }
}
