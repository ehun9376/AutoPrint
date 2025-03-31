import 'package:auto_print/simple_widget/simple_text.dart';
import 'package:auto_print/widget_fixer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

abstract class MenuItemModel {
  late String displayName;
}

class MenuItem implements MenuItemModel {
  @override
  late String displayName;
  dynamic value;
  MenuItem({required this.displayName, this.value});
}

class SimpleDropdownMenu<T extends MenuItemModel> extends StatefulWidget {
  const SimpleDropdownMenu(
      {super.key,
      required this.onChange,
      required this.options,
      this.notChangeWhenTap,
      this.defaultValue,
      this.onTap,
      required this.fontSize,
      this.hint,
      this.height,
      this.width,
      this.borderRadius,
      this.borderColor,
      this.backgroundColor,
      this.textColor,
      this.hintColor});

  @override
  SimpleDropdownMenuState<T> createState() => SimpleDropdownMenuState<T>();

  final Function(T) onChange;
  final Function()? onTap;
  final List<T> options;
  final T? defaultValue;
  final double fontSize;
  final bool? notChangeWhenTap;
  final String? hint;

  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? hintColor;
}

class SimpleDropdownMenuState<T extends MenuItemModel>
    extends State<SimpleDropdownMenu<T>> {
  T? _selectedItem;
  late final List<T> _dropdownItems;
  late final Function(T) onChange;
  Function()? onTap;

  @override
  void initState() {
    _selectedItem = widget.defaultValue;
    _dropdownItems = widget.options;
    onChange = widget.onChange;
    onTap = widget.onTap;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SimpleDropdownMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options != oldWidget.options) {
      setState(() {
        _dropdownItems.clear();
        _dropdownItems.addAll(widget.options);
        if (!_dropdownItems.contains(_selectedItem)) {
          _selectedItem = widget.defaultValue;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //screenSize
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 15),
        border: Border.all(
          color: widget.borderColor ?? Colors.transparent,
        ),
        color: widget.backgroundColor,
      ),
      child: DropdownButton<T?>(
        isExpanded: true,
        itemHeight: widget.height,
        menuMaxHeight: height * 0.35,
        padding: const EdgeInsets.only(left: 10),
        borderRadius: BorderRadius.circular(15),
        hint: SimpleText(
          text: (widget.hint ?? ""),
          fontSize: widget.fontSize,
          textColor: widget.hintColor,
        ),
        underline: Container(),
        value: _dropdownItems.firstWhereOrNull(
          (element) => element.displayName == _selectedItem?.displayName,
        ),
        onChanged: (newValue) {
          if (!(widget.notChangeWhenTap ?? false)) {
            setState(() {
              _selectedItem = newValue;
            });
          }

          if (newValue != null) {
            onChange(newValue);
          }
        },
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        items: _dropdownItems.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: SimpleText(
              text: item.displayName,
              fontSize: widget.fontSize,
            ),
          );
        }).toList(),
      ).center(),
    );
  }
}
