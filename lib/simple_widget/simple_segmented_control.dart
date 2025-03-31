import 'package:auto_print/simple_widget/simple_drop_down_menu.dart';
import 'package:auto_print/simple_widget/simple_text.dart';
import 'package:auto_print/widget_fixer.dart';
import 'package:flutter/material.dart';

class SimpleSegmentedControl extends StatefulWidget {
  const SimpleSegmentedControl({
    super.key,
    required this.list,
    required this.selectedItem,
    required this.onSelected,
  });

  final List<MenuItem> list;

  final MenuItem selectedItem;
  final Function(MenuItem) onSelected;

  @override
  SimpleSegmentedControlState createState() => SimpleSegmentedControlState();
}

class SimpleSegmentedControlState extends State<SimpleSegmentedControl> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
          children: widget.list.map((e) {
        bool isSelected = widget.selectedItem.displayName == e.displayName;
        return Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SimpleText(
            text: e.displayName,
            fontSize: 14,
            textColor: Colors.black,
            align: TextAlign.center,
          )
              .padding(const EdgeInsets.symmetric(horizontal: 10, vertical: 5))
              .inkWell(
            onTap: () {
              setState(() {
                widget.selectedItem.displayName = e.displayName;
                widget.onSelected(e);
              });
            },
          ),
        ).flexible();
      }).toList()),
    );
  }
}
